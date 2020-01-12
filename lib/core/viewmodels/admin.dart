import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergrab/core/services/auth-service.dart';
import 'package:fluttergrab/ui/widgets/menu.dart';

class AdminViewModel extends StatefulWidget {
  AdminViewModel(
      {Key key,
      this.userEmail,
      this.userId,
      this.auth,
      this.logoutCallback,
      this.db})
      : super(key: key);

  final Firestore db;
  final String userEmail;
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

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
