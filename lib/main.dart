import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_theme.dart';
import 'core/services/background_location_service.dart';
import 'providers/prayer_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/quran_provider.dart';
import 'providers/tasbih_provider.dart';
import 'providers/adhan_provider.dart';
import 'providers/hadith_provider.dart';
import 'providers/dua_provider.dart';
import 'providers/language_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

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

  // Start background location tracking for automatic prayer time updates
  final backgroundLocationService = BackgroundLocationService();
  await backgroundLocationService.startLocationTracking();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..loadSettings(),
        ),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => TasbihProvider()..loadSettings()),
        ChangeNotifierProvider(create: (_) => AdhanProvider()),
        ChangeNotifierProvider(create: (_) => HadithProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => DuaProvider()..loadCategories()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer2<SettingsProvider, LanguageProvider>(
        builder: (context, settings, language, child) {
          return MaterialApp(
            title: 'Noor-ul-Iman',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
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
