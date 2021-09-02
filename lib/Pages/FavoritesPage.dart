import 'dart:async';
import 'package:flutter/material.dart';

import 'package:qoutesapp/Models/QuoteModel.dart';
import 'package:qoutesapp/Services/AuthService.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<QuoteModel> myFavQuotes = [];

   Future<List<QuoteModel>> getFavQuotes() async {
    myFavQuotes = await AuthService().getUserFavQuotes();
    return myFavQuotes;
  }

  delFavQuotes(String quote) async {
    return AuthService().deleteFavoriteQuote(quote);
  }

  updateAfterDelete(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuoteModel>>(
        future: getFavQuotes(),
        builder: (context, AsyncSnapshot<List<QuoteModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          else if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasError){
              return Center(child: Text('Something went wrong :('));
            }
            else {
              return Container(
                padding: EdgeInsets.fromLTRB(10, 80, 10, 0),
                child: myFavQuotes.length == 0
                    ? Center(
                  child: Text("No Favorite Quotes!"),
                )
                    : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: myFavQuotes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(myFavQuotes[index].quote),
                          subtitle: Text("~ " + myFavQuotes[index].author),
                          trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return AlertDialog(
                                        title: Text('Please Confirm'),
                                        content: Text(
                                            'Are you sure to remove the Quote from favorites?'),
                                        actions: [
                                          // The "Yes" button
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                delFavQuotes(
                                                    myFavQuotes[index].quote);
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                      'Favorite Quote Deleted!'),
                                                  action: SnackBarAction(
                                                    label: '',
                                                    onPressed: () {
                                                      // Some code to undo the change.
                                                    },
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                var timer = Timer(
                                                    Duration(seconds: 1),
                                                        () => updateAfterDelete());
                                              },
                                              child: Text('Yes')),
                                          TextButton(
                                              onPressed: () {
                                                // Close the dialog
                                                Navigator.of(context).pop();
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
         return Center(child: Text('Something Went Wrong! please refresh the page'));
        }
    );
  }
}
