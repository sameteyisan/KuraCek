import 'dart:math';
import 'package:KuraCek/widget/admob.dart';
import 'package:KuraCek/widget/const.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, deviceLanguage["sonuclar"]),
      body: Column(
        children: [
          Expanded(
            child: Theme(
              data: themeScrollBar,
              child: Scrollbar(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // ignore: missing_required_param
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              '${index + 1}.  ' +
                                  '${selectedList[index]}'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.primaries[Random()
                                      .nextInt(Colors.primaries.length)],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => listViewDivider,
                    itemCount: selectedList.length),
              ),
            ),
          ),
          divider10,
          TextButton(
            style: bgBtnOrange,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              deviceLanguage["newKura"],
              style: boldWhite,
            ),
          ),
          divider10,
          connectivityController == true
              ? admobBanner(bannerThree)
              : Container()
        ],
      ),
    );
  }
}
