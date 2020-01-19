import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttergrab/core/models/cards.dart';
import 'package:fluttergrab/core/services/auth-service.dart';
import 'package:fluttergrab/core/viewmodels/update.dart';

class StudentViewModel extends StatefulWidget {
  StudentViewModel(
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
  _StudentViewModelState createState() => _StudentViewModelState();
}

class _StudentViewModelState extends State<StudentViewModel>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  CardBuilder cardBuilder;
  SliverGridDelegateWithFixedCrossAxisCount _gridDelegate;
  PageController _pageController;
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    cardBuilder = CardBuilder(
        auth: widget.auth,
        db: widget.db,
        userEmail: widget.userEmail,
        userId: widget.userId);
    _pageController =
        PageController(initialPage: _currentIndex, keepPage: true);
    _gridDelegate =
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_currentIndex == 0
              ? "Enrolled Classes"
              : _currentIndex == 1 ? "Available Classes" : "Settings"),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          animationDuration: Duration(milliseconds: 350),
          height: 50.0,
          buttonBackgroundColor: Theme.of(context).accentColor,
          backgroundColor: Colors.black26,
          color: Theme.of(context).primaryColor,
          onTap: (index) {
            setState(() {
              _pageController.jumpToPage(index);
            });
          },
          items: <Widget>[
            Icon(Icons.grid_on, size: 30, color: Colors.white),
            Icon(Icons.list, size: 30, color: Colors.white),
            Icon(Icons.settings, size: 30, color: Colors.white),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: <Widget>[
            cardBuilder.studentEnrolled(
                context, widget.db, widget.userId, _gridDelegate),
            cardBuilder.studentAvailable(
                context, widget.db, widget.userId, _gridDelegate),
            StreamBuilder(
                stream: widget.db
                    .collection("accounts")
                    .where("uid", isEqualTo: widget.userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 6.0),
                            color: Theme.of(context).accentColor,
                            height: 110.0,
                            child: ListTile(
                              enabled: false,
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  Icons.person_pin,
                                  size: 50,
                                ),
                              ),
                              title: Text(
                                snapshot.data.documents[0]["name"],
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.3,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                snapshot.data.documents[0]["course"],
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.3,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                              child: Text(
                                snapshot.data.documents[0]["position"],
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.1,
                              )),
                          Divider(
                            color: Colors.black26,
                            thickness: 2.0,
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              child: Image.asset("assets/logo.png"),
                            ),
                            title: Text(
                              "A+ Guru",
                              textScaleFactor: 1.5,
                            ),
                          ),
                          Divider(
                            color: Colors.black26,
                            thickness: 2.0,
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Divider(
                            thickness: 2.0,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                              child: Text(
                                "Account",
                                textAlign: TextAlign.left,
                              )),
                          Divider(
                            color: Colors.black26,
                            thickness: 2.0,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UpdateView(
                                        auth: widget.auth,
                                        db: widget.db,
                                        userEmail: widget.userEmail,
                                        userId: widget.userId,
                                        logoutCallback: widget.logoutCallback,
                                        document: snapshot.data.documents[0],
                                        name: snapshot.data.documents[0]
                                            ["name"],
                                        course: snapshot.data.documents[0]
                                            ["course"],
                                        year: snapshot.data.documents[0]
                                            ["year"],
                                      )));
                            },
                            leading: Icon(Icons.edit),
                            title: Text(
                              "Update Info",
                              textScaleFactor: 1.2,
                            ),
                          ),
                          Divider(
                            color: Colors.black26,
                            thickness: 2.0,
                          ),
                          ListTile(
                            onTap: widget.logoutCallback,
                            title: Text(
                              "Sign out",
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.4,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          Divider(
                            color: Colors.black26,
                            thickness: 2.0,
                          ),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ));
  }
}
