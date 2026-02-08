#!/usr/bin/env node
/**
 * Push Namaz Fazilat data to Firebase Firestore
 *
 * Usage:
 *   1. Download your Firebase service account key from Firebase Console:
 *      Project Settings -> Service Accounts -> Generate New Private Key
 *   2. Save it as: scripts/serviceAccountKey.json
 *   3. Run: node scripts/push_namaz_fazilat_to_firebase.js
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

async function pushNamazFazilat() {
  const dataPath = path.join(__dirname, '..', 'assets', 'data', 'firebase', 'namaz_fazilat.json');
  if (!fs.existsSync(dataPath)) {
    console.error('ERROR: namaz_fazilat.json not found!');
    process.exit(1);
  }

  console.log('Loading namaz_fazilat.json...');
  const data = JSON.parse(fs.readFileSync(dataPath, 'utf8'));

  console.log(`Found ${data.steps.length} namaz fazilat items`);

  // Push to basic_amal/namaz_fazilat
  console.log('Pushing to basic_amal/namaz_fazilat...');
  await db.collection('basic_amal').doc('namaz_fazilat').set(data);
  console.log('Namaz Fazilat pushed successfully!');

  // Update content version
  console.log('Updating content version...');
  const versionsRef = db.collection('content_metadata').doc('versions');
  const versionsDoc = await versionsRef.get();

  const currentVersions = versionsDoc.exists ? versionsDoc.data() : {};
  await versionsRef.set({
    ...currentVersions,
    basic_amal_version: (currentVersions.basic_amal_version || 0) + 1,
    last_updated: new Date().toISOString(),
  }, { merge: true });

  console.log('Content version updated!');
  console.log(`\nAll done! ${data.steps.length} Namaz Fazilat items pushed to Firebase.`);
}

pushNamazFazilat().catch((error) => {
  console.error('Error:', error);
  process.exit(1);
});
