import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergrab/core/services/auth-service.dart';
import 'package:fluttergrab/ui/views/instructor-manage.dart';
import 'package:fluttergrab/ui/views/student-manage.dart';

class CardBuilder {
  CardBuilder({this.db, this.userEmail, this.userId, this.auth});

  Firestore db;
  String userEmail;
  String userId;
  BaseAuth auth;

  Widget studentEnrolled(BuildContext context, Firestore db, String uid,
      SliverGridDelegate _gridDelegate) {
    return StreamBuilder(
        stream: db
            .collection("classes")
            .where("students", arrayContains: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.documents.length == 0) {
            return Center(
              child: Text(
                "You haven't enrolled on any class yet",
                textScaleFactor: 2.0,
                textAlign: TextAlign.center,
              ),
            );
          }
          return GridView(
            gridDelegate: _gridDelegate,
            children: <Widget>[
              for (int i = 0; i < snapshot.data.documents.length; i++)
                Card(
                  elevation: 5.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentManage(
                                    auth: auth,
                                    db: db,
                                    userEmail: userEmail,
                                    userId: userId,
                                    document: snapshot.data.documents[i],
                                  )));
                    },
                    child: GridTile(
                      header: GridTileBar(
                        leading: snapshot.data.documents[i]["costs"] == null
                            ? null
                            : snapshot.data.documents[i]["costs"] < 1
                                ? Icon(
                                    Icons.attach_money,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.attach_money,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        trailing: Icon(
                          Icons.info_outline,
                          color: snapshot.data.documents[i]["status"]
                              ? Colors.black
                              : Colors.red,
                        ),
                        title: Center(
                            child: Text(snapshot.data.documents[i]["subject"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold))),
                      ),
                      child: Center(
                        child: Text(snapshot.data.documents[i]["topic"],
                            textAlign: TextAlign.center),
                      ),
                      footer: Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12.0),
                              child: Text(snapshot.data.documents[i]["schedule"]
                                      ["days"] +
                                  ", " +
                                  snapshot.data.documents[i]["schedule"]
                                      ["time-start"] +
                                  "-" +
                                  snapshot.data.documents[i]["schedule"]
                                      ["time-end"]))),
                    ),
                  ),
                )
            ],
          );
        });
  }

  Widget studentAvailable(BuildContext context, Firestore db, String uid,
      SliverGridDelegate _gridDelegate) {
    return StreamBuilder(
        stream: db
            .collection("classes")
            .where("status", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.documents.length == 0) {
            return Center(
              child: Text(
                "There are no available classes yet, wait/ask for an instructor to post one",
                textScaleFactor: 2.0,
                textAlign: TextAlign.center,
              ),
            );
          }
          return GridView(
            gridDelegate: _gridDelegate,
            children: <Widget>[
              for (int i = 0; i < snapshot.data.documents.length; i++)
                Card(
                  elevation: 5.0,
                  child: InkWell(
                    onTap: () {
                      print(snapshot.data.documents[i]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentManage(
                                    auth: auth,
                                    db: db,
                                    userEmail: userEmail,
                                    userId: userId,
                                    document: snapshot.data.documents[i],
                                  )));
                    },
                    child: GridTile(
                      header: GridTileBar(
                        leading: snapshot.data.documents[i]["costs"] == null
                            ? null
                            : snapshot.data.documents[i]["costs"] < 1
                                ? Icon(
                                    Icons.attach_money,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.attach_money,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        trailing: Icon(
                          Icons.info_outline,
                          color: snapshot.data.documents[i]["status"]
                              ? Colors.black
                              : Colors.red,
                        ),
                        title: Center(
                            child: Text(snapshot.data.documents[i]["subject"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data.documents[i]["topic"],
                          textAlign: TextAlign.center,
                        ),
                      ),
                      footer: Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12.0),
                              child: Text(snapshot.data.documents[i]["schedule"]
                                      ["days"] +
                                  ", " +
                                  snapshot.data.documents[i]["schedule"]
                                      ["time-start"] +
                                  "-" +
                                  snapshot.data.documents[i]["schedule"]
                                      ["time-end"]))),
                    ),
                  ),
                )
            ],
          );
        });
  }

  Widget instructorHandled(BuildContext context, Firestore db, String uid,
      SliverGridDelegate _gridDelegate) {
    return StreamBuilder(
        stream: db
            .collection("classes")
            .where("instructor", isEqualTo: uid)
            .where("status", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.documents.length == 0) {
            return Center(
              child: Text(
                "Hey, it's empty here! Would you like to start a new class?",
                textScaleFactor: 2.0,
                textAlign: TextAlign.center,
              ),
            );
          }
          return GridView(
            gridDelegate: _gridDelegate,
            children: <Widget>[
              for (int i = 0; i < snapshot.data.documents.length; i++)
                Card(
                  elevation: 5.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InstructorManage(
                                    auth: auth,
                                    db: db,
                                    userEmail: userEmail,
                                    userId: userId,
                                    document: snapshot.data.documents[i],
                                  )));
                    },
                    child: GridTile(
                      header: GridTileBar(
                        leading: snapshot.data.documents[i]["costs"] == null
                            ? null
                            : snapshot.data.documents[i]["costs"] < 1
                                ? Icon(
                                    Icons.attach_money,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.attach_money,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        trailing: Icon(
                          Icons.info_outline,
                          color: snapshot.data.documents[i]["status"]
                              ? Colors.black
                              : Colors.red,
                        ),
                        title: Center(
                            child: Text(snapshot.data.documents[i]["subject"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold))),
                      ),
                      child: Center(
                        child: Text(snapshot.data.documents[i]["topic"],
                            textAlign: TextAlign.center),
                      ),
                      footer: Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12.0),
                              child: Text(snapshot.data.documents[i]["schedule"]
                                      ["days"] +
                                  ", " +
                                  snapshot.data.documents[i]["schedule"]
                                      ["time-start"] +
                                  "-" +
                                  snapshot.data.documents[i]["schedule"]
                                      ["time-end"]))),
                    ),
                  ),
                )
            ],
          );
        });
  }

  Widget instructorDone(BuildContext context, Firestore db, String uid,
      SliverGridDelegate _gridDelegate) {
    return StreamBuilder(
        stream: db
            .collection("classes")
            .where("instructor", isEqualTo: uid)
            .where("status", isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.documents.length == 0) {
            return Center(
              child: Text(
                "You have no done classes in so far yet",
                textScaleFactor: 2.0,
                textAlign: TextAlign.center,
              ),
            );
          }
          return GridView(
            gridDelegate: _gridDelegate,
            children: <Widget>[
              for (int i = 0; i < snapshot.data.documents.length; i++)
                Card(
                  elevation: 5.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InstructorManage(
                                    auth: auth,
                                    db: db,
                                    userEmail: userEmail,
                                    userId: userId,
                                    document: snapshot.data.documents[i],
                                  )));
                    },
                    child: GridTile(
                      header: GridTileBar(
                        leading: snapshot.data.documents[i]["costs"] == null
                            ? null
                            : snapshot.data.documents[i]["costs"] < 1
                                ? Icon(
                                    Icons.attach_money,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.attach_money,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        trailing: Icon(
                          Icons.info_outline,
                          color: snapshot.data.documents[i]["status"]
                              ? Colors.black
                              : Colors.red,
                        ),
                        title: Center(
                            child: Text(snapshot.data.documents[i]["subject"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold))),
                      ),
                      child: Center(
                        child: Text(snapshot.data.documents[i]["topic"],
                            textAlign: TextAlign.center),
                      ),
                      footer: Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12.0),
                              child: Text(snapshot.data.documents[i]["schedule"]
                                      ["days"] +
                                  ", " +
                                  snapshot.data.documents[i]["schedule"]
                                      ["time-start"] +
                                  "-" +
                                  snapshot.data.documents[i]["schedule"]
                                      ["time-end"]))),
                    ),
                  ),
                )
            ],
          );
        });
  }
}
