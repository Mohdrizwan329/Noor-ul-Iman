import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';
import 'core/services/background_location_service.dart';
import 'core/services/azan_background_service.dart';
import 'core/services/ad_service.dart';
import 'core/services/content_service.dart';
import 'core/services/hijri_date_service.dart';

import 'providers/auth_provider.dart';
import 'providers/prayer_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/quran_provider.dart';
import 'providers/tasbih_provider.dart';
import 'providers/adhan_provider.dart';
import 'providers/hadith_provider.dart';
import 'providers/dua_provider.dart';
import 'providers/language_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize ContentService for Firestore caching
  await ContentService().initialize();

  // Preload UI translations before app starts (from Hive cache or local JSON)
  await ContentService().preloadTranslations();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Configure Google Fonts to handle network errors gracefully
  GoogleFonts.config.allowRuntimeFetching = false;

  // Initialize Hijri date service (fetches correct Islamic date from API)
  await HijriDateService.instance.initialize();

  // Initialize AdMob
  await AdService.initialize();

  // Start background location tracking for automatic prayer time updates
  final backgroundLocationService = BackgroundLocationService();
  await backgroundLocationService.startLocationTracking();

  // Initialize Azan background service for playing Azan when app is closed
  try {
    await AzanBackgroundService.initialize();
  } catch (e) {
    debugPrint('Azan background service initialization failed: $e');
    // Continue app startup even if alarm manager fails
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()..loadTranslations()),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..loadSettings(),
        ),
        ChangeNotifierProvider(create: (_) => PrayerProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => TasbihProvider()..loadSettings()),
        ChangeNotifierProvider(create: (_) => AdhanProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => HadithProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => DuaProvider()..loadCategories()),
      ],
      child: Consumer2<SettingsProvider, LanguageProvider>(
        builder: (context, settings, language, child) {
          return MaterialApp(
            title: 'Noor-ul-Iman',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: language.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ur'),
              Locale('ar'),
              Locale('hi'),
            ],
            // Force LTR layout for all languages (text will still translate)
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: child ?? const SizedBox(),
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
