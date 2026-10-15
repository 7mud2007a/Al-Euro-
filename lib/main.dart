import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/app_localizations.dart';
import 'providers/app_state.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.initPreferences();

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const AlEuroApp(),
    ),
  );
}

class AlEuroApp extends StatelessWidget {
  const AlEuroApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final langCode = state.locale.languageCode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al Euro - اليورو',
      locale: state.locale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: AlEuroTheme.darkTheme(langCode),
      theme: AlEuroTheme.lightTheme(langCode),
      home: const SplashScreen(),
    );
  }
}
