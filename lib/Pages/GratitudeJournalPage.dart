import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qoutesapp/Models/JournalModel.dart';
import 'package:qoutesapp/Services/AuthService.dart';

class GratitudeJournalPage extends StatefulWidget {
  const GratitudeJournalPage({Key? key}) : super(key: key);

  @override
  _GratitudeJournalPageState createState() => _GratitudeJournalPageState();
}

class _GratitudeJournalPageState extends State<GratitudeJournalPage> {
  List<JournalModel> myJournals = [];
  String gratitudeJournalEntry = "";
  static DateTime now = new DateTime.now();
  DateTime journalDate = new DateTime(now.year, now.month, now.day);
  final journalController = TextEditingController();


  Future<List<JournalModel>> getJournals() async {
    myJournals = await AuthService().getMyJournals();
    return myJournals;
  }

  delJournal(String journal) async {
    return AuthService().deleteJournal(journal);
  }

  reloadPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var currentTime = DateTime.now();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal),
          title: Text(
            currentTime.hour < 12 ? "Good Morning" : "Good Evening!",
            style: TextStyle(color: Colors.teal),
          ),
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                child: Icon(Icons.close),
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("What are you grateful for today?", textAlign: TextAlign.center,),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: journalController,
                                    maxLines: null,
                                  keyboardType: TextInputType.multiline,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      /*  if (_formKey.currentState.validate()) {
                                                    _formKey.currentState.save();
                                                  }*/
                                      AuthService().addJournal(journalController.text, journalDate.toString());
                                      Navigator.pop(context);
                                      reloadPage();

                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            })],
          backgroundColor: Colors.transparent,
          elevation: 0,
          brightness: Brightness.light),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: FutureBuilder<List<JournalModel>>(
          future: getJournals(),
          builder: (context, AsyncSnapshot<List<JournalModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Center(child: Text('Something went wrong :('));
              } else {
                return Container(
                  padding: EdgeInsets.fromLTRB(10, 80, 10, 0),
                  child: myJournals.length == 0
                      ? Center(
                          child: Text("No Journals Yet!"),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: myJournals.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                title: Text(myJournals[index].journal + "\n"),
                                subtitle: Text(myJournals[index].date.substring(0,11)),
                                trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext ctx) {
                                            return AlertDialog(
                                              title: Text('Please Confirm'),
                                              content: Text(
                                                  'Are you sure you want to delete this journal?'),
                                              actions: [
                                                // The "Yes" button
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      delJournal(
                                                          myJournals[index]
                                                              .journal);
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            'Journal Deleted!'),
                                                        action: SnackBarAction(
                                                          label: '',
                                                          onPressed: () {
                                                            // Some code to undo the change.
                                                          },
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      var timer = Timer(
                                                          Duration(seconds: 1),
                                                          () =>
                                                              reloadPage());
                                                    },
                                                    child: Text('Yes')),
                                                TextButton(
                                                    onPressed: () {
                                                      // Close the dialog
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('No'))
                                              ],
                                            );
                                          });
                                    }),
                              ),
                            );
                          }),
                );
              }
            }
            return Center(
                child: Text('Something Went Wrong! please refresh the page'));
          }),
    );
  }
}
