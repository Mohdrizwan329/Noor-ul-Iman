#!/usr/bin/env node
/**
 * Push prayer times screen content to Firebase Firestore
 * Uses Firebase CLI's stored credentials (no service account key needed)
 *
 * Usage: node scripts/push_prayer_times_content_to_firebase.js
 *
 * This pushes prayer_times_content.json to:
 *   Collection: prayer_times_screen_content
 *   Document: data
 */

const https = require('https');
const fs = require('fs');
const path = require('path');

const PROJECT_ID = 'noor-ul-iman';
const JSON_FILE = path.resolve(__dirname, '..', 'assets', 'data', 'firebase', 'prayer_times_content.json');
const COLLECTION = 'prayer_times_screen_content';
const DOC_ID = 'data';

if (!fs.existsSync(JSON_FILE)) {
  console.error(`ERROR: File not found: ${JSON_FILE}`);
  process.exit(1);
}

// Read the Firebase CLI config to get the refresh token
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

// Exchange refresh token for access token
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

// Convert a JS value to Firestore Value format
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

// Convert a JS object to Firestore document format
function toFirestoreDoc(obj) {
  const fields = {};
  for (const [key, value] of Object.entries(obj)) {
    fields[key] = toFirestoreValue(value);
  }
  return { fields };
}

// Make a Firestore REST API request
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
  console.log('=== Push Prayer Times Screen Content to Firebase ===\n');
  console.log(`Reading data from: ${JSON_FILE}`);
  const data = JSON.parse(fs.readFileSync(JSON_FILE, 'utf8'));

  console.log(`Data loaded:`);
  console.log(`  - Prayer items: ${data.prayer_items ? data.prayer_items.length : 0}`);
  console.log(`  - Strings: ${data.strings ? Object.keys(data.strings).length : 0}`);
  console.log(`  - Gregorian months: ${data.gregorian_months ? Object.keys(data.gregorian_months).length : 0}`);
  console.log(`  - Hijri months: ${data.hijri_months ? Object.keys(data.hijri_months).length : 0}`);

  // Get credentials
  const creds = getRefreshToken();
  if (!creds) {
    console.error('\nERROR: Firebase CLI credentials not found.');
    console.error('Run: firebase login');
    process.exit(1);
  }

  console.log('\nGetting access token...');
  const accessToken = await getAccessToken(creds.token, creds.clientId, creds.clientSecret);
  console.log('Access token obtained.');

  // Push main document
  console.log(`\nPushing to Firestore: ${COLLECTION}/${DOC_ID}...`);
  const firestoreDoc = toFirestoreDoc(data);

  await firestoreRequest(accessToken, 'PATCH', `${COLLECTION}/${DOC_ID}`, firestoreDoc);
  console.log(`Document ${COLLECTION}/${DOC_ID} pushed successfully!`);

  // Update version metadata
  console.log('Updating content version...');
  let currentVersion = 0;
  try {
    const existing = await firestoreRequest(accessToken, 'GET', 'content_metadata/versions');
    if (existing.fields && existing.fields.prayer_times_screen_content_version) {
      const vField = existing.fields.prayer_times_screen_content_version;
      currentVersion = parseInt(vField.integerValue || '0');
    }
  } catch (_) {
    // Document might not exist yet
  }

  const versionDoc = toFirestoreDoc({
    prayer_times_screen_content_version: currentVersion + 1,
    last_updated: new Date().toISOString(),
  });

  await firestoreRequest(accessToken, 'PATCH', 'content_metadata/versions', versionDoc);
  console.log(`Version updated to ${currentVersion + 1}!`);

  console.log('\n=== All done! Prayer times screen content pushed to Firebase. ===');
  console.log(`Collection: ${COLLECTION}`);
  console.log(`Document: ${DOC_ID}`);
  console.log(`Total strings: ${Object.keys(data.strings).length}`);
  console.log(`Total prayer items: ${data.prayer_items.length}`);
  console.log(`Languages: English, Urdu, Hindi, Arabic`);
}

main().catch((err) => {
  console.error('Error:', err.message);
  process.exit(1);
});
