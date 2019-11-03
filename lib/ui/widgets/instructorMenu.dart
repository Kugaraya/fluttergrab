import 'package:flutter/material.dart';

instructorDrawer(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(left: 16.0, right: 40),
    decoration: BoxDecoration(
      color: Colors.amber[900],
      boxShadow: [BoxShadow(color: Colors.black45)]
    ),
    width: 300.0,
    height: double.maxFinite,
    child: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 24.0),
            Text(
              "Instructor Menu",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            SizedBox(height: 40.0),
            _buildRow(Icons.people, "Subjects"),
            _buildDivider(),
          ],
        ),
      ),
    ),
  );
}

Divider _buildDivider() {
return Divider(
  color: Colors.amber[200],
);
}

Widget _buildRow(IconData icon, String title) {
final TextStyle tStyle = TextStyle(color: Colors.amber[200], fontSize: 16.0);

return FlatButton(
  onPressed: () {},
  padding: EdgeInsets.symmetric(vertical: 8.0),
  child: Row(children: [
    Icon(icon, color: Colors.amber[200]),
    SizedBox(width: 10.0),
    Text(
      title,
      style: tStyle,
    ),
  ]),
);
}