import 'dart:math';
import 'package:KuraCek/widget/const.dart';
import 'package:flutter/material.dart';
import 'main.dart';

var secondReklam;

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, deviceLanguage["sonuclar"]),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
        child: Column(
          children: [
            Expanded(
              child: Theme(
                data: themeScrollBar,
                child: Scrollbar(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // ignore: missing_required_param
                        return FlatButton(
                          child: Text(
                            '${index + 1}.  ' +
                                '${selectedList[index]}'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)],
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => listViewDivider,
                      itemCount: selectedList.length),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    color: btnOrange,
                    onPressed: () {
                      secondReklam..show();
                      Navigator.pop(context);
                    },
                    child: Text(
                      deviceLanguage["newKura"],
                      style: boldWhite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
