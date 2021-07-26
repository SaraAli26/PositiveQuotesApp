import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qoutesapp/Models/QuoteModel.dart';
import 'package:qoutesapp/Services/AuthService.dart';
import 'package:qoutesapp/Services/QuotesService.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QuoteModel> y = [];
  QuoteModel u = new QuoteModel(author: "author", quote: "Loading...", time: "time", category: "category", date: "date");

  void initState() {
    super.initState();
    load();
  }

  getQuotes() async {
    return await QuotesService()
        .getMyQuotes();
  }

  getQuoteOfToday() async{
    return await QuotesService().getQuoteOfToday();
  }

  load() async {
    try {
      setState(() {
        //isLoading = true;
      });
      //currentPage = 1;
      y = await getQuotes();
      u = await getQuoteOfToday();
      print("I am the quooote" + u.quote);
    } catch (e) {
      print(e);
    }
    setState(() {
    //  isLoading = false;
    });
    //_refreshController.refreshCompleted();
  }

  //List<QuoteModel> y = QuotesService().getMyQuotes() as List<QuoteModel>;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Container(
        height: 260.0,
        width: 300.0,
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: new Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 180.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Image.asset(
                              'assets/Images/flowers.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 16.0,
                            left: 16.0,
                            right: 16.0,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                u.quote,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            final snackBar = SnackBar(
                              content: Text('Fav Quote Added!'),
                              action: SnackBarAction(
                                label: '',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            AuthService().addFavoriteQuote(u.author, u.quote, u.category,u.date,u.time);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          },
                          child: Icon(Icons.favorite),
                        ),
                        TextButton(
                          onPressed: ()
                            {
                              Share.share(u.quote + '\n ~'+ u.author + '\n \n Get daily motivation Quotes From Share Quotes app at https://example.com');
                          },
                          child: Icon(Icons.share),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
}
