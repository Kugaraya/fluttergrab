import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';

class Evaluate extends StatefulWidget {
  @override
  _EvaluateState createState() => _EvaluateState();
}

class _EvaluateState extends State<Evaluate> {
  double _val;

  @override
  void initState() {
    super.initState();
    _val = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Evaluate this class")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: 150.0,
                  child: Card(
                    elevation: 5.0,
                    child: TextFormField(
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          labelText: "Comments/Suggestions",
                          hintText: "Optional"),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                FluidSlider(
                  onChanged: (value) {
                    setState(() {
                      _val = value > 4.85 ? value.roundToDouble() : value;
                    });
                    print(_val);
                  },
                  value: _val,
                  min: 1.0,
                  max: 5.0,
                  sliderColor: _val < 2
                      ? Colors.red
                      : _val >= 2 && _val <= 4 ? Colors.orange : Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
