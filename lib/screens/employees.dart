import 'package:attendance/models/employeeEntry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';

class Employees extends StatefulWidget {
  const Employees({super.key});

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  final _formKey = GlobalKey<FormState>();
  var filter = 'active';
  UserCredential? userCred;
  List items = [], tbs = [];
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  // var typeController = TextEditingController();
  // var statusController = TextEditingController();
  var passwordController = TextEditingController();
  var employeeidController = TextEditingController();
  var deptController = TextEditingController();
  String? selectedStatus, selectedType;
  List<String?> empstatuslist = ['active', 'inactive'],
      emptypelist = ['admin', 'faculty'];
  final passwordValidator = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  getUserCred() async {
    try {
      FirebaseApp app = await Firebase.initializeApp(
          name: 'secondary', options: Firebase.app().options);

      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      setState(() {
        userCred = userCredential;
      });
      await app.delete();
      return 1;
      // }
      // catch (e) {
      //   return false;
      // }
    } on FirebaseAuthException catch (e) {
      // Navigator.of(context).pop();
      if (e.code == 'weak-password') {
        // showDialog(
        //     context: context,
        //     builder: ((context) {
        //       return AlertDialog(
        //         content: Text('The password provided is too weak.'),
        //         actions: [
        //           TextButton(
        //               onPressed: () {
        //                 Navigator.of(context).pop();
        //               },
        //               child: Text('ok'))
        //         ],
        //       );
        //     }));
        return -1;
      } else if (e.code == 'email-already-in-use') {
        // showDialog(
        //     context: context,
        //     builder: ((context) {
        //       return AlertDialog(
        //         content: Text('The account already exists for that email.'),
        //         actions: [
        //           TextButton(
        //               onPressed: () {
        //                 Navigator.of(context).pop();
        //               },
        //               child: Text('ok'))
        //         ],
        //       );
        //     }));
        return -2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        centerTitle: true,
      ),
      bottomNavigationBar: GNav(
          backgroundColor: Color.fromARGB(255, 36, 149, 242),
          color: Colors.black,
          tabs: [
            GButton(
              text: 'Active Employees',
              icon: Icons.circle,
              onPressed: () {
                setState(() {
                  filter = 'active';
                });
              },
            ),
            GButton(
              text: 'Add Employees',
              icon: Icons.add,
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                        content: Text('Do you want to create new employee?'),
                        actions: [
                          TextButton(
                              onPressed: (() {
                                Navigator.of(context).pop();
                              }),
                              child: Text('No')),
                          TextButton(
                              onPressed: (() {
                                // Navigator.of(context).pop();
                                // Navigator.of(context)
                                //     .popUntil(ModalRoute.withName('employees'));
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
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter employee ID';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      employeeidController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Employee ID',
                                                  ),
                                                ),

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
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Email required';
                                                    } else if (!EmailValidator
                                                        .validate(value)) {
                                                      return 'Please enter valid email';
                                                    }
                                                    return null;
                                                  },
                                                  controller: emailController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Email',
                                                  ),
                                                ),
                                                TextFormField(
                                                  decoration: InputDecoration(
                                                    errorMaxLines: 5,
                                                    label: Text('Password'),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Password is required';
                                                    } else if (!passwordValidator
                                                        .hasMatch(value)) {
                                                      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character (@\$!%*?&)';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      passwordController,
                                                ),
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
                                                //     labelText: 'Employee status',
                                                //   ),
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
                                                      setState(() {
                                                        this.selectedStatus =
                                                            value.toString();
                                                      });
                                                      // });
                                                    }),
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
                                                      setState(() {
                                                        this.selectedType =
                                                            value.toString();
                                                      });
                                                      // });
                                                    }),
                                                // DropdownButton(
                                                //     hint: Text(
                                                //         'select attendance type'),
                                                //     value: selectedItem,
                                                //     items: attendanceTypes
                                                //         .map((e) =>
                                                //             DropdownMenuItem(
                                                //               value: e,
                                                //                 child: Text(e)))
                                                //         .toList(),
                                                //     onChanged: (value) {
                                                //       setState(() {
                                                //         selectedItem = value!;
                                                //       });
                                                //     })
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
                                                // Navigator.of(context).popUntil(
                                                //     ModalRoute.withName(
                                                //         'employees'));
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();
                                                  var x = await getUserCred();

                                                  // setState(
                                                  //   () {

                                                  if (x == 1) {
                                                    var id = FirebaseFirestore
                                                        .instance
                                                        .collection("employees")
                                                        .doc()
                                                        .id;
                                                    FirebaseFirestore.instance
                                                        .collection("employees")
                                                        .doc(id)
                                                        .set({
                                                      "docid": id,
                                                      "email":
                                                          emailController.text,
                                                      "name":
                                                          nameController.text,
                                                      "employeeid":
                                                          employeeidController
                                                              .text,
                                                      "type": this.selectedType,
                                                      "status":
                                                          this.selectedStatus,
                                                      "dept": this
                                                          .deptController
                                                          .text,
                                                    });

                                                    this.items.add({
                                                      "docid": id,
                                                      "email":
                                                          emailController.text,
                                                      "name":
                                                          nameController.text,
                                                      "employeeid":
                                                          employeeidController
                                                              .text,
                                                      "Type": this.selectedType,
                                                      "status":
                                                          this.selectedStatus,
                                                      "dept": this
                                                          .deptController
                                                          .text
                                                    });
                                                    this.tbs = [];
                                                    Navigator.of(context)
                                                        .popUntil(
                                                            ModalRoute.withName(
                                                                'employees'));
                                                  } else if (x == -1) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'The password is weak.'),
                                                    ));
                                                  } else if (x == -2) {
                                                    var docs =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'employees')
                                                            .where('email',
                                                                isEqualTo:
                                                                    emailController
                                                                        .text)
                                                            .where('status',
                                                                isEqualTo:
                                                                    'inactive')
                                                            .get();
                                                    if (docs.size > 0) {
                                                      showDialog(
                                                          context: context,
                                                          builder: ((context) {
                                                            return AlertDialog(
                                                              content: Text(
                                                                  'Do you want to activate this account'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'No')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'employees')
                                                                          .doc(docs.docs[0]
                                                                              [
                                                                              'docid'])
                                                                          .update({
                                                                        'status':
                                                                            'active'
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .popUntil(
                                                                              ModalRoute.withName('employees'));
                                                                    },
                                                                    child: Text(
                                                                        'Yes')),
                                                              ],
                                                            );
                                                          }));
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'The account already exists for that email.'),
                                                      ));
                                                    }
                                                    // showDialog(
                                                    //     context: context,
                                                    //     builder: ((context) {
                                                    //       return AlertDialog(
                                                    //         content: Text(
                                                    //             'The password provided is too weak.'),
                                                    //         actions: [
                                                    //           TextButton(
                                                    //               onPressed: () {
                                                    //                 Navigator.of(
                                                    //                         context)
                                                    //                     .pop();
                                                    //               },
                                                    //               child: Text('ok'))
                                                    //         ],
                                                    //       );
                                                    //     }));
                                                  }
                                                  // Navigator.of(context).pop();
                                                  //   },
                                                  // );
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
              text: 'Inactive Employees',
              icon: Icons.circle_outlined,
              onPressed: () {
                setState(() {
                  filter = 'inactive';
                });
              },
            )
          ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('employees')
              .where('status', isEqualTo: filter)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            List templist = [];
            tbs = [];
            var data = snapshot.data!.docs;

            data.forEach((element) {
              templist.add(element.data());
            });
            // setState(() {
            items = templist;
            // });
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                tbs.add(EmployeeEntry(
                    this.items[index]["docid"],
                    this.items[index]["email"],
                    this.items[index]["employeeid"],
                    this.items[index]['name'],
                    // this.items[index]["password"],
                    this.items[index]["status"],
                    this.items[index]["type"],
                    this.items[index]["dept"],
                    userCred));
                return tbs[index].createEntry(context, items);
              },
            );
          }),
    );
  }
}
