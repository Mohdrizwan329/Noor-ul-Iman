#!/usr/bin/env node
/**
 * Push ALL Quran data to Firebase Firestore
 *
 * This pushes:
 *   - Enhanced quran_screen_content.json → quran_screen_content/data
 *   - Individual surah files → quran_surahs/surah_1 ... surah_114
 *
 * Prerequisites:
 *   1. Run fetch_quran_data.js first to generate the JSON files
 *   2. Download Firebase service account key from Firebase Console:
 *      Project Settings -> Service Accounts -> Generate New Private Key
 *   3. Save it as: scripts/serviceAccountKey.json
 *
 * Usage:
 *   node scripts/push_quran_to_firebase.js
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

async function pushQuranData() {
  // Step 1: Push quran_screen_content
  console.log('=== Pushing Quran Screen Content ===');
  const contentPath = path.join(
    __dirname,
    '..',
    'assets',
    'data',
    'firebase',
    'quran_screen_content.json'
  );
  const contentData = JSON.parse(fs.readFileSync(contentPath, 'utf8'));

  console.log('Pushing quran_screen_content/data...');
  await db.collection('quran_screen_content').doc('data').set(contentData);
  console.log('quran_screen_content pushed successfully!');

  // Step 2: Push individual surah files
  console.log('\n=== Pushing Individual Surahs ===');
  const surahDir = path.join(__dirname, '..', 'assets', 'data', 'firebase', 'quran_surahs');

  if (!fs.existsSync(surahDir)) {
    console.error('ERROR: quran_surahs directory not found!');
    console.error('Run fetch_quran_data.js first to generate the JSON files.');
    process.exit(1);
  }

  for (let i = 1; i <= 114; i++) {
    const filePath = path.join(surahDir, `surah_${i}.json`);
    if (!fs.existsSync(filePath)) {
      console.warn(`WARNING: surah_${i}.json not found, skipping...`);
      continue;
    }

    const surahData = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    const docId = `surah_${i}`;

    try {
      await db.collection('quran_surahs').doc(docId).set(surahData);
      console.log(`  Pushed surah_${i} (${surahData.number_of_ayahs} ayahs)`);
    } catch (e) {
      console.error(`  ERROR pushing surah_${i}: ${e.message}`);

      // If document is too large, split ayahs into chunks
      if (e.message.includes('exceeds the maximum')) {
        console.log(`  Splitting surah_${i} into chunks...`);
        const chunkSize = 50;
        const ayahs = surahData.ayahs;
        const chunks = [];

        for (let j = 0; j < ayahs.length; j += chunkSize) {
          chunks.push(ayahs.slice(j, j + chunkSize));
        }

        // Save metadata without ayahs
        const metaDoc = { ...surahData, ayahs: [], chunk_count: chunks.length };
        await db.collection('quran_surahs').doc(docId).set(metaDoc);

        // Save each chunk as a sub-document
        for (let c = 0; c < chunks.length; c++) {
          await db
            .collection('quran_surahs')
            .doc(docId)
            .collection('chunks')
            .doc(`chunk_${c}`)
            .set({ ayahs: chunks[c] });
          console.log(`    Pushed chunk ${c + 1}/${chunks.length}`);
        }
        console.log(`  Surah ${i} split into ${chunks.length} chunks`);
      }
    }
  }

  // Step 3: Update content versions
  console.log('\n=== Updating Content Versions ===');
  const versionsRef = db.collection('content_metadata').doc('versions');
  const versionsDoc = await versionsRef.get();
  const currentVersions = versionsDoc.exists ? versionsDoc.data() : {};

  await versionsRef.set(
    {
      ...currentVersions,
      quran_screen_content_version: (currentVersions.quran_screen_content_version || 0) + 1,
      quran_surahs_version: (currentVersions.quran_surahs_version || 0) + 1,
      last_updated: new Date().toISOString(),
    },
    { merge: true }
  );

  console.log('Content versions updated!');
  console.log('\n=== All Quran data pushed to Firebase! ===');
}

pushQuranData().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
