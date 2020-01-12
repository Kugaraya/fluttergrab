import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergrab/core/services/auth-service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StudentManage extends StatefulWidget {
  StudentManage(
      {Key key, this.db, this.userEmail, this.userId, this.auth, this.document})
      : super(key: key);

  final DocumentSnapshot document;
  final Firestore db;
  final String userEmail;
  final String userId;
  final BaseAuth auth;

  @override
  _StudentManageState createState() => _StudentManageState();
}

class _StudentManageState extends State<StudentManage> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    CameraPosition _kLocation = CameraPosition(
      target: LatLng(widget.document["location"].latitude,
          widget.document["location"].longitude),
      zoom: 14.4746,
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
      return GoogleMap(
        markers: Set<Marker>.of(markers.values),
        mapType: MapType.hybrid,
        initialCameraPosition: _kLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
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
              return Text("Waiting");
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
              return Text("Waiting");
            }

            return Text(snapshot.data.documents[0]["position"]);
          },
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.document["subject"]),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(height: 200.0, child: mapLocation()),
            Divider(
              thickness: 1.5,
            ),
            instructor(),
            Divider(
              thickness: 1.5,
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
            Divider(thickness: 1.5),
            ListTile(
              leading: Icon(Icons.people, size: 32),
              title: Text("List of Students"),
              trailing: Icon(Icons.chevron_right, size: 32),
            ),
            Divider(thickness: 1.5),
            widget.document["status"] == true &&
                    widget.document["students"].contains(widget.userId) == false
                ? Center(
                    child: RaisedButton(
                      onPressed: () async {
                        await widget.db
                            .collection("classes")
                            .document(widget.document.documentID)
                            .updateData({
                          "students": FieldValue.arrayUnion([widget.userId])
                        });
                        Navigator.of(context).pop();
                      },
                      color: Theme.of(context).primaryColor,
                      elevation: 5.0,
                      child: Text("Enroll in this Class"),
                    ),
                  )
                : RaisedButton(
                    onPressed: () {},
                    child: Text("Already enrolled"),
                  )
          ],
        )));
  }
}
