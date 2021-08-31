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
  //List<QuoteModel> y = [];
  QuoteModel todayQuote = new QuoteModel(
      author: "author",
      quote: "Loading...",
      time: "time",
      category: "category",
      date: "date");
  String favMessage = "Quote Added to Favorite!";

  Icon favIcon = Icon(Icons.favorite_border);

  void initState() {
    super.initState();
    load();
  }

  getQuotes() async {
    return await QuotesService().getMyQuotes();
  }

  getQuoteOfToday() async {
    return await QuotesService().getQuoteOfToday();
  }

  isFavorite(quote) async {
    return await AuthService().isFavoriteQuote(quote);
  }

  Future<void> _favUnfav() async {
    bool favorite = await isFavorite(todayQuote.quote);
    if (favorite == true) {
    } else {
      setState(() {
        favMessage = "Quote Already in Favorites!";
        favIcon = Icon(Icons.favorite);
      });
    }
  }

  load() async {
    try {
      setState(() {
        //isLoading = true;
      });
      //y = await getQuotes();
      todayQuote = await getQuoteOfToday();
      bool favorite = await isFavorite(todayQuote.quote);
      if (favorite == true) {
        // fav = true;
        favIcon = Icon(Icons.favorite);
        setState(() {
          favMessage = "Quote Already in Favorites!";
        });
      } else {
        favIcon = Icon(Icons.favorite_border);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      //  isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
                          child: Image.asset('assets/Images/flowers.jpg',
                              fit: BoxFit.cover,
                              color: Colors.grey,
                              colorBlendMode: BlendMode.modulate),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Text(
                                  'Quote Of The Day',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  todayQuote.quote,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "~ " + todayQuote.author,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                alignment: Alignment.bottomRight,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          _favUnfav();
                          final snackBar = SnackBar(
                            content: Text(favMessage),
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );
                          AuthService().addFavoriteQuote(
                              todayQuote.author,
                              todayQuote.quote,
                              todayQuote.category,
                              todayQuote.date,
                              todayQuote.time);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: favIcon,
                      ),
                      TextButton(
                        onPressed: () {
                          Share.share(todayQuote.quote +
                              '\n ~' +
                              todayQuote.author +
                              '\n \n Get daily motivation Quotes by downloading Hope App at https://saraahmed.net');
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
