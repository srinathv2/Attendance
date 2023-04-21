import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences _prefs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 200,
              height: 100,
              child: Card(
                elevation: 10,
                child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'employees');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Icon(Icons.people), Text('Employees')],
                    )),
              ),
            ),
            SizedBox(
              height: 100,
              width: 200,
              child: Card(
                elevation: 10,
                child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'classes');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Icon(Icons.book), Text('Classes')],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
