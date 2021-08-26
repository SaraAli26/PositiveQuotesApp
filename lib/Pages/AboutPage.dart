import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qoutesapp/Services/AuthService.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context)  {
    var currentTime = DateTime.now();

    return Scaffold(

      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal),
          title: Text(
            currentTime.hour < 12 ? "Good Morning" : "Good Evening!",
            style: TextStyle(color: Colors.teal),
          ),

          backgroundColor: Colors.transparent,
          elevation: 0,
          brightness: Brightness.light),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Text("About Page!"),
        ),
      )
    );
  }

}
