import 'package:firebase_core/firebase_core.dart';
import 'package:attendance/screens/classPage.dart';
import 'package:attendance/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:attendance/screens/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    // theme: ThemeData.light(),
    // darkTheme: ThemeData.dark(),
    home: const LoginPage(),
    routes: {
      'home': (context) => const Home(),
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
