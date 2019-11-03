import 'package:flutter/material.dart';
import 'package:fluttergrab/core/viewmodels/admin.dart';
import 'package:fluttergrab/core/viewmodels/instructor.dart';
import 'package:fluttergrab/core/viewmodels/student.dart';
import 'package:fluttergrab/ui/widgets/menu.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;

  @override
  void initState() { 
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,  
      drawer: buildDrawer(context),
      appBar: AppBar(
        title: Text("Home"),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).accentColor,
          tabs: <Widget>[
            Tab(text: "Student"),
            Tab(text: "Instructor"),
            Tab(text: "Admin"),
          ]
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          StudentViewModel(),
          InstructorViewModel(),
          AdminViewModel(),
        ],
      ),
    );
  }
}