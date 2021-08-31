import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'AuthPage.dart';

class IntroSliderPage extends StatefulWidget {
  const IntroSliderPage({Key? key}) : super(key: key);

  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Daily Positive Quotes!",
        description: "Every Once in a while, we need a little reminder to remember that eventually every thing will be Ok!",
        pathImage: "assets/Images/getquotes.png",
        backgroundColor: Color(0xff008080),
      ),
    );
    slides.add(
      new Slide(
        title: "Save the Quote!",
        description: "Add the quotes that you like into your favorite list, and read it later whenever you use the app!",
        pathImage: "assets/Images/favorite.png",
        backgroundColor: Color(0xff008080),
      ),
    );
    slides.add(
      new Slide(
        title: "Share with your friends",
        description:
        "Share the quotes that you like with your friends in social media, just click the share button and it will be shared in the selected platform!",
        pathImage:  "assets/Images/share.png",
        backgroundColor: Color(0xff008080),
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new IntroSlider(
        slides: this.slides,
        onDonePress: this.onDonePress,
      ),
    );
  }
}
