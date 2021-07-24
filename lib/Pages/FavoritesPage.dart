import 'package:flutter/material.dart';
import 'package:qoutesapp/Models/QuoteModel.dart';
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

  load() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      myFavQuotes = await getFavQuotes();
      print("Aim qooooooooooooo" + myFavQuotes.toString());
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
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: myFavQuotes.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(myFavQuotes[index].quote) ,
                subtitle: Text(myFavQuotes[index].author),
                trailing: Icon(Icons.close),
              );
            }
        ),
      ),
    );
  }
}
