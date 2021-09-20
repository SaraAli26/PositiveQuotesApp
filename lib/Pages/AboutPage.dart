import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
          padding: EdgeInsets.fromLTRB(80, 0, 80, 0),

          child: Text("About Hope! \n \n Hope Application Provides you with a daily motivation quotes \n that you can view, save and share. \n Also you will be "
              "notified daily to view quotes \n \n \n ©. All Rights reserved Hope " + DateTime.now().year.toString(), textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),),
        ),
      )
    );
  }

}
