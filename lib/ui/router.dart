import 'package:flutter/material.dart';
import 'package:fluttergrab/ui/views/login.dart';
import 'package:fluttergrab/ui/views/register.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/' :
        return MaterialPageRoute(builder: (_)=> LoginView());
      case '/register' :
        return MaterialPageRoute(builder: (_)=> RegisterView());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'),),));
    }
  }
}
