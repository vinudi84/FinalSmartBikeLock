import 'package:app/fingerprint_unlock_page.dart';
import 'package:app/keypad_page.dart';
import 'package:app/lock_history.dart';
import 'package:app/login_page.dart';
import 'package:app/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //  Add all pages as named routes
      routes: {
        '/lockControl': (context) => LockHistoryPage(),
        '/fingerprint': (context) => FingerprintUnlockPage(),
        '/keypad': (context) => KeypadPage(),
        '/settings': (context) => SettingsPage(),
      },

      home: LoginPage(),
    );
  }
}


