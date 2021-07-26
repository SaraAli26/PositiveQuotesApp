import 'dart:async';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'package:qoutesapp/Models/QuoteModel.dart';
import 'package:qoutesapp/Pages/HomePage.dart';
import 'package:qoutesapp/Services/AuthService.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<QuoteModel> myFavQuotes = [];
  bool isLoading = false;

  void initState() {
    super.initState();
    load();
  }

  getFavQuotes() async{
    return AuthService().getUserFavQuotes();
  }

  delFavQuotes(String quote) async{
    return AuthService().deleteFavoriteQuote(quote);
  }

  load() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      myFavQuotes = await getFavQuotes();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
    //_refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading ?
      CircularProgressIndicator()
      : Container(
        padding: EdgeInsets.fromLTRB(10,80,10, 0),
        child: myFavQuotes.length == 0 ? Center(child: Text("No Favorite Quotes!"),): ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: myFavQuotes.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(myFavQuotes[index].quote) ,
                subtitle: Text(myFavQuotes[index].author),
                trailing: IconButton(icon: Icon(Icons.delete),   onPressed: (){
                  delFavQuotes(myFavQuotes[index].quote);
                  final snackBar = SnackBar(
                    content: Text('Favorite Quote Deleted!'),
                    action: SnackBarAction(
                      label: '',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  var timer = Timer(Duration(seconds: 3), () =>  load());
                },
                ),
              );
            }
        ),
      ),
    );
  }
}
