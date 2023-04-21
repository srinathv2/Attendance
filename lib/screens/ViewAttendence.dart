import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ViewAttendence extends StatefulWidget {
  final String ClassTitle, ClassId;
  const ViewAttendence(
      {super.key, required this.ClassTitle, required this.ClassId});

  @override
  State<ViewAttendence> createState() => _ViewAttendenceState();
}

class _ViewAttendenceState extends State<ViewAttendence> {
  List attendance = [];
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  _icrementCounter() async {
    List<Map<String, dynamic>> templist = [];
    var data = await FirebaseFirestore.instance
        .collection("students")
        .where("classid",
            isEqualTo:
                FirebaseFirestore.instance.doc("classes/${widget.ClassId}"))
        .get();
    data.docs.forEach((element) {
      templist.add(element.data());
    });
    setState(() {
      attendance = templist;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _icrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        ElevatedButton(
            child: const Text('Export to Excel'),
            onPressed: () async {
              var directory;
              // Retrieve data from Firestore
              final querySnapshot = await FirebaseFirestore.instance
                  .collection("students")
                  .where("classid",
                      isEqualTo: FirebaseFirestore.instance
                          .doc("classes/${widget.ClassId}"))
                  .get();

              // Create Excel workbook and sheet
              final excel = Excel.createExcel();
              final sheet = excel[widget.ClassTitle];

              // Write data to Excel sheet
              sheet.appendRow(['rollnumber', 'faculty', 'timestamp']);
              for (final document in querySnapshot.docs) {
                sheet.appendRow([
                  document['rollnumber'],
                  document['faculty'],
                  document['timestamp']
                ]);
              }

              // Save Excel file to device
              // final directory = await getApplicationDocumentsDirectory();

              final documentsDir = await getExternalStorageDirectory();
              List<String> p = documentsDir!.path.split('/');
              var newPath = '';

              for (int x = 1; x < p.length; x++) {
                String folder = p[x];
                if (folder != 'Android') {
                  newPath += '/' + folder;
                } else {
                  break;
                }
              }
              newPath += '/Attendance/${widget.ClassTitle}.xlsx';
              directory = Directory(newPath);
              // final filePath = directory.

              // Save the workbook to the file path
              var permisssion =
                  await Permission.manageExternalStorage.request();
              if (permisssion.isGranted) {
                var fileBytes = excel.save(fileName: newPath);
                if (fileBytes != null) {
                  File(newPath)
                    ..createSync(recursive: true)
                    ..writeAsBytesSync(fileBytes);
                }
              }

              // createSync(recursive: true).writeAsBytesSync(fileBytes);
              // print(newPath);
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(newPath),
                ),
              );
            })
      ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("students")
              .where("classid",
                  isEqualTo: FirebaseFirestore.instance
                      .doc("classes/${widget.ClassId}"))
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var templist = [];
            var data = snapshot.data!.docs;
            data.forEach((element) {
              templist.add(element.data());
            });
            attendance = templist;
            return ListView.builder(
                itemCount: attendance.length + 1,
                itemBuilder: ((context, index) {
                  if (index == 0) {
                    return SizedBox(
                      height: 40,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rollnumber',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Faculty',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Attended on',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 60,
                    child: Card(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(this.attendance[index - 1]["rollnumber"],
                            style: TextStyle(fontSize: 15)),
                        Flexible(
                          child: Text(
                            this.attendance[index - 1]["faculty"],
                            style: TextStyle(fontSize: 13),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Text(this.attendance[index - 1]["timestamp"],
                            style: TextStyle(fontSize: 15))
                      ],
                    )),
                  );
                }));
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.share),
        onPressed: () async {
          var directory;
          // Retrieve data from Firestore
          final querySnapshot = await FirebaseFirestore.instance
              .collection("students")
              .where("classid",
                  isEqualTo: FirebaseFirestore.instance
                      .doc("classes/${widget.ClassId}"))
              .get();

          // Create Excel workbook and sheet
          final excel = Excel.createExcel();
          final sheet = excel[widget.ClassTitle];

          // Write data to Excel sheet
          sheet.appendRow(['rollnumber', 'faculty', 'timestamp']);
          for (final document in querySnapshot.docs) {
            sheet.appendRow([
              document['rollnumber'],
              document['faculty'],
              document['timestamp']
            ]);
          }

          // Save Excel file to device
          // final directory = await getApplicationDocumentsDirectory();

          final documentsDir = await getExternalStorageDirectory();
          List<String> p = documentsDir!.path.split('/');
          var newPath = '';

          for (int x = 1; x < p.length; x++) {
            String folder = p[x];
            if (folder != 'Android') {
              newPath += '/' + folder;
            } else {
              break;
            }
          }
          newPath += '/Attendance/${widget.ClassTitle}.xlsx';
          directory = Directory(newPath);
          // final filePath = directory.

          // Save the workbook to the file path
          var permisssion = await Permission.manageExternalStorage.request();
          if (permisssion.isGranted) {
            var fileBytes = excel.save(fileName: newPath);
            if (fileBytes != null) {
              File(newPath)
                ..createSync(recursive: true)
                ..writeAsBytesSync(fileBytes);
            }
          }
          Share.shareFiles([newPath]);
          // createSync(recursive: true).writeAsBytesSync(fileBytes);
          // print(newPath);
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(newPath),
            ),
          );
        },
      ),
    );
  }
}
