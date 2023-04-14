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
    // theme: ThemeData.light(),
    // darkTheme: ThemeData.dark(),
    home: LoginScreen(),
    routes: {'classes': (context) => const Home()},
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('ksjfsdf'),
    );
    // return Center(
    //   child: SizedBox(
    //     width: 200,
    //     height: 50,
    //     child: ElevatedButton(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           FaIcon(FontAwesomeIcons.google),
    //           Text('Login with google')
    //         ],
    //       ),
    //       onPressed: (() async {
    //         try {
    //           await FireBaseServices().siginWithGoogle();
    //           Navigator.pushNamed(context, 'home');
    //         } catch (e) {
    //           throw e;
    //         }
    //       }),
    //     ),
    //   ),
    // );
  }
}
