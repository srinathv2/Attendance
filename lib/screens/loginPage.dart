import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

var loginResponse;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var url = Uri.https(
      'us-central1-all-results-server.cloudfunctions.net', '/app/user/login');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(30),
                width: 400,
                height: 100,
                child: TextFormField(
                  validator: (value) {
                    if (!EmailValidator.validate(value!)) {
                      return 'Please enter a valid email';
                    }
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'EMAIL',
                      hintText: 'Enter Email'),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30),
                width: 400,
                height: 100,
                child: TextFormField(
                  validator: (value) {
                    if (value == '' || value!.length < 8) {
                      return 'Please enter a valid password';
                    }
                  },
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'PASSWORD',
                      hintText: 'Enter Password'),
                ),
              ),
              ElevatedButton(
                  onPressed: (() {
                    Navigator.pushNamed(context, 'home');
                  }),
                  child: const Text('SUBMIT'))
            ],
          ),
        ),
      ),
    );
  }
}
