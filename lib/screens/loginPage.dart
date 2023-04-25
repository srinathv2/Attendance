// // import 'package:flutter/material.dart';
// // import 'package:email_validator/email_validator.dart';
// // import 'package:http/http.dart' as http;

// // var loginResponse;

// // class LoginPage extends StatefulWidget {
// //   const LoginPage({super.key});

// //   @override
// //   State<LoginPage> createState() => _LoginPageState();
// // }

// // class _LoginPageState extends State<LoginPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   TextEditingController emailController = TextEditingController();
// //   TextEditingController passwordController = TextEditingController();
// //   var url = Uri.https(
// //       'us-central1-all-results-server.cloudfunctions.net', '/app/user/login');

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Login Page'),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Form(
// //           key: _formKey,
// //           autovalidateMode: AutovalidateMode.onUserInteraction,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               Container(
// //                 margin: const EdgeInsets.all(30),
// //                 width: 400,
// //                 height: 100,
// //                 child: TextFormField(
// //                   validator: (value) {
// //                     if (!EmailValidator.validate(value!)) {
// //                       return 'Please enter a valid email';
// //                     }
// //                   },
// //                   controller: emailController,
// //                   decoration: const InputDecoration(
// //                       border: OutlineInputBorder(),
// //                       labelText: 'EMAIL',
// //                       hintText: 'Enter Email'),
// //                 ),
// //               ),
// //               Container(
// //                 margin: const EdgeInsets.all(30),
// //                 width: 400,
// //                 height: 100,
// //                 child: TextFormField(
// //                   validator: (value) {
// //                     if (value == '' || value!.length < 8) {
// //                       return 'Please enter a valid password';
// //                     }
// //                   },
// //                   controller: passwordController,
// //                   obscureText: true,
// //                   decoration: const InputDecoration(
// //                       border: OutlineInputBorder(),
// //                       labelText: 'PASSWORD',
// //                       hintText: 'Enter Password'),
// //                 ),
// //               ),
// //               ElevatedButton(
// //                   onPressed: (() {
// //                     Navigator.pushNamed(context, 'home');
// //                   }),
// //                   child: const Text('SUBMIT'))
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:google_sign_in/google_sign_in.dart';

// // class FireBaseServices {
// //   final _auth=FirebaseAuth.instance;
// //   final _googleSignIn=GoogleSignIn();

// //   siginWithGoogle() async {
// //     try {

// //       final GoogleSignInAccount? googleSignInAccount=await _googleSignIn.signIn();
// //       if(googleSignInAccount != null){
// //         final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
// //         final AuthCredential authCredential = GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken,idToken: googleSignInAuthentication.idToken);
// //         await _auth.signInWithCredential(authCredential);
// //       }
// //     } on FirebaseAuthException catch (e) {
// //       print(e.message);
// //       throw e;
// //     }
// //   }
// //   signout() async {
// //     await _auth.signOut();
// //     await _googleSignIn.signOut();
// //   }
// // }
// import 'package:attendance/screens/home.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   Future<void> _login() async {
//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       // Navigate to home screen or display a success message.
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//       } else {
//         print('Error: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your email.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your password.';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     Navigator.pushNamed(context, "home");
//                   }
//                 },
//                 child: Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:attendance/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late UserCredential userCredential;
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      try {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name,
          password: data.password,
        );
        await FirebaseFirestore.instance
            .collection('employees')
            .where('email', isEqualTo: data.name)
            .where('status', isEqualTo: 'active')
            .get()
            .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            snapshot.docs.forEach((element) {
              if (element.exists && element['type'] == 'admin') {
                Navigator.pushReplacementNamed(context, '/adminScreen');
              } else if (element.exists && element['type'] == 'faculty') {
                Navigator.pushReplacementNamed(context, '/classes');
              }
            });
          } else {
            throw 'No user found with this email.';
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          return 'Wrong password provided for that user.';
        }
      } catch (e) {
        return e.toString();
      }
    });

    // debugPrint('Name: ${data.name}, Password: ${data.password}');
    // return Future.delayed(loginTime).then((_) {
    //   if (!users.containsKey(data.name)) {
    //     return 'User not exists';
    //   }
    //   if (users[data.name] != data.password) {
    //     return 'Password does not match';
    //   }
    //   return null;
    // });
  }

  // Future<String?> _signupUser(SignupData data) {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          Icons.code,
          color: Colors.white,
          size: 40,
        ),
        onPressed: (() {}),
      ),
      body: FlutterLogin(
        hideForgotPasswordButton: false,
        // title: 'Attendance',ß
        logo: AssetImage('assets/images/svcolleges.png'),
        onLogin: _authUser,
        // onSignup: _signupUser,

        // loginProviders: <LoginProvider>[
        //   LoginProvider(
        //     icon: FontAwesomeIcons.google,
        //     label: 'Google',
        //     callback: () async {
        //       debugPrint('start google sign in');
        //       await Future.delayed(loginTime);
        //       debugPrint('stop google sign in');
        //       return null;
        //     },
        //   ),
        // ],
        // onSubmitAnimationCompleted: () {
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (context) => Home(),
        //   ));
        // },

        onRecoverPassword: ((email) async {
          try {
            await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              return 'No user found with this email.';
            }
          }
        }),
      ),
    );
  }
}
