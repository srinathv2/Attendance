import 'dart:ffi';

import 'package:attendance/models/newClassEntry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  List tbs = [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Title',
            style: TextStyle(color: Colors.black),
          ),
          Text('Category', style: TextStyle(color: Colors.black)),
          Text('Date', style: TextStyle(color: Colors.black))
        ],
      ),
    )
  ];
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
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
      body: ListView.builder(
        itemCount: tbs.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return tbs[index];
          }
          return tbs[index].createEntry(context);
        },
      ),
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
                                              decoration: InputDecoration(
                                                labelText: 'Date',
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter date.';
                                                }
                                                return null;
                                              },
                                              controller: dateController,
                                              onTap: () {
                                                // FocusScope.of(context)
                                                //     .requestFocus(
                                                //         new FocusNode());
                                                showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2101))
                                                    .then((selectedDate) {
                                                  if (selectedDate != null) {
                                                    dateController.text =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(
                                                                selectedDate);
                                                  }
                                                });
                                              },
                                            )
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
                                                this.tbs.add(NewClassEntry(
                                                    titleController.text,
                                                    categoryController.text,
                                                    dateController.text));
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
