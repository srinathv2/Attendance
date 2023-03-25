import 'package:attendance/screens/classPage.dart';
import 'package:flutter/material.dart';

class NewClassEntry {
  late String title, category, date;
  NewClassEntry(this.title, this.category, this.date);
  TextButton createEntry(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClassPage(classEntry: this)),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(this.title), Text(this.category), Text(this.date)],
        ));
  }
}
