import 'package:attendance/screens/classPage.dart';
import 'package:attendance/screens/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:attendance/screens/home.dart';

class EmployeeEntry {
  late String docid, email, employeeid, name, password, status, type, dept;

  var _formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var typeController = TextEditingController();
  var statusController = TextEditingController();
  var passwordController = TextEditingController();
  var deptController = TextEditingController();
  String? selectedStatus, selectedType;
  List<String?> empstatuslist = ['active', 'inactive'],
      emptypelist = ['admin', 'faculty'];
  late var userCreds;
  final passwordValidator = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  EmployeeEntry(this.docid, this.email, this.employeeid, this.name, this.status,
      this.type, this.dept, this.userCreds);

  Card createEntry(BuildContext context, List items) {
    return Card(
      child: FocusedMenuHolder(
        onPressed: () {},
        openWithTap: false,
        menuItems: [
          FocusedMenuItem(
              title: Text('Edit'),
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                        content: Text('Do you want to edit the Employee info?'),
                        actions: [
                          TextButton(
                              onPressed: (() {
                                Navigator.of(context).pop();
                              }),
                              child: Text('No')),
                          TextButton(
                              onPressed: (() {
                                emailController.text = this.email;
                                nameController.text = this.name;
                                // passwordController.text = this.password;
                                selectedType = this.type;
                                selectedStatus = this.status;
                                deptController.text = this.dept;
                                // selectedItem = this.type;
                                // Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: Text('Employee info'),
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Form(
                                            key: _formKey,
                                            autovalidateMode:
                                                AutovalidateMode.always,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter name';
                                                    }
                                                    return null;
                                                  },
                                                  controller: nameController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Name',
                                                  ),
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Department required';
                                                    } else if (!RegExp(
                                                            r'^[A-Za-z]+$')
                                                        .hasMatch(value)) {
                                                      return 'Please enter valid Department';
                                                    }
                                                    return null;
                                                  },
                                                  controller: deptController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Department',
                                                  ),
                                                ),
                                                // TextFormField(
                                                //   validator: (value) {
                                                //     if (value == null ||
                                                //         value.isEmpty) {
                                                //       return 'Email required';
                                                //     } else if (!EmailValidator
                                                //         .validate(value)) {
                                                //       return 'Please enter valid email';
                                                //     }
                                                //     return null;
                                                //   },
                                                //   controller: emailController,
                                                //   decoration: InputDecoration(
                                                //     labelText: 'Email',
                                                //   ),
                                                // ),

                                                // TextFormField(
                                                //   validator: (value) {
                                                //     if (value!.isEmpty) {
                                                //       return 'Password is required';
                                                //     } else if (!passwordValidator
                                                //         .hasMatch(value)) {
                                                //       return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character (@\$!%*?&)';
                                                //     }
                                                //     return null;
                                                //   },
                                                //   controller:
                                                //       passwordController,
                                                //   decoration: InputDecoration(
                                                //       labelText: 'Password',
                                                //       errorMaxLines: 5),
                                                // ),
                                                DropdownButtonFormField<String>(
                                                    value: this.selectedStatus,
                                                    hint: Text(
                                                        'Please enter employee status'),
                                                    items:
                                                        empstatuslist.map((e) {
                                                      return DropdownMenuItem(
                                                          value: e,
                                                          child: Text(e!));
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      // Future.microtask(() {
                                                      // setState(() {
                                                      this.selectedStatus =
                                                          value.toString();
                                                      // });
                                                      // });
                                                    }),
                                                DropdownButtonFormField<String>(
                                                    value: this.selectedType,
                                                    hint: Text(
                                                        'Please enter employee type'),
                                                    items: emptypelist.map((e) {
                                                      return DropdownMenuItem(
                                                          value: e,
                                                          child: Text(e!));
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      // Future.microtask(() {
                                                      // setState(() {
                                                      this.selectedType =
                                                          value.toString();
                                                      // });
                                                      // });
                                                    }),
                                                // TextFormField(
                                                //   validator: (value) {
                                                //     if (value == null ||
                                                //         value.isEmpty) {
                                                //       return 'Please enter employee status';
                                                //     }
                                                //     return null;
                                                //   },
                                                //   controller: statusController,
                                                //   decoration: InputDecoration(
                                                //     labelText: 'Status',
                                                //   ),
                                                // ),
                                                // TextFormField(
                                                //   validator: (value) {
                                                //     if (value == null ||
                                                //         value.isEmpty) {
                                                //       return 'Please enter employee type';
                                                //     }
                                                //     return null;
                                                //   },
                                                //   controller: typeController,
                                                //   decoration: InputDecoration(
                                                //     labelText: 'Employee type',
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              child: Text("Submit"),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();
                                                  Navigator.of(context).pop();

                                                  FirebaseFirestore.instance
                                                      .collection("employees")
                                                      .doc(this.docid)
                                                      .update({
                                                    // "docid": this.docid,
                                                    "name": nameController.text,
                                                    "type": selectedType,
                                                    "status": selectedStatus,
                                                    "dept":
                                                        this.deptController.text
                                                  });

                                                  Navigator.of(context).pop();
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
              }),
          FocusedMenuItem(
              title: Text('Delete'),
              onPressed: () async {
                if (this.email != FirebaseAuth.instance.currentUser!.email &&
                    this.status != 'inactive') {
                  FirebaseFirestore.instance
                      .collection('employees')
                      .doc(this.docid)
                      .update({"status": "inactive"});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Employee deleted successfully')),
                  );
                  // await FirebaseFirestore.instance
                  //     .collection('employees')
                  //     .doc('${this.docid}')
                  //     .delete();
                  // var currentUserToken =
                  //     await FirebaseAuth.instance.currentUser!.getIdToken();
                  // UserCredential userCredential = await FirebaseAuth.instance
                  //     .signInWithEmailAndPassword(
                  //         email: this.email, password: this.password);
                  // await userCredential.user!.delete();
                  // await FirebaseAuth.instance.signOut();
                  // await FirebaseAuth.instance.signInWithCredential(x);
                } else if (this.email !=
                        FirebaseAuth.instance.currentUser!.email &&
                    this.status == 'inactive') {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          content: Text('Employee already Removed'),
                        );
                      }));
                } else if (this.email ==
                    FirebaseAuth.instance.currentUser!.email) {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          content: Text('YOU can not delete YOU'),
                        );
                      }));
                }
              })
        ],
        child: TextButton(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Text(
                    'ID',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 44,
                  ),
                  Text(this.employeeid)
                ]),
                Row(children: [
                  Text(
                    'Name',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      this.name,
                      // softWrap: false,
                      maxLines: 3,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  )
                ]),
                Row(children: [
                  Text(
                    'Dept',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 27,
                  ),
                  Text(this.dept)
                ]),
                Row(children: [
                  Text(
                    'Email',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    this.email,
                  )
                ])
              ],
            )),
      ),
    );
  }
}
