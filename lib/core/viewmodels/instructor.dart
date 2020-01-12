import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttergrab/core/models/cards.dart';
import 'package:fluttergrab/core/services/auth-service.dart';
import 'package:fluttergrab/ui/views/instructor-add.dart';

class InstructorViewModel extends StatefulWidget {
  InstructorViewModel(
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
  _InstructorViewModelState createState() => _InstructorViewModelState();
}

class _InstructorViewModelState extends State<InstructorViewModel>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  CardBuilder cardBuilder;
  SliverGridDelegateWithFixedCrossAxisCount _gridDelegate;
  PageController _pageController;
  int _currentIndex;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    cardBuilder = CardBuilder(
      auth: widget.auth,
      db: widget.db,
      userEmail: widget.userEmail,
      userId: widget.userId
    );
    _currentIndex = 0;
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
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstructorAdd(
                                auth: widget.auth,
                                db: widget.db,
                                userEmail: widget.userEmail,
                                userId: widget.userId,
                              )));
                },
                child: Icon(Icons.add),
              )
            : null,
        appBar: AppBar(
          centerTitle: true,
          title: Text(_currentIndex == 0
              ? "Handled Classes"
              : _currentIndex == 1 ? "Done Classes" : "Settings"),
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
            cardBuilder.instructorHandled(
                context, widget.db, widget.userId, _gridDelegate),
            cardBuilder.instructorDone(
                context, widget.db, widget.userId, _gridDelegate),
            StreamBuilder(
                stream: widget.db
                    .collection("accounts")
                    .where("uid", isEqualTo: widget.userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Waiting");
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
                                  textScaleFactor: 1.1)),
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
                            onTap: () {},
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
