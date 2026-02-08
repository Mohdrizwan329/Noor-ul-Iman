#!/usr/bin/env node
/**
 * Push Islamic Name Transliterations & Biographical Translations to Firebase Firestore
 *
 * Usage:
 *   1. Download your Firebase service account key from Firebase Console:
 *      Project Settings -> Service Accounts -> Generate New Private Key
 *   2. Save it as: scripts/serviceAccountKey.json
 *   3. Run: node scripts/push_transliterations_to_firebase.js
 */

const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const fs = require('fs');
const path = require('path');

// Initialize Firebase Admin
const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');
if (!fs.existsSync(serviceAccountPath)) {
  console.error('ERROR: serviceAccountKey.json not found!');
  console.error('Download it from Firebase Console > Project Settings > Service Accounts');
  console.error('Save it as: scripts/serviceAccountKey.json');
  process.exit(1);
}

const serviceAccount = require(serviceAccountPath);

initializeApp({
  credential: cert(serviceAccount),
});

const db = getFirestore();

async function pushTransliterations() {
  // 1. Push Islamic Names transliterations
  console.log('Loading islamic_names_transliterations.json...');
  const nameData = JSON.parse(
    fs.readFileSync(path.join(__dirname, '..', 'assets', 'data', 'firebase', 'islamic_names_transliterations.json'), 'utf8')
  );
  console.log(`Found ${Object.keys(nameData.hindi || {}).length} Hindi name transliterations`);
  console.log(`Found ${Object.keys(nameData.urdu || {}).length} Urdu name transliterations`);

  console.log('Pushing to name_transliterations/islamic_names...');
  await db.collection('name_transliterations').doc('islamic_names').set(nameData);
  console.log('Islamic name transliterations pushed successfully!');

  // 2. Push Biographical translations
  console.log('\nLoading biographical_transliterations.json...');
  const bioData = JSON.parse(
    fs.readFileSync(path.join(__dirname, '..', 'assets', 'data', 'firebase', 'biographical_transliterations.json'), 'utf8')
  );
  console.log(`Found ${Object.keys(bioData.hindi || {}).length} Hindi biographical translations`);
  console.log(`Found ${Object.keys(bioData.urdu || {}).length} Urdu biographical translations`);

  console.log('Pushing to name_transliterations/biographical...');
  await db.collection('name_transliterations').doc('biographical').set(bioData);
  console.log('Biographical translations pushed successfully!');

  // 3. Update content version
  console.log('\nUpdating content version...');
  const versionsRef = db.collection('content_metadata').doc('versions');
  const versionsDoc = await versionsRef.get();

  const currentVersions = versionsDoc.exists ? versionsDoc.data() : {};
  await versionsRef.set({
    ...currentVersions,
    name_transliterations_version: (currentVersions.name_transliterations_version || 0) + 1,
    last_updated: new Date().toISOString(),
  }, { merge: true });

  console.log('Content version updated!');
  console.log('\nAll done! Transliteration data has been pushed to Firebase.');
  console.log('Collections: name_transliterations');
  console.log('Documents: islamic_names, biographical');
}

pushTransliterations().catch((error) => {
  console.error('Error:', error);
  process.exit(1);
});
