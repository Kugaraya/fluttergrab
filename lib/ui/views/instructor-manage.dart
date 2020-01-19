import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergrab/core/services/auth-service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class InstructorManage extends StatefulWidget {
  InstructorManage(
      {Key key, this.db, this.userEmail, this.userId, this.auth, this.document})
      : super(key: key);

  final DocumentSnapshot document;
  final Firestore db;
  final String userEmail;
  final String userId;
  final BaseAuth auth;

  @override
  _InstructorManageState createState() => _InstructorManageState();
}

class _InstructorManageState extends State<InstructorManage> {
  PanelController _panelCtrl = PanelController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    CameraPosition _kLocation = CameraPosition(
      target: LatLng(widget.document["location"].latitude,
          widget.document["location"].longitude),
      zoom: 18.4746,
    );
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{
      MarkerId(widget.document.documentID): Marker(
          markerId: MarkerId(widget.document.documentID),
          position: LatLng(widget.document["location"].latitude,
              widget.document["location"].longitude),
          infoWindow: InfoWindow(
              title: widget.document["address"],
              snippet: widget.document["location"].latitude.toString() +
                  ", " +
                  widget.document["location"].longitude.toString()))
    };
    Widget mapLocation() {
      return Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              markers: Set<Marker>.of(markers.values),
              mapType: MapType.normal,
              initialCameraPosition: _kLocation,
              myLocationEnabled: true,
              compassEnabled: true,
              trafficEnabled: true,
              myLocationButtonEnabled: true,
              mapToolbarEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          SizedBox(height: 135.0)
        ],
      );
    }

    Widget instructor() {
      return ListTile(
        leading: Icon(Icons.person, size: 32),
        title: StreamBuilder(
          stream: widget.db
              .collection("accounts")
              .where("uid", isEqualTo: widget.document["instructor"])
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return Text(snapshot.data.documents[0]["name"]);
          },
        ),
        subtitle: StreamBuilder(
          stream: widget.db
              .collection("accounts")
              .where("uid", isEqualTo: widget.document["instructor"])
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return Text(snapshot.data.documents[0]["position"]);
          },
        ),
      );
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.document["subject"]),
        ),
        body: SlidingUpPanel(
          parallaxEnabled: true,
          parallaxOffset: 0.6,
          controller: _panelCtrl,
          minHeight: 60.0,
          body: mapLocation(),
          panel: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  _panelCtrl.isPanelOpen()
                      ? _panelCtrl.close()
                      : _panelCtrl.open();
                },
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                  leading: Icon(
                    Icons.arrow_drop_up,
                    size: 32.0,
                  ),
                  trailing: Icon(
                    Icons.arrow_drop_up,
                    size: 32.0,
                  ),
                  title: Text(
                    "Tap to Open/Close",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaleFactor: 1.3,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Divider(
                thickness: 1.2,
              ),
              instructor(),
              Divider(
                thickness: 1.2,
              ),
              ListTile(
                leading: Icon(Icons.local_library, size: 32),
                title: Text(widget.document["subject"]),
              ),
              ListTile(
                leading: Icon(Icons.library_books, size: 32),
                title: Text(widget.document["topic"]),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today, size: 32),
                title: Text(widget.document["schedule"].values.toList()[2]),
              ),
              ListTile(
                leading: Icon(Icons.timer, size: 32),
                title: Text(widget.document["schedule"].values.toList()[0] +
                    " - " +
                    widget.document["schedule"].values.toList()[1]),
              ),
              ListTile(
                leading: Icon(
                  Icons.attach_money,
                  size: 32,
                  color: widget.document["costs"] < 1
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                ),
                title: Text(widget.document["costs"] < 1
                    ? "Free"
                    : "Php " + widget.document["costs"].toString()),
              ),
              ListTile(
                onTap: () {
                  widget.document["students"].isEmpty
                      ? _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content:
                              Text("No enrolled student(s) in this class yet")))
                      : Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text("List of Students"),
                                ),
                                body: ListView.builder(
                                  itemCount: widget.document["students"].length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        child: Center(
                                            child:
                                                Text((index + 1).toString())),
                                      ),
                                      title: StreamBuilder(
                                        stream: widget.db
                                            .collection("accounts")
                                            .where("uid",
                                                isEqualTo:
                                                    widget.document["students"]
                                                        [index])
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData ||
                                              snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          return Text(snapshot.data.documents[0]
                                              ["name"]);
                                        },
                                      ),
                                      subtitle: StreamBuilder(
                                        stream: widget.db
                                            .collection("accounts")
                                            .where("uid",
                                                isEqualTo:
                                                    widget.document["students"]
                                                        [index])
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData ||
                                              snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          return Text(snapshot.data.documents[0]
                                              ["email"]);
                                        },
                                      ),
                                      trailing: Icon(Icons.chevron_right),
                                    );
                                  },
                                ),
                              )));
                },
                leading: Icon(Icons.people, size: 32),
                title: Text("List of Students"),
                trailing: Icon(Icons.chevron_right, size: 32),
              ),
              Divider(thickness: 1.2),
              widget.document["status"] == true
                  ? Center(
                      child: RaisedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await widget.db
                              .collection("classes")
                              .document(widget.document.documentID)
                              .updateData({"status": false});
                        },
                        color: Theme.of(context).primaryColor,
                        elevation: 5.0,
                        child: Text("Class Done"),
                      ),
                    )
                  : RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text("Class Evaluation"),
                                  ),
                                  body: ListView.builder(
                                    itemCount:
                                        widget.document["feedbacks"].length,
                                    itemBuilder: (context, index) {
                                      print("Index: " + index.toString());
                                      return ListTile(
                                          leading: CircleAvatar(
                                            radius: 20.0,
                                            foregroundColor: Colors.white,
                                            backgroundColor: widget.document[
                                                            "feedbacks"][index]
                                                        ["rating"] <
                                                    2
                                                ? Colors.red
                                                : widget.document["feedbacks"]
                                                                    [index]
                                                                ["rating"] >=
                                                            2 &&
                                                        widget.document[
                                                                    "feedbacks"]
                                                                [
                                                                index]["rating"] <=
                                                            3
                                                    ? Colors.orange
                                                    : Colors.green,
                                            child: Text(widget
                                                .document["feedbacks"][index]
                                                    ["rating"]
                                                .toString()),
                                          ),
                                          title: Text(
                                            widget.document["feedbacks"][index]
                                                    ["comment"]
                                                .toString(),
                                          ));
                                    },
                                  ),
                                )));
                      },
                      child: Text("See Evaluation/s"),
                    ),
              Divider(thickness: 1.2),
            ],
          )),
        ));
  }
}
