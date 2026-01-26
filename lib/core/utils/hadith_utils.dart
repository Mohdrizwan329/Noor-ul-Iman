import 'package:flutter/material.dart';
import '../../providers/hadith_provider.dart';
import 'localization_helper.dart';

/// Helper function to get localized Hadith collection name
String getLocalizedCollectionName(BuildContext context, HadithCollection collection) {
  switch (collection) {
    case HadithCollection.bukhari:
      return context.tr('sahih_bukhari');
    case HadithCollection.muslim:
      return context.tr('sahih_muslim');
    case HadithCollection.nasai:
      return context.tr('sunan_nasai');
    case HadithCollection.abudawud:
      return context.tr('sunan_abu_dawud');
    case HadithCollection.tirmidhi:
      return context.tr('jami_tirmidhi');
    case HadithCollection.ibnmajah:
      return context.tr('sunan_ibn_majah');
  }
}
