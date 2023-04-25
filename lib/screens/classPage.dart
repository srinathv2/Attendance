import 'dart:io';

import 'package:attendance/models/newClassEntry.dart';
import 'package:attendance/screens/ViewAttendence.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key, required this.classEntry});
  final NewClassEntry classEntry;

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final reg = RegExp(r'^[a-zA-Z0-9]{10}$|^[a-z]{10}$|^[A-Z]{10}$');
  var rollController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> rollnumbers = [];
  var numberOfStudents;
  // getCount() async {
  //   var x = await FirebaseFirestore.instance
  //       .collection('students')
  //       .where("classid",
  //           isEqualTo: FirebaseFirestore.instance
  //               .doc("classes/${widget.classEntry.classid}"))
  //       .get();
  //   setState(() {
  //     print('srinath');
  //     numberOfStudents = x.docs.length;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String barcode = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.classEntry.title,
            maxLines: 3,
          ),
          actions: [
            // ElevatedButton.icon(
            //     onPressed: () {
            //       scanBarcode();
            //       // while(true){
            //       //   if(this.barcode!='-1' && this.barcode!=''){
            //       //     break;
            //       //   }
            //       // scanBarcode();

            //       // }
            //       if (this.barcode == '-1' || this.barcode == null) {
            //         scanBarcode();
            //       }
            //       setState(() {
            //         FirebaseFirestore.instance.collection("students").doc().set({
            //           "classid": FirebaseFirestore.instance
            //               .doc("classes/${widget.classEntry.classid}"),
            //           "faculty": "santhosh",
            //           "rollnumber": this.barcode,
            //           "timestamp": DateFormat('yyyy-MM-dd – kk:mm')
            //               .format(Timestamp.now().toDate())
            //         });
            //       });
            //     },
            //     icon: Icon(Icons.qr_code_scanner),
            //     label: Text('SCAN'))
            ElevatedButton(
                child: Row(
                  children: [
                    Icon(Icons.qr_code_scanner),
                    SizedBox(
                      width: 10,
                    ),
                    Text('SCAN'),
                  ],
                ),
                onPressed: () async {
                  await scanBarcodeNormal();
                  // while(true){
                  //   if(this.barcode!='-1' && this.barcode!=''){
                  //     break;
                  //   }
                  // scanBarcode();

                  // }
                  QuerySnapshot<Map<String, dynamic>>
                      data = await FirebaseFirestore
                          .instance
                          .collection('students')
                          .where(
                              "classid",
                              isEqualTo: FirebaseFirestore
                                  .instance
                                  .doc("classes/${widget.classEntry.classid}"))
                          .where('rollnumber',
                              isEqualTo: this.barcode.toUpperCase())
                          .get();
                  if (data.docs.length == 0) {
                    if (this.barcode != "-1" && this.barcode != "") {
                      setState(() {
                        FirebaseFirestore.instance
                            .collection("students")
                            .doc()
                            .set({
                          "classid": FirebaseFirestore.instance
                              .doc("classes/${widget.classEntry.classid}"),
                          "faculty": widget.classEntry.empname,
                          "rollnumber": this.barcode.toUpperCase(),
                          "timestamp": DateFormat('dd-MM-yyyy – kk:mm')
                              .format(Timestamp.now().toDate())
                        });
                      });
                    } else {
                      SnackBar(
                        content: Text('Go Back And Try Again'),
                      );
                    }
                  } else {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ClassPage(classEntry: widget.classEntry)),
                    );
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            content: Text(
                                '${this.barcode.toUpperCase()} already attendance taken'),
                          );
                        }));
                  }
                }),
          ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('students')
              .where("classid",
                  isEqualTo: FirebaseFirestore.instance
                      .doc("classes/${widget.classEntry.classid}"))
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            numberOfStudents = snapshot.data!.docs.length;
            return Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 18),
                        child: Icon(Icons.class_),
                      ),
                      title: Text('Category'),
                      trailing: Text(widget.classEntry.category),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 18),
                        child: Icon(Icons.access_time),
                      ),
                      title: Text('Type'),
                      trailing: Text(widget.classEntry.type),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 18),
                        child: Icon(Icons.calendar_month),
                      ),
                      title: Text('Date'),
                      trailing: Text(widget.classEntry.date),
                    ),
                  ),
                  Card(
                    child: ExpansionTile(
                      children: [
                        Text(
                          widget.classEntry.desc,
                        )
                      ],
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 18),
                        child: Icon(Icons.description),
                      ),
                      title: Text(
                        'Description',
                      ),
                      // trailing: Text(
                      //   widget.classEntry.desc,
                      //   overflow: TextOverflow.ellipsis,
                      //   softWrap: true,
                      //   maxLines: 30,
                      // ),
                    ),
                  ),
                  Card(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewAttendence(
                                  classEntry: widget.classEntry,)));
                      },
                      child: ListTile(
                        leading: Icon(Icons.people),
                        title: Text('Students present'),
                        trailing: Text(numberOfStudents.toString()),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(left: 30),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => ViewAttendence(
      //                       ClassTitle: widget.classEntry.title,
      //                       ClassId: widget.classEntry.classid)));
      //         },
      //         child: Text('View Attendence'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => ViewAttendence(
      //                       ClassTitle: widget.classEntry.title,
      //                       ClassId: widget.classEntry.classid)));
      //         },
      //         child: Text('View Attendence'),
      //       ),
      //     ],
      //   ),
      // ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        speedDialChildren: [
          SpeedDialChild(
            child: Icon(Icons.person_add),
            label: 'Manual Attendance',
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    content: Text('Do you want to note rollnumber?'),
                    actions: [
                      TextButton(
                          onPressed: (() {
                            Navigator.of(context).pop();
                          }),
                          child: Text('No')),
                      TextButton(
                          child: Text('Yes'),
                          onPressed: (() {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  actions: [
                                    TextButton(
                                        child: Text("Submit"),
                                        onPressed: () async {
                                          var rolltext =
                                              rollController.text.toUpperCase();
                                          QuerySnapshot<Map<String, dynamic>>
                                              data = await FirebaseFirestore
                                                  .instance
                                                  .collection('students')
                                                  .where("classid",
                                                      isEqualTo: FirebaseFirestore
                                                          .instance
                                                          .doc(
                                                              "classes/${widget.classEntry.classid}"))
                                                  .where('rollnumber',
                                                      isEqualTo: rolltext)
                                                  .get();
                                          if (data.docs.length == 0) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              setState(() {
                                                FirebaseFirestore.instance
                                                    .collection("students")
                                                    .doc()
                                                    .set({
                                                  "classid": FirebaseFirestore
                                                      .instance
                                                      .doc(
                                                          "classes/${widget.classEntry.classid}"),
                                                  "faculty":
                                                      widget.classEntry.empname,
                                                  "rollnumber": rolltext,
                                                  "timestamp": DateFormat(
                                                          'dd-MM-yyyy – kk:mm')
                                                      .format(Timestamp.now()
                                                          .toDate())
                                                });
                                                Navigator.of(context).pop();
                                              });
                                              _formKey.currentState!.reset();
                                            }
                                          } else {
                                            Navigator.of(context).pop();
                                            showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        '${rolltext} already attendance taken'),
                                                  );
                                                }));
                                            _formKey.currentState!.reset();
                                          }
                                        })
                                  ],
                                  scrollable: true,
                                  title: Text('Enter Rollnumber'),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Form(
                                      key: _formKey,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Rollnumber is required';
                                              } else if (!reg.hasMatch(value)) {
                                                return 'Please enter valid rollnumber';
                                              }
                                              return null;
                                            },
                                            controller: rollController,
                                            decoration: InputDecoration(
                                              labelText: 'Rollnumber',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          }))
                    ],
                  );
                }),
              );
            },
          ),
          SpeedDialChild(
              label: 'View Class Attendance',
              child: Icon(Icons.remove_red_eye_outlined),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAttendence(
                            classEntry: widget.classEntry,)));
              })
        ],
      ),
    );
  }

  // Future<void> scanBarcode() async {
  //   try {
  //     final barcode = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     if (!mounted) return;
  //     setState(() {
  //       this.barcode = barcode;
  //     });
  //   } on PlatformException {
  //     barcode = 'failed to get platform version';
  //   }
  // }
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // int maxAttempts = 3;
    // int attempts = 0;

    // do {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //       "#ff6666", "Cancel", true, ScanMode.BARCODE);

    //   attempts++;
    // } while (attempts < maxAttempts &&
    //     (barcodeScanRes == null || barcodeScanRes == "-1"));
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      this.barcode = barcodeScanRes;
    });
  }
}
