import 'package:flutter/material.dart';
import 'package:fluttergrab/ui/widgets/menu.dart';

class AdminViewModel extends StatefulWidget {
  @override
  _AdminViewModelState createState() => _AdminViewModelState();
}

class _AdminViewModelState extends State<AdminViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: adminDrawer(context),
      body: Container(
        child: Center(child: Text("Admin View")),
      ),
    );
  }
}