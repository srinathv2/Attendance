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
  var rollController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> rollnumbers = [];
  var numberOfStudents;
  getCount() async {
    var x = await FirebaseFirestore.instance
        .collection('students')
        .where("classid",
            isEqualTo: FirebaseFirestore.instance
                .doc("classes/${widget.classEntry.classid}"))
        .get();
    setState(() {
      numberOfStudents = x.docs.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCount();
  }

  String barcode = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.classEntry.title), actions: [
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
      ]),
      body: StreamBuilder<Object>(
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
            getCount();
            return Padding(
              padding: const EdgeInsets.only(top: 200),
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.class_),
                      title: Text('Category'),
                      trailing: Text(widget.classEntry.category),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.calendar_month),
                      title: Text('Date'),
                      trailing: Text(widget.classEntry.date),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.people),
                      title: Text('Students present'),
                      trailing: Text(numberOfStudents.toString()),
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
              child: Icon(Icons.qr_code_scanner),
              label: 'Scan',
              onPressed: () async {
                await scanBarcodeNormal();
                // while(true){
                //   if(this.barcode!='-1' && this.barcode!=''){
                //     break;
                //   }
                // scanBarcode();

                // }
                if (this.barcode != "-1" && this.barcode != "") {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection("students")
                        .doc()
                        .set({
                      "classid": FirebaseFirestore.instance
                          .doc("classes/${widget.classEntry.classid}"),
                      "faculty": "santhosh",
                      "rollnumber": this.barcode,
                      "timestamp": DateFormat('yyyy-MM-dd – kk:mm')
                          .format(Timestamp.now().toDate())
                    });
                  });
                } else {
                  SnackBar(
                    content: Text('Go Back And Try Again'),
                  );
                }
              }),
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
                                        onPressed: () {
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
                                                "faculty": "santhosh",
                                                "rollnumber":
                                                    rollController.text,
                                                "timestamp": DateFormat(
                                                        'yyyy-MM-dd – kk:mm')
                                                    .format(Timestamp.now()
                                                        .toDate())
                                              });
                                              Navigator.of(context).pop();
                                            });
                                          }
                                          _formKey.currentState!.reset();
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
                                              if (value == null ||
                                                  value.isEmpty) {
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
                            ClassTitle: widget.classEntry.title,
                            ClassId: widget.classEntry.classid)));
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
