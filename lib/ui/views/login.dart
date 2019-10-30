// import 'package:fluttergrab/locator.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

enum UserType { student, instructor, admin }

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _emailCtrl;
  TextEditingController _passCtrl;
  bool _isObscure = false;
  UserType _user = UserType.student;

  @override
  Widget build(BuildContext context) {
    final _logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset("assets/teacher.png"),
      ),
    );

    final _emailField = TextFormField(
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
        labelText: "E-mail Address",
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        focusColor: Theme.of(context).primaryColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final _passwordField = TextFormField(
      controller: _passCtrl,
      obscureText: _isObscure ? true : false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.lock : Icons.lock_open),
          color: Theme.of(context).primaryColor,
          onPressed: () => setState(() {_isObscure = _isObscure ? false : true;}),
        ),
        labelText: "Password",
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        focusColor: Theme.of(context).primaryColor,
      ),
    );

    final _userType = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget> [
              Radio(
                groupValue: _user,
                onChanged: (value) => setState(() => _user = value),
                value: UserType.student,
                activeColor: Theme.of(context).primaryColor,
              ),
              Text("Student")
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget> [
              Radio(
                groupValue: _user,
                onChanged: (value) => setState(() => _user = value),
                value: UserType.instructor,
                activeColor: Theme.of(context).primaryColor,
              ),
              Text("Instructor")
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 16.0),
          child: Row(
            children: <Widget> [
              Radio(
                groupValue: _user,
                onChanged: (value) => setState(() => _user = value),
                value: UserType.admin,
                activeColor: Theme.of(context).primaryColor,
              ),
              Text("Admin")
            ],
          ),
        ),
      ],
    );

    final _loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {},
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final _registerLabel = FlatButton(
      child: Text(
        "Don't have an account?",
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () => Navigator.of(context).pushNamed('/register'),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              _logo,
              SizedBox(height: 48.0),
              _emailField,
              SizedBox(height: 8.0),
              _passwordField,
              SizedBox(height: 8.0),
              _userType,
              SizedBox(height: 24.0),
              _loginButton,
              SizedBox(height: 48.0),
              _registerLabel
            ],
          ),
        )
      ),
    );
  }
}