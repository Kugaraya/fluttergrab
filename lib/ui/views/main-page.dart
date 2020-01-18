import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergrab/core/services/auth-service.dart';
import 'package:fluttergrab/core/viewmodels/admin.dart';
import 'package:fluttergrab/core/viewmodels/instructor.dart';
import 'package:fluttergrab/core/viewmodels/student.dart';

class DashboardMain extends StatefulWidget {
  DashboardMain(
      {Key key,
      this.auth,
      this.userId,
      this.logoutCallback,
      this.userEmail,
      this.db})
      : super(key: key);

  final Firestore db;
  final String userEmail;
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  _DashboardMainState createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  @override
  Widget build(BuildContext context) {
    Widget _forScreen() {
      return StreamBuilder(
        stream: widget.db
            .collection('accounts')
            .where("uid", isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          int checker = snapshot.data.documents[0]["permission"];
          print(checker);
          switch (checker) {
            case 0:
              return StudentViewModel(
                db: widget.db,
                auth: widget.auth,
                userEmail: widget.userEmail,
                userId: widget.userId,
                logoutCallback: widget.logoutCallback,
              );

            case 1:
              return InstructorViewModel(
                db: widget.db,
                auth: widget.auth,
                userEmail: widget.userEmail,
                userId: widget.userId,
                logoutCallback: widget.logoutCallback,
              );

            case 2:
              return AdminViewModel(
                db: widget.db,
                auth: widget.auth,
                userEmail: widget.userEmail,
                userId: widget.userId,
                logoutCallback: widget.logoutCallback,
              );
            default:
              return Center(child: Text("Account invalid"));
          }
        },
      );
    }

    return Scaffold(body: _forScreen());
  }
}
