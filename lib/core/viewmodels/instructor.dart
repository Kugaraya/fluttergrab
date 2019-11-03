import 'package:flutter/material.dart';
import 'package:fluttergrab/ui/widgets/instructorMenu.dart';

class InstructorViewModel extends StatefulWidget {
  @override
  _InstructorViewModelState createState() => _InstructorViewModelState();
}

class _InstructorViewModelState extends State<InstructorViewModel> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  SliverGridDelegateWithFixedCrossAxisCount _gridDelegate;
  TabController _tabController;
  
  @override
  bool get wantKeepAlive => true;

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
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: TabBar(
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).accentColor,
        controller: _tabController,
        tabs: <Widget>[
          Tab(text: "Ongoing"),
          Tab(text: "Done/Ended"),
        ],
      ),
      endDrawer: instructorDrawer(context),
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
                        title: Center(child: Text("Ongoing Subject", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold))),
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