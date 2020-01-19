import 'package:flutter/material.dart';
import 'package:fluttergrab/core/viewmodels/instructor.dart';
import 'package:fluttergrab/core/viewmodels/student.dart';
import 'package:fluttergrab/ui/views/dashboard.dart';
import 'package:fluttergrab/ui/views/main-page.dart';
import 'package:fluttergrab/ui/views/splash.dart';

class Router {
  static Route<dynamic> generateRoute(settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashView());
      case '/main':
        return MaterialPageRoute(builder: (_) => DashboardMain());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case '/student':
        return MaterialPageRoute(builder: (_) => StudentViewModel());
      case '/instructor':
        return MaterialPageRoute(builder: (_) => InstructorViewModel());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
