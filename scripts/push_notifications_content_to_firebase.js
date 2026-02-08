#!/usr/bin/env node
/**
 * Push notifications screen content to Firebase Firestore
 * Uses Firebase CLI's stored credentials (no service account key needed)
 *
 * Usage: node scripts/push_notifications_content_to_firebase.js
 *
 * This pushes notifications_screen_content.json to:
 *   Collection: notifications_screen_content
 *   Document: data
 */

const https = require('https');
const fs = require('fs');
const path = require('path');

const PROJECT_ID = 'noor-ul-iman';
const JSON_FILE = path.resolve(__dirname, '..', 'assets', 'data', 'firebase', 'notifications_screen_content.json');
const COLLECTION = 'notifications_screen_content';
const DOC_ID = 'data';

if (!fs.existsSync(JSON_FILE)) {
  console.error(`ERROR: File not found: ${JSON_FILE}`);
  process.exit(1);
}

function getRefreshToken() {
  const configPaths = [
    path.join(process.env.HOME, '.config', 'configstore', 'firebase-tools.json'),
    path.join(process.env.HOME, '.config', 'firebase', 'config.json'),
  ];

  for (const configPath of configPaths) {
    if (fs.existsSync(configPath)) {
      const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
      if (config.tokens && config.tokens.refresh_token) {
        return { token: config.tokens.refresh_token, clientId: config.tokens.client_id, clientSecret: config.tokens.client_secret };
      }
      if (config.refreshToken) {
        return { token: config.refreshToken };
      }
    }
  }
  return null;
}

function getAccessToken(refreshToken, clientId, clientSecret) {
  return new Promise((resolve, reject) => {
    const cId = clientId || '563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com';
    const cSecret = clientSecret || 'j9iVZfS8kkCEFUPaAeJV0sAi';

    const postData = `grant_type=refresh_token&refresh_token=${encodeURIComponent(refreshToken)}&client_id=${encodeURIComponent(cId)}&client_secret=${encodeURIComponent(cSecret)}`;

    const req = https.request({
      hostname: 'oauth2.googleapis.com',
      path: '/token',
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(postData),
      },
    }, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        const parsed = JSON.parse(data);
        if (parsed.access_token) {
          resolve(parsed.access_token);
        } else {
          reject(new Error(`Token error: ${data}`));
        }
      });
    });
    req.on('error', reject);
    req.write(postData);
    req.end();
  });
}

function toFirestoreValue(value) {
  if (value === null || value === undefined) {
    return { nullValue: null };
  }
  if (typeof value === 'string') {
    return { stringValue: value };
  }
  if (typeof value === 'number') {
    if (Number.isInteger(value)) {
      return { integerValue: String(value) };
    }
    return { doubleValue: value };
  }
  if (typeof value === 'boolean') {
    return { booleanValue: value };
  }
  if (Array.isArray(value)) {
    return {
      arrayValue: {
        values: value.map(toFirestoreValue),
      },
    };
  }
  if (typeof value === 'object') {
    const fields = {};
    for (const [k, v] of Object.entries(value)) {
      fields[k] = toFirestoreValue(v);
    }
    return { mapValue: { fields } };
  }
  return { stringValue: String(value) };
}

function toFirestoreDoc(obj) {
  const fields = {};
  for (const [key, value] of Object.entries(obj)) {
    fields[key] = toFirestoreValue(value);
  }
  return { fields };
}

function firestoreRequest(accessToken, method, docPath, body) {
  return new Promise((resolve, reject) => {
    const urlPath = `/v1/projects/${PROJECT_ID}/databases/(default)/documents/${docPath}`;
    const postData = body ? JSON.stringify(body) : '';

    const options = {
      hostname: 'firestore.googleapis.com',
      path: urlPath,
      method: method,
      headers: {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
    };

    if (body) {
      options.headers['Content-Length'] = Buffer.byteLength(postData);
    }

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(JSON.parse(data || '{}'));
        } else {
          reject(new Error(`HTTP ${res.statusCode}: ${data}`));
        }
      });
    });
    req.on('error', reject);
    if (body) req.write(postData);
    req.end();
  });
}

async function main() {
  console.log('=== Push Notifications Screen Content to Firebase ===\n');
  console.log(`Reading data from: ${JSON_FILE}`);
  const data = JSON.parse(fs.readFileSync(JSON_FILE, 'utf8'));

  console.log(`Data loaded:`);
  console.log(`  - Strings: ${data.strings ? Object.keys(data.strings).length : 0}`);
  console.log(`  - Day names: ${data.day_names ? Object.keys(data.day_names).length : 0}`);
  console.log(`  - Month abbreviations: ${data.month_abbreviations ? Object.keys(data.month_abbreviations).length : 0}`);

  const creds = getRefreshToken();
  if (!creds) {
    console.error('\nERROR: Firebase CLI credentials not found.');
    console.error('Run: firebase login');
    process.exit(1);
  }

  console.log('\nGetting access token...');
  const accessToken = await getAccessToken(creds.token, creds.clientId, creds.clientSecret);
  console.log('Access token obtained.');

  console.log(`\nPushing to Firestore: ${COLLECTION}/${DOC_ID}...`);
  const firestoreDoc = toFirestoreDoc(data);

  await firestoreRequest(accessToken, 'PATCH', `${COLLECTION}/${DOC_ID}`, firestoreDoc);
  console.log(`Document ${COLLECTION}/${DOC_ID} pushed successfully!`);

  console.log('Updating content version...');
  let currentVersion = 0;
  try {
    const existing = await firestoreRequest(accessToken, 'GET', 'content_metadata/versions');
    if (existing.fields && existing.fields.notifications_screen_content_version) {
      const vField = existing.fields.notifications_screen_content_version;
      currentVersion = parseInt(vField.integerValue || '0');
    }
  } catch (_) {
    // Document might not exist yet
  }

  const versionDoc = toFirestoreDoc({
    notifications_screen_content_version: currentVersion + 1,
    last_updated: new Date().toISOString(),
  });

  await firestoreRequest(accessToken, 'PATCH', 'content_metadata/versions', versionDoc);
  console.log(`Version updated to ${currentVersion + 1}!`);

  console.log('\n=== All done! Notifications screen content pushed to Firebase. ===');
  console.log(`Collection: ${COLLECTION}`);
  console.log(`Document: ${DOC_ID}`);
  console.log(`Languages: English, Urdu, Hindi, Arabic`);
}

main().catch((err) => {
  console.error('Error:', err.message);
  process.exit(1);
});
