import 'dart:ffi';

import 'package:attendance/models/newClassEntry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  late String selectedItem = 'Fullday';
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
  _icrementCounter() async {
    List<Map<String, dynamic>> templist = [];
    var data = await FirebaseFirestore.instance
        .collection("classes")
        .orderBy('Date', descending: false)
        .get();
    data.docs.forEach((element) {
      templist.add(element.data());
    });
    setState(() {
      items = templist;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      appBar: AppBar(title: const Text('Attendance')),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('classes')
              .orderBy('Date', descending: false)
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
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(
                    height: 40,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Title',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Category',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Class held on',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  );
                }
                tbs.add(NewClassEntry(
                    this.items[index - 1]["classid"],
                    this.items[index - 1]["Title"],
                    this.items[index - 1]["Category"],
                    this.items[index - 1]['Date'],
                    this.items[index - 1]["Description"],
                    this.items[index - 1]["Type"]));
                return tbs[index - 1].createEntry(context, items);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (() {
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
                            Navigator.of(context).pop();
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
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
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
                                              controller: categoryController,
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
                                              controller: descriptionController,
                                              decoration: InputDecoration(
                                                labelText: 'Description',
                                              ),
                                            ),
                                            TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Fullday or Forenoon or Afternoon';
                                                }
                                                return null;
                                              },
                                              controller: typeController,
                                              decoration: InputDecoration(
                                                labelText: 'Attendance type',
                                              ),
                                            ),
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
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              setState(() {
                                                String ts = DateFormat(
                                                        'yyyy-MM-dd – kk:mm')
                                                    .format(Timestamp.now()
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
                                                      categoryController.text,
                                                  "Date": ts,
                                                  "Description":
                                                      descriptionController
                                                          .text,
                                                  "Title": titleController.text,
                                                  "Type": typeController.text
                                                });
                                                this.items.add({
                                                  "classid": id,
                                                  "Category":
                                                      categoryController.text,
                                                  "Date": ts,
                                                  "Description":
                                                      descriptionController
                                                          .text,
                                                  "Title": titleController.text,
                                                  "Type": typeController.text
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
          })),
    );
  }
}
