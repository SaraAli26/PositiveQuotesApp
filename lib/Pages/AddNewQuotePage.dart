import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qoutesapp/Pages/HomePage.dart';

class AddNewQuotePage extends StatefulWidget {
  @override
  _AddNewQuotePageState createState() => _AddNewQuotePageState();
}

class _AddNewQuotePageState extends State<AddNewQuotePage> {
  final _formKey = GlobalKey<FormState>();


  final authorController = TextEditingController();
  final quoteController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference().child("quotes");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: "Enter Author Name",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Pet Name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: quoteController,
                decoration: InputDecoration(
                  labelText: "Enter Quote",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Pet Age';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: "Enter catgory",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Pet Age';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: dateController,
                decoration: InputDecoration(
                  labelText: "Enter date",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Pet Age';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: timeController,
                decoration: InputDecoration(
                  labelText: "Enter Time",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Pet Age';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        dbRef.push().set({
                          "author": authorController.text,
                          "quote": quoteController.text,
                          "category": categoryController.text,
                          "date": dateController.text,
                          "time": timeController.text
                        }).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Successfully Added')));
                          authorController.clear();
                          quoteController.clear();
                          categoryController.clear();
                          dateController.clear();
                          timeController.clear();

                        }).catchError((onError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(onError)));
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage()),
                      );
                    },
                    child: Text('Navigate'),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    authorController.dispose();
    quoteController.dispose();
    categoryController.dispose();
    dateController.dispose();
    timeController.dispose();
  }
}
