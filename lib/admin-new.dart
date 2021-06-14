import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void main() => runApp(AdminNew());

class AdminNew extends StatefulWidget {
  _AdminNew createState() => _AdminNew();
}

class _AdminNew extends State<AdminNew> {
  final _formKey = GlobalKey<FormState>();
  String _itemName, _itemPrice;
  TimeOfDay selectedTime = TimeOfDay.now();

  //membuat file database di firebase
  final notesReference = FirebaseDatabase.instance.reference().child('item');

  void _addItem() {
    var msg = 'Data has been added';
    notesReference.push().set({
      'name': _itemName,
      // 'price': _itemPrice,
    }).then((_) {
      print('Error data');
    });
    Toast.show(msg, context);
  }

  Widget _header() {
    return Container(
      child: Text(
        'Add New List',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<Null> _selectedTime(BuildContext context) async {
    final TimeOfDay picked_time = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (picked_time != null && picked_time != selectedTime)
      setState(() {
        selectedTime = picked_time;
      });
  }

  Widget _item() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: 'To Do List',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.lightBlueAccent),
            )),
        // ignore: missing_return
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter To Do List';
          }
        },
        onSaved: (val) => setState(() => _itemName = val),
      ),
    );
  }

  // Widget ItemPrice() {
  //   return Container(
  //     child: TextFormField(
  //       keyboardType: TextInputType.emailAddress,
  //       decoration: InputDecoration(
  //           labelText: 'Item Price',
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(15.0),
  //             borderSide: BorderSide(color: Colors.lightBlueAccent),
  //           )),
  //       validator: (value) {
  //         if (value.isEmpty) {
  //           return 'Enter item Price';
  //         }
  //       },
  //       onSaved: (val) => setState(() => _itemPrice = val),
  //     ),
  //   );
  // }

  Widget _itemTimer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "${selectedTime.format(context)}",
                style: TextStyle(
                  fontSize: 40,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = Colors.blue[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                  primary: Color(0XFF2C814E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  _selectedTime(context);
                },
                child: Text(
                  'Selected Time',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: MediaQuery.of(context).size.height / 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonSave() {
    return Container(
      height: 1.4 * (MediaQuery.of(context).size.height / 20),
      width: 5 * (MediaQuery.of(context).size.width / 10),
      margin: EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          primary: Color(0XFF2C814E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _addItem();
          }
        },
        child: Text(
          'Save',
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: MediaQuery.of(context).size.height / 40),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              _header(),
              SizedBox(
                height: 10,
              ),
              _item(),
              SizedBox(
                height: 10,
              ),
              // ItemPrice(),
              _itemTimer(),
              SizedBox(
                height: 20,
              ),
              _buttonSave(),
            ],
          ),
        ),
      ],
    );
  }
}
