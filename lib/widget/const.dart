import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:toast/toast.dart';

Color btnGreen = Colors.green;
Color btnOrange = Colors.deepOrange;
ThemeData themeScrollBar = ThemeData(
  highlightColor: btnOrange,
);
TextStyle boldWhite =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
RoundedRectangleBorder shape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
);
AppBar appBar(BuildContext context, String text) {
  return AppBar(
    leading: IconButton(
      splashRadius: 25,
      highlightColor: btnOrange,
      icon: Icon(LineAwesomeIcons.chevron_left),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    elevation: 0,
    centerTitle: true,
    title: Text(text),
  );
}

Divider listViewDivider = Divider(
  height: 0,
  indent: 500,
);
void buildToast(
  BuildContext context,
  String text,
) =>
    Toast.show(
      text,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.TOP,
    );
