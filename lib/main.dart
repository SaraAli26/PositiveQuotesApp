import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qoutesapp/Models/QuoteModel.dart';

import 'package:qoutesapp/Pages/FavoritesPage.dart';
import 'package:qoutesapp/Pages/HomePage.dart';
import 'package:qoutesapp/Pages/ProfilePage.dart';
import 'package:qoutesapp/Services/QuotesService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    QuotesService quoser = new QuotesService();

    Firebase.initializeApp();
    quoser.getQuotesCollectionFromFireStore();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Good morning Sara!',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentTime = DateTime.now();
  int _currentIndex = 0 ;
  List<Widget> _pages = <Widget>[
    ProfilePage(),
    HomePage(),
    FavoritesPage()
  ];

  @override
  Widget build(BuildContext context) {

    //To Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white12,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text( currentTime.hour < 12 ? widget.title : "Good Evening Sara",
          style: TextStyle(color: Colors.teal),),
        backgroundColor: Colors.transparent,
        elevation: 0,
          brightness: Brightness.light
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: _pages.elementAt(_currentIndex),// Thi
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon:Icon(Icons.person, color: Colors.white,), title: 'Profile'),
          TabItem(icon:Icon(Icons.home_filled, color: Colors.white), title: 'Home'),
          TabItem(icon:Icon(Icons.favorite, color: Colors.white), title: 'Favorites'),
        ],
        initialActiveIndex: _currentIndex,
        backgroundColor: Colors.teal,
        activeColor: Colors.teal,
        onTap: _changePage,
      ),// s trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _changePage(int value) {
    print(value);
    setState(() {
      _currentIndex = value;
    });
  }
}
