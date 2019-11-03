import 'package:fluttergrab/core/models/counter.dart';
import 'package:fluttergrab/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>(
      builder: (context) => locator<Counter>(),
      child: Consumer<Counter>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text("Counter"),
          ),
          body: Container(
            child: Center(
              child: Text("${model.getCounter()}"),
            )
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                onPressed: model.increment,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                onPressed: model.decrement,
                tooltip: 'Increment',
                child: Icon(Icons.remove),
              )
            ],
          ),
        ),
      ),
    );
  }
}