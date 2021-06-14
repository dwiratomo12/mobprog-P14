import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Item {
  String _id;
  String _name;
  TimeOfDay _time;

  Item(this._id, this._name);

  Item.app(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
  }

  String get id => _id;
  String get name => _name;

  Item.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['name'];
  }
}
