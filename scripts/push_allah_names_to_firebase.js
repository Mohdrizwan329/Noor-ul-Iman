#!/usr/bin/env node
/**
 * Push Allah Names data to Firebase Firestore
 *
 * Usage:
 *   1. Download your Firebase service account key from Firebase Console:
 *      Project Settings -> Service Accounts -> Generate New Private Key
 *   2. Save it as: scripts/serviceAccountKey.json
 *   3. Run: node scripts/push_allah_names_to_firebase.js
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

async function pushAllahNames() {
  console.log('Loading allah_names.json...');
  const namesData = JSON.parse(
    fs.readFileSync(path.join(__dirname, '..', 'assets', 'data', 'firebase', 'allah_names.json'), 'utf8')
  );

  console.log(`Found ${namesData.names.length} names`);

  // Push to allah_names/all_names
  console.log('Pushing to allah_names/all_names...');
  await db.collection('allah_names').doc('all_names').set(namesData);
  console.log('Allah names pushed successfully!');

  // Push transliterations
  console.log('Loading allah_names_transliterations.json...');
  const transliterations = JSON.parse(
    fs.readFileSync(path.join(__dirname, '..', 'assets', 'data', 'firebase', 'allah_names_transliterations.json'), 'utf8')
  );

  console.log('Pushing to name_transliterations/allah_names...');
  await db.collection('name_transliterations').doc('allah_names').set(transliterations);
  console.log('Transliterations pushed successfully!');

  // Update content version
  console.log('Updating content version...');
  const versionsRef = db.collection('content_metadata').doc('versions');
  const versionsDoc = await versionsRef.get();

  const currentVersions = versionsDoc.exists ? versionsDoc.data() : {};
  await versionsRef.set({
    ...currentVersions,
    allah_names_version: (currentVersions.allah_names_version || 0) + 1,
    name_transliterations_version: (currentVersions.name_transliterations_version || 0) + 1,
    last_updated: new Date().toISOString(),
  }, { merge: true });

  console.log('Content version updated!');
  console.log('\nAll done! Data has been pushed to Firebase.');
}

pushAllahNames().catch((error) => {
  console.error('Error:', error);
  process.exit(1);
});
