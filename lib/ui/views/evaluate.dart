import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:fluttergrab/core/services/auth-service.dart';

class Evaluate extends StatefulWidget {
  Evaluate(
      {Key key, this.document, this.db, this.userEmail, this.userId, this.auth})
      : super(key: key);

  final DocumentSnapshot document;
  final Firestore db;
  final String userEmail;
  final String userId;
  final BaseAuth auth;

  @override
  _EvaluateState createState() => _EvaluateState();
}

class _EvaluateState extends State<Evaluate> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _comment = "";
  bool _isLoading;
  int _rating;
  double _val;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await widget.db
            .collection("classes")
            .document(widget.document.documentID)
            .updateData({
          "evaluate": FieldValue.arrayUnion([widget.userId]),
          "feedbacks": FieldValue.arrayUnion([
            {"comment": _comment, "rating": _rating}
          ])
        });

        setState(() {
          _isLoading = false;
        });

        _formKey.currentState.reset();
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Evaluation sent")));
        Future.delayed(Duration(seconds: 1));
        Navigator.pop(context);
        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _val = 1;
    _rating = 1;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Evaluate this class")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 150.0,
                    child: Card(
                      elevation: 5.0,
                      child: TextFormField(
                        enabled: _isLoading ? false : true,
                        onChanged: (text) {
                          setState(() {
                            _comment = text;
                          });
                        },
                        onEditingComplete: () {
                          print(_comment);
                        },
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            labelText: "Add Comments/Suggestions",
                            hintText: "Optional"),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  FluidSlider(
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _val =
                                  value > 4.85 ? value.roundToDouble() : value;
                            });
                          },
                    onChangeEnd: (value) {
                      setState(() {
                        _rating = value.floor();
                      });
                      print(_rating);
                    },
                    value: _val,
                    min: 1.0,
                    max: 5.0,
                    sliderColor: _val < 2
                        ? Colors.red
                        : _val >= 2 && _val <= 4 ? Colors.orange : Colors.green,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          onPressed: validateAndSubmit,
                          elevation: 5.0,
                          child: Text("Submit"),
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
