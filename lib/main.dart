import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:qoutesapp/Pages/FavoritesPage.dart';
import 'package:qoutesapp/Pages/HomePage.dart';
import 'package:qoutesapp/Pages/ProfilePage.dart';
import 'package:qoutesapp/Services/AuthService.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Pages/AboutPage.dart';
import 'Pages/ChangePasswordPage.dart';
import 'Pages/GratitudeJournalPage.dart';
import 'Pages/IntroSliderPage.dart';
import 'Pages/SplashPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent landscape mood
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var currentTime = DateTime.now();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Positive Quotes App',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          //home: MyHomePage(title: 'Good morning Sara!',),
          home: auth.isAuth
              ? MyHomePage(
                  title:
                      currentTime.hour < 12 ? "Good Morning!" : "Good Evening!",
                )
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashPage()
                          :
                          //AuthScreen(),
                          IntroSliderPage(),
                ),
        ),
      ),
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
  int _currentIndex = 1;

  List<Widget> _pages = <Widget>[ProfilePage(), HomePage(), FavoritesPage()];

  @override
  Widget build(BuildContext context) {
    //To Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white12,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 130,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Center(
                    child: Text(
                  'Make Today counts!',
                  style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                )),
              ),
            ),
            ListTile(
              title: const Text('Gratitude Journal'),
              trailing: Icon(Icons.book_rounded),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GratitudeJournalPage())),
            ),
            Divider(),
            ListTile(
              title: const Text('Change Password'),
              trailing: Icon(Icons.vpn_key),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordPage())),
            ),
            ListTile(
              title: const Text('Rate the app'),
              trailing: Icon(Icons.star),
              onTap: () async =>  await launch("https://play.google.com/store/apps/details?id=com.saraahmed.positivebits"),
            ),
            ListTile(
              title: const Text('About Positive Bits'),
              trailing: Icon(Icons.help_outline),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutPage())),
            ),
            ListTile(
              title: const Text('Logout'),
              trailing: Icon(Icons.logout),
              onTap: () {
                Provider.of<AuthService>(context, listen: false).logout();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal),
          title: Text(
            currentTime.hour < 12 ? widget.title : "Good Evening!",
            style: TextStyle(color: Colors.teal),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          brightness: Brightness.light),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: _pages.elementAt(_currentIndex),
      // Thi
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: 'Profile'),
          TabItem(
              icon: Icon(Icons.home_filled, color: Colors.white),
              title: 'Home'),
          TabItem(
              icon: Icon(Icons.favorite, color: Colors.white),
              title: 'Favorites'),
        ],
        initialActiveIndex: _currentIndex,
        backgroundColor: Colors.teal,
        activeColor: Colors.teal,
        onTap: _changePage,
      ), // s trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _changePage(int value) {
    print(value);
    setState(() {
      _currentIndex = value;
    });
  }
}
