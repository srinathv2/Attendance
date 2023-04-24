import 'package:attendance/screens/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences _prefs;
  void signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      await auth.signOut();
    }
  }

  changePassword({email, oldpassword, newpassword}) async {
    // var currentUser = FirebaseAuth.instance.currentUser;
    var cred =
        EmailAuthProvider.credential(email: email, password: oldpassword);
    await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(cred)
        .then((value) {
      try {
        if (oldpassword != newpassword) {
          FirebaseAuth.instance.currentUser!.updatePassword(newpassword);
        } else {
          throw 'new password should be NEW😄';
        }
      } on FirebaseAuthException catch (e) {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                content: Text(e.toString()),
              );
            }));
      }
    }).catchError((error) {
      print(error.toString());
      // showDialog(
      //     context: context,
      //     builder: ((context) {
      //       return AlertDialog(
      //         content: Text(error),
      //       );
      //     }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
        centerTitle: true,
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Color.fromARGB(255, 36, 149, 242),
        color: Colors.black,
        tabs: [
          GButton(
            icon: Icons.password,
            text: 'Change password',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: ((context) {
                    final formKey = GlobalKey<FormState>();
                    var oldPasswordController = TextEditingController();
                    var newPasswordController = TextEditingController();
                    final passwordValidator = RegExp(
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                    return AlertDialog(
                      scrollable: true,
                      title: Text('Change password'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            key: formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    errorMaxLines: 5,
                                    label: Text('Old Password'),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Old Password is required';
                                    } else if (!passwordValidator
                                        .hasMatch(value)) {
                                      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character (@\$!%*?&)';
                                    }
                                    return null;
                                  },
                                  controller: oldPasswordController,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    errorMaxLines: 5,
                                    label: Text('New Password'),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'New Password is required';
                                    } else if (!passwordValidator
                                        .hasMatch(value)) {
                                      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character (@\$!%*?&)';
                                    }
                                    return null;
                                  },
                                  controller: newPasswordController,
                                ),
                              ],
                            )),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await changePassword(
                                    email: FirebaseAuth
                                            .instance.currentUser!.email ??
                                        '',
                                    oldpassword: oldPasswordController.text,
                                    newpassword: newPasswordController.text);
                                Navigator.of(context).pop();
                                formKey.currentState!.reset();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Password changed successfully🎉')));
                              }
                              // await Future.delayed(Duration(seconds: 3));
                              // signOut();
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => LoginScreen()),
                              // );
                              // Navigator.popUntil(
                              //     context, ModalRoute.withName('/login'));
                              // await FirebaseAuth.instance.signOut();
                              // Navigator.of(context)
                              //     .popUntil();
                            },
                            child: Text('submit'))
                      ],
                    );
                  }));
            },
          ),
          GButton(
              icon: Icons.logout,
              text: 'logout',
              onPressed: () {
                signOut();
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              }),
        ],
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
