import 'package:attendance/screens/adminScreen.dart';
import 'package:attendance/screens/employees.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:attendance/screens/classPage.dart';
import 'package:attendance/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:attendance/screens/loginPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: LoginScreen(),
    initialRoute: '/',
    routes: {
      '/': (context) => LoginScreen(),
      '/classes': (context) => Home(),
      '/adminScreen': (context) => AdminScreen(),
      '/employees': (context) => Employees()
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
