import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewAttendence extends StatefulWidget {
  final List rollnumbers;
  const ViewAttendence({super.key, required this.rollnumbers});

  @override
  State<ViewAttendence> createState() => _ViewAttendenceState();
}

class _ViewAttendenceState extends State<ViewAttendence> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(),
          children: widget.rollnumbers
              .map((rollnumber) => TableRow(children: [Text(rollnumber)]))
              .toList(),
        ),
      ),
    );
  }
}
