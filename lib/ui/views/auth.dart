import 'package:flutter/material.dart';
import 'package:fluttergrab/core/viewmodels/login.dart';
import 'package:fluttergrab/core/viewmodels/register.dart';

class AuthView extends StatefulWidget {
  AuthView({Key key}) : super(key : key);
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: TabBar(
        labelColor: Theme.of(context).accentColor,
        indicatorColor: Theme.of(context).primaryColor,
        controller: _tabController,
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.person_pin),
            text: "Login",
          ),
          Tab(
            icon: Icon(Icons.note_add),
            text: "Register"
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          LoginViewModel(),
          RegisterViewModel()
        ],
      )
    );
  }
}