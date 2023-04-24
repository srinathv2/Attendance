import 'package:attendance/models/newClassEntry.dart';
import 'package:attendance/screens/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  late String selectedItem;
  List<String> attendanceTypes = ['Fullday', 'Forenoon', 'Afternoon'];
  List tbs = [
    // Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text(
    //         'Title',
    //         style: TextStyle(color: Colors.black),
    //       ),
    //       Text('Category', style: TextStyle(color: Colors.black)),
    //       Text('Date', style: TextStyle(color: Colors.black))
    //     ],
    //   ),
    // )
  ];
  List items = [];

  bool isLoaded = false;
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  final typeController = TextEditingController();
  var empinfo, empname;

  // User? curentUser;
  // _icrementCounter() async {
  //   List<Map<String, dynamic>> templist = [];
  //   var data = await FirebaseFirestore.instance
  //       .collection("classes")
  //       .orderBy('Date', descending: false)
  //       .get();
  //   data.docs.forEach((element) {
  //     templist.add(element.data());
  //   });
  //   setState(() {
  //     items = templist;
  //   });
  // }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItem = attendanceTypes.first;
    // curentUser = FirebaseAuth.instance.currentUser;
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user != null) {
    //     curentUser = user;
    //   }
    // });

    // _icrementCounter();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    categoryController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes'),
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
              icon: Icons.add,
              text: 'Create Class',
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                        content: Text('Do you want to create new class?'),
                        actions: [
                          TextButton(
                              onPressed: (() {
                                Navigator.of(context).pop();
                              }),
                              child: Text('No')),
                          TextButton(
                              onPressed: (() {
                                // Navigator.of(context).pop();
                                Navigator.of(context)
                                    .popUntil(ModalRoute.withName('classes'));

                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: Text('Class info'),
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Form(
                                            key: _formKey,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter some title';
                                                    }
                                                    return null;
                                                  },
                                                  controller: titleController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Title',
                                                  ),
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter some Category';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      categoryController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Category',
                                                  ),
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter some Description';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      descriptionController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Description',
                                                  ),
                                                ),
                                                // TextFormField(
                                                //   validator: (value) {
                                                //     if (value == null ||
                                                //         value.isEmpty) {
                                                //       return 'Fullday or Forenoon or Afternoon';
                                                //     }
                                                //     return null;
                                                //   },
                                                //   controller: typeController,
                                                //   decoration: InputDecoration(
                                                //     labelText: 'Attendance type',
                                                //   ),
                                                // ),
                                                DropdownButtonFormField<String>(
                                                    value: this.selectedItem,
                                                    hint: Text(
                                                        'select attendance type'),
                                                    items: attendanceTypes
                                                        .map((e) {
                                                      return DropdownMenuItem(
                                                          value: e,
                                                          child: Text(e));
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      Future.microtask(() {
                                                        setState(() {
                                                          this.selectedItem =
                                                              value.toString();
                                                        });
                                                      });
                                                    }),
                                                // TextFormField(

                                                //   decoration: InputDecoration(labelText: 'Select class type'),
                                                //   onChanged: (value){
                                                //     setState(() {
                                                //        typeController.text=value;
                                                //     });
                                                //   },
                                                //   onTap: () {
                                                //      FocusScope.of(context).requestFocus(new FocusNode());
                                                //   },

                                                //   validator: (value) {
                                                //     if (value == null ||
                                                //         value.isEmpty) {
                                                //       return 'Fullday or Forenoon or Afternoon';
                                                //     }
                                                //     return null;
                                                //   },
                                                //   controller: typeController,

                                                // ),
                                                // TextFormField(
                                                //   decoration: InputDecoration(
                                                //     labelText: 'Date',
                                                //   ),
                                                //   validator: (value) {
                                                //     if (value == null ||
                                                //         value.isEmpty) {
                                                //       return 'Please enter date.';
                                                //     }
                                                //     return null;
                                                //   },
                                                //   controller: dateController,
                                                //   onTap: () {
                                                //     // FocusScope.of(context)
                                                //     //     .requestFocus(
                                                //     //         new FocusNode());
                                                //     showDatePicker(
                                                //             context: context,
                                                //             initialDate:
                                                //                 DateTime.now(),
                                                //             firstDate:
                                                //                 DateTime(2000),
                                                //             lastDate:
                                                //                 DateTime(2101))
                                                //         .then((selectedDate) {
                                                //       if (selectedDate != null) {
                                                //         dateController.text =
                                                //             DateFormat('yyyy-MM-dd')
                                                //                 .format(
                                                //                     selectedDate);
                                                //       }
                                                //     });
                                                //   },
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              child: Text("Submit"),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();

                                                  setState(() {
                                                    String ts =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(
                                                                Timestamp.now()
                                                                    .toDate());
                                                    var id = FirebaseFirestore
                                                        .instance
                                                        .collection("classes")
                                                        .doc()
                                                        .id;
                                                    FirebaseFirestore.instance
                                                        .collection("classes")
                                                        .doc(id)
                                                        .set({
                                                      "classid": id,
                                                      "Category":
                                                          categoryController
                                                              .text,
                                                      "Date": ts,
                                                      "Description":
                                                          descriptionController
                                                              .text,
                                                      "Title":
                                                          titleController.text,
                                                      "Type": selectedItem,
                                                      "createdby": FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .email ??
                                                          '',
                                                      "empname": empname
                                                    });
                                                    this.items.add({
                                                      "classid": id,
                                                      "Category":
                                                          categoryController
                                                              .text,
                                                      "Date": ts,
                                                      "Description":
                                                          descriptionController
                                                              .text,
                                                      "Title":
                                                          titleController.text,
                                                      "Type": selectedItem,
                                                      "createdby": FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .email ??
                                                          '',
                                                      "empname": empname
                                                    });
                                                    this.tbs = [];
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                                _formKey.currentState!.reset();
                                              })
                                        ],
                                      );
                                    }));
                              }),
                              child: Text('Yes')),
                        ]);
                  }),
                );
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
              },
            )
          ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('employees')
              .where('email',
                  isEqualTo: FirebaseAuth.instance.currentUser!.email ?? '')
              .snapshots(),
          // stream: emptype == 'admin'
          //     ? FirebaseFirestore.instance.collection('classes').snapshots()
          //     : FirebaseFirestore.instance
          //         .collection('classes')
          //         .where('createdby',
          //             isEqualTo: FirebaseAuth.instance.currentUser!.email)
          //         .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final documents = snapshot.data!.docs;
              empinfo = documents[0];
              empname = empinfo['name'];
              return StreamBuilder<QuerySnapshot>(
                stream: empinfo['type'] == 'admin'
                    ? FirebaseFirestore.instance
                        .collection('classes')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('classes')
                        .where('createdby',
                            isEqualTo:
                                FirebaseAuth.instance.currentUser!.email ?? '')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List templist = [];
                    tbs = [];
                    var data = snapshot.data!.docs;

                    data.forEach((element) {
                      templist.add(element.data());
                    });
                    // setState(() {
                    items = templist;
                    // });
                    return FutureBuilder(
                      future: Future.delayed(Duration(milliseconds: 500)),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            tbs.add(NewClassEntry(
                                this.items[index]["classid"],
                                this.items[index]["Title"],
                                this.items[index]["Category"],
                                this.items[index]['Date'],
                                this.items[index]["Description"],
                                this.items[index]["Type"],
                                this.items[index]['empname']));
                            return tbs[index].createEntry(context, items);
                          },
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
