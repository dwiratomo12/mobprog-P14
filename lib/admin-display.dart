import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp3/item.dart';

void main() => runApp(AdminDisplay());

class AdminDisplay extends StatefulWidget {
  _AdminDisplay createState() => _AdminDisplay();
}

class _AdminDisplay extends State<AdminDisplay> {
  //membuat file database di firebase
  final itemsReference = FirebaseDatabase.instance.reference().child('item');
  List<Item> items;
  StreamSubscription<Event> _onItemAddedSubscription;

  @override
  void initState() {
    super.initState();
    items = new List();
    _onItemAddedSubscription = itemsReference.onChildAdded.listen(_onItemAdded);
  }

  @override
  void dispose() {
    _onItemAddedSubscription.cancel();
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(items[position].name),
                          Text(items[position].price)
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.green),
                            onPressed: () {},
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteItem(context, items[position], position);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
