import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'chillzone_favourite.dart';
import 'chillzone_grid.dart';

class ChillZone extends StatefulWidget {
  @override
  _ChillZoneState createState() => _ChillZoneState();
}

class _ChillZoneState extends State<ChillZone>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text(getTranslated(context, "chill_zone")),
        backgroundColor: Colors.teal,
//        actions: <Widget>[
//        RaisedButton.icon(onPressed: null, icon: Icon(Icons.mood), label: Text("اثترح"))
//        ],
        bottom: TabBar(
          controller: controller,
          indicatorWeight: 5.0,
          indicatorColor: Colors.deepPurple,
          tabs: <Widget>[
            Tab(icon: new Icon(Icons.wb_sunny)),
            Tab(icon: new Icon(Icons.favorite)),


          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[ ChillGrid(),ChillFavourite()],
      ),
    );
  }
}
