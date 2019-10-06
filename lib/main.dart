import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttergrab/screens/login/loginanim.dart';
import 'package:fluttergrab/screens/register/register.dart';
import 'package:fluttergrab/screens/splash/splash.dart';
import 'package:fluttergrab/screens/login/login.dart';
import 'package:fluttergrab/screens/dashboard/dashboard.dart';

void main(){
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(MyApp())
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grab A Tutor',
      theme: ThemeData(
        primarySwatch: Colors.amber[300],
        accentColor: Colors.brown[300]
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => SplashDisplay(),
        '/after' : (context) => LoginAnimate(),
        '/login' : (context) => LoginScreen(),
        '/register' : (context) => RegisterScreen(),
        '/dashboard' : (context) => DashboardScreen(),
      },
    );
  }
}
