import 'package:flutter/material.dart';

import 'admin-display.dart';
import 'admin-home.dart';
import 'admin-new.dart';

void main() => runApp(AdminPage());

class AdminPage extends StatefulWidget {
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage> {
  Widget mainWidget;

  void initState() {
    this._initial();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  void _initial() {
    mainWidget = AdminHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Welcome to My Application'),
          backgroundColor: Colors.lightBlueAccent),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: mainWidget,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Main Menu'),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  mainWidget = AdminHome();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.view_agenda),
              title: Text('Display Record'),
              onTap: () {
                setState(() {
                  mainWidget = AdminDisplay();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add New Record'),
              onTap: () {
                setState(() {
                  mainWidget = AdminNew();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Logout'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
    );
  }
}
