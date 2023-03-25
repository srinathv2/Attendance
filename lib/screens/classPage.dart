import 'dart:io';

import 'package:attendance/models/newClassEntry.dart';
import 'package:attendance/screens/ViewAttendence.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key, required this.classEntry});
  final NewClassEntry classEntry;

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  List<String> rollnumbers = [];
  var numberOfStudents;
  String barcode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.classEntry.title), actions: [
        ElevatedButton.icon(
            onPressed: () {
              scanBarcode();
              if (!this.barcode.isEmpty) {
                rollnumbers.add(this.barcode);
              }
              setState(() {
                this.numberOfStudents = rollnumbers.length;
              });
            },
            icon: Icon(Icons.qr_code_scanner),
            label: Text('SCAN'))
      ]),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            children: [
              TableRow(children: [
                Center(child: Text('Category')),
                Center(child: Text(widget.classEntry.category))
              ]),
              TableRow(children: [
                Center(child: Text('Date')),
                Center(child: Text(widget.classEntry.date))
              ]),
              TableRow(children: [
                Center(child: Text('Number of attendee')),
                Center(
                  child: Text(
                      (rollnumbers.length != null ? rollnumbers.length : '0')
                          .toString()),
                )
              ])
            ],
            border: TableBorder.all(),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ViewAttendence(rollnumbers: this.rollnumbers)));
        },
        child: Text('View Attendence'),
      ),
    );
  }

  Future<void> scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (!mounted) return;
      setState(() {
        this.barcode = barcode;
      });
    } on PlatformException {
      barcode = 'failed to get platform version';
    }
  }
}
