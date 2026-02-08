#!/usr/bin/env node
/**
 * Push Khalifa (Rightly Guided Caliphs) Names data to Firebase Firestore
 *
 * Usage:
 *   1. Download your Firebase service account key from Firebase Console:
 *      Project Settings -> Service Accounts -> Generate New Private Key
 *   2. Save it as: scripts/serviceAccountKey.json
 *   3. Run: node scripts/push_khalifas_to_firebase.js
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

async function pushKhalifaData() {
  console.log('Loading khalifa_names.json...');
  const khalifaData = JSON.parse(
    fs.readFileSync(path.join(__dirname, '..', 'assets', 'data', 'firebase', 'khalifa_names.json'), 'utf8')
  );

  console.log(`Found ${khalifaData.names.length} khalifas`);

  // Push to islamic_names/khalifas
  console.log('Pushing to islamic_names/khalifas...');
  await db.collection('islamic_names').doc('khalifas').set(khalifaData);
  console.log('Khalifa data pushed successfully!');

  // Update content version
  console.log('Updating content version...');
  const versionsRef = db.collection('content_metadata').doc('versions');
  const versionsDoc = await versionsRef.get();

  const currentVersions = versionsDoc.exists ? versionsDoc.data() : {};
  await versionsRef.set({
    ...currentVersions,
    islamic_names_version: (currentVersions.islamic_names_version || 0) + 1,
    last_updated: new Date().toISOString(),
  }, { merge: true });

  console.log('Content version updated!');
  console.log('\nAll done! Khalifa data has been pushed to Firebase.');
  console.log(`Total khalifas: ${khalifaData.names.length}`);
  console.log('Collection: islamic_names');
  console.log('Document: khalifas');
}

pushKhalifaData().catch((error) => {
  console.error('Error:', error);
  process.exit(1);
});
