import 'package:flutter/services.dart';
import 'package:fluttergrab/ui/router.dart';
import 'package:fluttergrab/locator.dart';
import 'package:flutter/material.dart';

void main(){
  setupLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIOverlays([]);
        break;

      default:
        break;
    }
  }

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
