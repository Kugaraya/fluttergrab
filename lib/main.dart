import 'package:fluttergrab/ui/router.dart';
import 'package:fluttergrab/locator.dart';
import 'package:flutter/material.dart';

void main(){
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrabTutor',
      theme: ThemeData(
        primaryColor: Colors.amber[300],
        accentColor: Colors.brown[300]
      ),
      initialRoute: '/',
      onGenerateRoute: Router.generateRoute,
    );
  }
}
