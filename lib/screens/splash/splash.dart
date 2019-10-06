import 'package:flutter/material.dart';
import 'package:fluttergrab/screens/login/loginanim.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashDisplay extends StatefulWidget {
  @override
  _SplashDisplayState createState() => _SplashDisplayState();
}

class _SplashDisplayState extends State<SplashDisplay> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: LoginAnimate(),
      title: Text("Grab A Tutor",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
      ),
      image: Image.asset('assets/logo.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(fontSize: 8.0, color: Colors.grey[400]),
      photoSize: 100.0,
      onClick: () => Fluttertoast.showToast(
        msg: "Relax, your app will load in a bit",
        backgroundColor: Color.fromARGB(80,0,0,0),
        gravity: ToastGravity.BOTTOM,
        fontSize: 12.0,
        textColor: Colors.white,
        timeInSecForIos: 1,
        toastLength: Toast.LENGTH_SHORT
      ),
    );
  }
}