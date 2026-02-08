#!/usr/bin/env node
/**
 * Push Dua data to Firebase Firestore
 *
 * Usage:
 *   1. First run: dart bin/convert_duas_to_json.dart
 *      (This generates the JSON files from hardcoded data)
 *   2. Download your Firebase service account key from Firebase Console:
 *      Project Settings -> Service Accounts -> Generate New Private Key
 *   3. Save it as: scripts/serviceAccountKey.json
 *   4. Run: node scripts/push_duas_to_firebase.js
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

async function pushDuas() {
  // Load combined duas JSON
  const duasPath = path.join(__dirname, '..', 'assets', 'data', 'firebase', 'duas.json');
  if (!fs.existsSync(duasPath)) {
    console.error('ERROR: duas.json not found!');
    console.error('Run first: dart bin/convert_duas_to_json.dart');
    process.exit(1);
  }

  console.log('Loading duas.json...');
  const duasData = JSON.parse(fs.readFileSync(duasPath, 'utf8'));
  const categories = duasData.categories;

  console.log(`Found ${categories.length} categories`);

  // Push each category as a separate document in the 'duas' collection
  for (const category of categories) {
    const docId = category.id;
    console.log(`Pushing category: ${docId} (${category.duas.length} duas)...`);

    await db.collection('duas').doc(docId).set(category);
    console.log(`  ✓ ${docId} pushed successfully`);
  }

  // Update content version
  console.log('\nUpdating content version...');
  const versionsRef = db.collection('content_metadata').doc('versions');
  const versionsDoc = await versionsRef.get();

  const currentVersions = versionsDoc.exists ? versionsDoc.data() : {};
  await versionsRef.set({
    ...currentVersions,
    duas_version: (currentVersions.duas_version || 0) + 1,
    last_updated: new Date().toISOString(),
  }, { merge: true });

  console.log('Content version updated!');

  // Summary
  let totalDuas = 0;
  for (const cat of categories) {
    totalDuas += cat.duas.length;
  }
  console.log(`\nAll done! Pushed ${totalDuas} duas across ${categories.length} categories to Firebase.`);
}

pushDuas().catch((error) => {
  console.error('Error:', error);
  process.exit(1);
});
