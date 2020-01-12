import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergrab/core/services/auth-service.dart';
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
  LocationResult _pickedLocation;
  String _address, _topic, _subject, _days, _timeStart, _timeEnd;
  // ignore_for_file: unused_field
  String _lat, _lng;
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
            "status": true,
            "students": [],
            "subject": _subject,
            "topic": _topic
          });
          setState(() {
            _isLoading = false;
          });

          _formKey.currentState.reset();
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

    Widget daysInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Days (MWF, TTH)',
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
              hintText: 'Topic',
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
              hintText: 'Subject',
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
              hintText: 'Address',
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
                  print("result = $result");
                  if (result != null) {
                    setState(() {
                      _pickedLocation = result;
                      _latCtrl.text =
                          _pickedLocation.latLng.latitude.toString();
                      _lngCtrl.text =
                          _pickedLocation.latLng.longitude.toString();
                    });
                  }
                },
              )),
          validator: (value) =>
              value.isEmpty ? 'Address can\'t be empty' : null,
          onSaved: (value) => _address = value.trim(),
        ),
      );
    }

    Widget lat(double lat) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          controller: _latCtrl,
          enabled: false,
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          readOnly: true,
          onSaved: (value) => _lat = value.trim(),
          initialValue: lat.toString(),
        ),
      );
    }

    Widget lng(double lng) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          controller: _lngCtrl,
          enabled: false,
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          readOnly: true,
          onSaved: (value) => _lng = value.trim(),
          initialValue: lng.toString(),
        ),
      );
    }

    return Scaffold(
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
                    timeStartInput(),
                    timeEndInput(),
                    showAddressInput(),
                    lat(_pickedLocation.latLng.latitude != null
                        ? _pickedLocation.latLng.latitude
                        : null),
                    lng(_pickedLocation.latLng.longitude != null
                        ? _pickedLocation.latLng.longitude
                        : null),
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
