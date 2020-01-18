import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergrab/core/services/auth-service.dart';

class UpdateView extends StatefulWidget {
  final Firestore db;
  final String userEmail;
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final DocumentSnapshot document;

  const UpdateView(
      {Key key,
      this.db,
      this.userEmail,
      this.userId,
      this.auth,
      this.logoutCallback,
      this.document})
      : super(key: key);
  @override
  _UpdateViewState createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading;
  String _name, _course, _year;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
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
          print(widget.document);
          await widget.db
              .collection("accounts")
              .document(widget.document.documentID)
              .updateData({"name": _name, "course": _course, "year": _year});
          setState(() {
            _isLoading = false;
          });

          _formKey.currentState.reset();
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

    Widget nameInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              labelText: "Name",
              hintText: "[FirstName] [MiddleName/Initial] [LastName]",
              icon: Icon(
                Icons.person,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
          onSaved: (value) => _name = value.trim(),
        ),
      );
    }

    Widget courseInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              labelText: "Course/Department",
              hintText: "ex. BS in Information Technology",
              icon: Icon(
                Icons.library_books,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Course can\'t be empty' : null,
          onSaved: (value) => _course = value.trim(),
        ),
      );
    }

    Widget yearInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              labelText: "Year",
              hintText: "ex. 4th Year",
              icon: Icon(
                Icons.calendar_today,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Year can\'t be empty' : null,
          onSaved: (value) => _year = value.trim(),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Account Update"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  nameInput(),
                  courseInput(),
                  yearInput(),
                  Divider(),
                  Center(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            onPressed: validateAndSubmit,
                            color: Theme.of(context).primaryColor,
                            child: Text("Update"),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
