import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergrab/core/services/auth-service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InstructorAdd extends StatefulWidget {
  InstructorAdd({Key key, this.db, this.userEmail, this.userId, this.auth})
      : super(key: key);

  final Firestore db;
  final String userEmail;
  final String userId;
  final BaseAuth auth;

  @override
  _InstructorAddState createState() => _InstructorAddState();
}

class _InstructorAddState extends State<InstructorAdd> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LocationResult _pickedLocation;
  String _address, _topic, _subject, _days, _timeStart, _timeEnd;
  // ignore_for_file: unused_field
  String _lat, _lng, _cost = "";
  TextEditingController _lngCtrl, _latCtrl;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _pickedLocation = LocationResult(address: "test", latLng: LatLng(0.0, 0.0));
  }

  @override
  Widget build(BuildContext context) {
    bool validateAndSave() {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    void validateAndSubmit() async {
      if (validateAndSave()) {
        setState(() {
          _isLoading = true;
        });
        try {
          widget.db.collection("classes").add({
            "address": _address,
            "instructor": widget.userId,
            "location": GeoPoint(_pickedLocation.latLng.latitude,
                _pickedLocation.latLng.longitude),
            "schedule": {
              "days": _days,
              "time-end": _timeEnd,
              "time-start": _timeStart
            },
            "feedbacks": [],
            "evaluate": [],
            "costs": _cost.isEmpty ? 0.0 : _cost,
            "status": true,
            "students": [],
            "subject": _subject,
            "topic": _topic
          });
          setState(() {
            _isLoading = false;
          });

          _formKey.currentState.reset();
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Class $_subject is opened")));
          Navigator.of(context).pop();
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
            _formKey.currentState.reset();
          });
        }
      }
    }

    Widget showPrimaryButton() {
      if (_isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Padding(
          padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
          child: SizedBox(
            height: 40.0,
            child: RaisedButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Theme.of(context).primaryColor,
              child: Text("Open Class Tutorial",
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: validateAndSubmit,
            ),
          ));
    }

    Widget timeEndInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Time End (9:00PM)',
              icon: Icon(
                Icons.timer_off,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Topic can\'t be empty' : null,
          onSaved: (value) => _timeEnd = value.trim(),
        ),
      );
    }

    Widget timeStartInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Time Start (9:00AM)',
              icon: Icon(
                Icons.timer,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Time Start can\'t be empty' : null,
          onSaved: (value) => _timeStart = value.trim(),
        ),
      );
    }

    Widget costInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          autofocus: false,
          decoration: InputDecoration(
              prefixText: 'Php ',
              hintText: 'Leave blank/0.0 if free',
              labelText: 'Cost',
              icon: Icon(
                Icons.monetization_on,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Cost can\'t be empty' : null,
          onSaved: (value) => _cost = value.trim(),
        ),
      );
    }

    Widget daysInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'MWF/TTH',
              labelText: 'Days',
              icon: Icon(
                Icons.calendar_today,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Days can\'t be empty' : null,
          onSaved: (value) => _days = value.trim(),
        ),
      );
    }

    Widget topicInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Maps and Arrays',
              labelText: 'Topic',
              icon: Icon(
                Icons.library_books,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Topic can\'t be empty' : null,
          onSaved: (value) => _topic = value.trim(),
        ),
      );
    }

    Widget subjectInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'MATH1',
              labelText: 'Subject',
              icon: Icon(
                Icons.local_library,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Subject can\'t be empty' : null,
          onSaved: (value) => _subject = value.trim(),
        ),
      );
    }

    Widget showAddressInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Bldg Name/Actual Address',
              labelText: 'Address',
              icon: Icon(
                Icons.location_city,
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.location_searching),
                onPressed: () async {
                  LocationResult result = await showLocationPicker(
                    context,
                    "AIzaSyCClvmCP3iR5NfuMRDTj-9NEvnOHqU6TII",
                    automaticallyAnimateToCurrentLocation: true,
                    myLocationButtonEnabled: true,
                    layersButtonEnabled: true,
                  );
                  if (result != null) {
                    setState(() {
                      _pickedLocation = result;
                      _lat = _pickedLocation.latLng.latitude.toString();
                      _lng = _pickedLocation.latLng.longitude.toString();
                      Fluttertoast.showToast(
                          msg: "$_lat, $_lng",
                          backgroundColor: Colors.black38,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 12.0,
                          textColor: Colors.white,
                          timeInSecForIos: 1,
                          toastLength: Toast.LENGTH_SHORT);
                    });
                  }
                },
              )),
          onChanged: (value) {
            setState(() {});
          },
          validator: (value) =>
              value.isEmpty ? 'Address can\'t be empty' : null,
          onSaved: (value) => _address = value.trim(),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Class'),
      ),
      body: Builder(builder: (context) {
        print(_pickedLocation);
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    subjectInput(),
                    topicInput(),
                    daysInput(),
                    costInput(),
                    timeStartInput(),
                    timeEndInput(),
                    showAddressInput(),
                    showPrimaryButton()
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
