import 'package:attendance/screens/classPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:attendance/screens/home.dart';

class NewClassEntry {
  late String classid, title, category, date, empname;

  var _formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var categoryController = TextEditingController();

  var descriptionController = TextEditingController();
  var typeController = TextEditingController();

  String selectedItem = 'Fullday';
  List<String> attendanceTypes = ['Fullday', 'Forenoon', 'Afternoon'];

  var desc;

  var type;
  NewClassEntry(this.classid, this.title, this.category, this.date, this.desc,
      this.type, this.empname);

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
                        content: Text('Do you want to edit the Class info?'),
                        actions: [
                          TextButton(
                              onPressed: (() {
                                Navigator.of(context).pop();
                              }),
                              child: Text('No')),
                          TextButton(
                              onPressed: (() {
                                titleController.text = this.title;
                                categoryController.text = this.category;
                                descriptionController.text = this.desc;
                                // typeController.text = this.type;
                                selectedItem = this.type;
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
                                                //     labelText:
                                                //         'Attendance type',
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
                                                        })
                                                        .toSet()
                                                        .toList(),
                                                    onChanged: (value) {
                                                      // Future.microtask(() {
                                                      // setState(() {
                                                      this.selectedItem =
                                                          value.toString();
                                                      // });
                                                      // });
                                                    }),
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
                                                  // setState(() {

                                                  FirebaseFirestore.instance
                                                      .collection("classes")
                                                      .doc(this.classid)
                                                      .update({
                                                    "classid": this.classid,
                                                    "Category":
                                                        categoryController.text,
                                                    "Description":
                                                        descriptionController
                                                            .text,
                                                    "Title":
                                                        titleController.text,
                                                    "Type": selectedItem
                                                  });

                                                  Navigator.of(context).pop();
                                                  // }
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
              }),
          FocusedMenuItem(
              title: Text('Delete'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('classes')
                    .doc('${this.classid}')
                    .delete()
                    .then(((value) => SnackBar(
                        content: Text('${this.title} class deleted'))));
                FirebaseFirestore.instance
                    .collection('students')
                    .where("classid",
                        isEqualTo: FirebaseFirestore.instance
                            .doc("classes/${this.classid}"))
                    .get()
                    .then((value) => value.docs.forEach((element) {
                          FirebaseFirestore.instance
                              .collection('students')
                              .doc(element.id)
                              .delete();
                        }));
              })
        ],
        child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClassPage(classEntry: this)),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Text(
                    'Title',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 54,
                  ),
                  Text(this.title)
                ]),
                Row(children: [
                  Text(
                    'Category',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(this.category)
                ]),
                Row(children: [
                  Text(
                    'Type',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text(this.type)
                ]),
                Row(children: [
                  Text(
                    'Date',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text(this.date)
                ])
              ],
            )),
      ),
    );
  }
}
