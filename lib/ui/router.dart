import 'package:flutter/material.dart';
import 'package:fluttergrab/ui/views/auth.dart';
import 'package:fluttergrab/ui/views/home.dart';

class Router {
  static Route<dynamic> generateRoute(settings) {
    switch (settings.name) {
      case '/' :
        return MaterialPageRoute(builder: (_)=> AuthView());
      case '/home' :
        return MaterialPageRoute(builder: (_)=> HomeView());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'),),));
    }
  }
}
