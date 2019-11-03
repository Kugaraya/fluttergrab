import 'package:flutter/material.dart';

class StudentViewModel extends StatefulWidget {
  @override
  _StudentViewModelState createState() => _StudentViewModelState();
}

class _StudentViewModelState extends State<StudentViewModel> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  SliverGridDelegateWithFixedCrossAxisCount _gridDelegate;
  TabController _tabController;

  @override
  void initState() { 
    super.initState();
    _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);
    _tabController = TabController(vsync: this, length: 2);  
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
      appBar: TabBar(
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).accentColor,
        controller: _tabController,
        tabs: <Widget>[
          Tab(text: "Enrolled"),
          Tab(text: "Done/Ended"),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {},
            ),
            body: GridView(
              gridDelegate: _gridDelegate,
              children: <Widget>[
                for(int i=0; i<10; i++)
                Card(
                  child: InkWell(
                    onTap: () {},
                    child: GridTile(
                      header: GridTileBar(
                        title: Center(child: Text("Enrolled Subject", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold))),
                        trailing: Icon(Icons.star_border, color: Colors.black),
                      ),
                      child: Center(
                        child: Text("Subject description"),
                      ),
                      footer: Center(child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                        child: Text("Schedule/Instructor")
                      )),
                    ),
                  ),
                )
              ],
            ),
          ),
          GridView(
            gridDelegate: _gridDelegate,
            children: <Widget>[
              for(int i=0; i<10; i++)
              Card(
                child: InkWell(
                  onTap: () {},
                  child: GridTile(
                    header: GridTileBar(
                      title: Center(child: Text("Done Subject", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold))),
                      trailing: Icon(Icons.star_border, color: Colors.black),
                    ),
                    child: Center(
                      child: Text("Subject description"),
                    ),
                    footer: Center(child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      child: Text("Schedule/Instructor")
                    )),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}