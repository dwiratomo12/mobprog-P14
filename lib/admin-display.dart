import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp3/item.dart';

void main() => runApp(AdminDisplay());

class AdminDisplay extends StatefulWidget {
  _AdminDisplay createState() => _AdminDisplay();
}

class _AdminDisplay extends State<AdminDisplay> {
  final _formKey = GlobalKey<FormState>();
  //membuat file database di firebase
  final itemsReference = FirebaseDatabase.instance.reference().child('item');
  List<Item> items;
  List<Item> itemsForDisplay;
  StreamSubscription<Event> _onItemAddedSubscription;
  StreamSubscription<Event> _onItemChangedSubscription;

  List<Item> item;
  TextEditingController _name;
  String _txtname;

  @override
  void initState() {
    super.initState();
    items = [];
    itemsForDisplay = items;
    _onItemAddedSubscription = itemsReference.onChildAdded.listen(_onItemAdded);
    _onItemChangedSubscription =
        itemsReference.onChildChanged.listen(_onItemUpdated);
  }

  @override
  void dispose() {
    _onItemAddedSubscription.cancel();
    _onItemChangedSubscription.cancel();
    super.dispose();
  }

  void _onItemAdded(Event event) {
    setState(() {
      items.add(new Item.fromSnapshot(event.snapshot));
    });
  }

  void _deleteItem(BuildContext context, Item item, int position) async {
    await itemsReference.child(item.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _onItemUpdated(Event event) {
    var oldItemValue =
        items.singleWhere((item) => item.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldItemValue)] =
          new Item.fromSnapshot(event.snapshot);
    });
  }

  void _saveItem(String value1, Item item, int position) {
    itemsReference.child(item.id).set({'name': value1}).then((_) {
      Navigator.pop(context);
    });
    itemsReference.onChildChanged.listen(_onItemUpdated);
  }

  void _editItem(String name, Item item, int position) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text('Update Record'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      onSaved: (val) => setState(() => _txtname = val),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('save'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      _saveItem(_txtname, items[position], position);
                    }
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: itemsForDisplay.length + 1,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return position == 0 ? _searchBar() : _listItem(position - 1);
          }),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search...'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            itemsForDisplay = items.where((item) {
              var itemName = item.name.toLowerCase();
              return itemName.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(position) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(itemsForDisplay[position].name),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          _editItem(itemsForDisplay[position].name,
                              itemsForDisplay[position], position);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteItem(
                              context, itemsForDisplay[position], position);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
