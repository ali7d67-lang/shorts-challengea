import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_localizations.dart';
import 'screens/feed_screen.dart';
import 'screens/record_screen.dart';
import 'screens/vip_checkout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization ready
  runApp(const ShortsChallengeApp());
}

class ShortsChallengeApp extends StatefulWidget {
  const ShortsChallengeApp({Key? key}) : super(key: key);

  @override
  State<ShortsChallengeApp> createState() => _ShortsChallengeAppState();
}

class _ShortsChallengeAppState extends State<ShortsChallengeApp> {
  Locale _locale = const Locale('ar');

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shorts Challenge',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en'), Locale('ar'), Locale('hi'), Locale('ku'),
        Locale('tr'), Locale('ru'), Locale('zh'), Locale('ja'),
        Locale('vi'), Locale('ko'), Locale('pt'), Locale('fr')
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0B14),
        primaryColor: const Color(0xFF00F2FE),
        accentColor: const Color(0xFF9B51E0),
      ),
      home: MainShellScreen(onLanguageChanged: setLocale),
    );
  }
}

class MainShellScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  const MainShellScreen({Key? key, required this.onLanguageChanged}) : super(key: key);

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const FeedScreen(),
      const RecordScreen(),
      const VipCheckoutScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D0B14),
        selectedItemColor: const Color(0xFF00F2FE),
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'تصوير'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'VIP'),
        ],
      ),
    );
  }
}
