#!/usr/bin/env node
/**
 * Push 7 Kalmas data to Firebase Firestore
 *
 * Usage:
 *   1. Download your Firebase service account key from Firebase Console:
 *      Project Settings -> Service Accounts -> Generate New Private Key
 *   2. Save it as: scripts/serviceAccountKey.json
 *   3. Run: node scripts/push_kalmas_to_firebase.js
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

async function pushKalmas() {
  const kalmasPath = path.join(__dirname, '..', 'assets', 'data', 'firebase', 'kalmas.json');
  if (!fs.existsSync(kalmasPath)) {
    console.error('ERROR: kalmas.json not found!');
    process.exit(1);
  }

  console.log('Loading kalmas.json...');
  const kalmasData = JSON.parse(fs.readFileSync(kalmasPath, 'utf8'));

  console.log(`Found ${kalmasData.kalmas.length} kalmas`);

  // Push to kalmas/seven_kalmas
  console.log('Pushing to kalmas/seven_kalmas...');
  await db.collection('kalmas').doc('seven_kalmas').set(kalmasData);
  console.log('Kalmas pushed successfully!');

  // Update content version
  console.log('Updating content version...');
  const versionsRef = db.collection('content_metadata').doc('versions');
  const versionsDoc = await versionsRef.get();

  const currentVersions = versionsDoc.exists ? versionsDoc.data() : {};
  await versionsRef.set({
    ...currentVersions,
    kalmas_version: (currentVersions.kalmas_version || 0) + 1,
    last_updated: new Date().toISOString(),
  }, { merge: true });

  console.log('Content version updated!');
  console.log('\nAll done! 7 Kalmas pushed to Firebase.');
}

pushKalmas().catch((error) => {
  console.error('Error:', error);
  process.exit(1);
});
