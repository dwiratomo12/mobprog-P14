import 'package:flutter/material.dart';

import 'font_style.dart';

void main() => runApp(AdminHome());

class AdminHome extends StatefulWidget {
  _AdminHome createState() => _AdminHome();
}

class _AdminHome extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 23.0, top: 150, right: 23.0, bottom: 0),
          padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('images/ic_payment.png'),
                    height: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 4.0),
                    child: Text("Be Productive", style: mainHeader),
                  ),
                  Text(
                    "Manage your activities by listing your schedule \nand live with happinness",
                    style: subHeader,
                    textAlign: TextAlign.center,
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
