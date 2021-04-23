import 'dart:ui';

import 'package:KuraCek/Database/sqflite.dart';
import 'package:KuraCek/widget/admob.dart';
import 'package:KuraCek/widget/const.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'main.dart';

var savedKuralar = [];

class MyKuralar extends StatefulWidget {
  @override
  _MyKuralarState createState() => _MyKuralarState();
}

class _MyKuralarState extends State<MyKuralar> {
  final GlobalKey<ScaffoldState> _snackbarKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final TodoHelper _todoHelper = TodoHelper();
    return Scaffold(
      key: _snackbarKey,
      appBar: appBar(context, deviceLanguage["kuralarim"]),
      body: savedKuralar.length != 0
          ? Column(
              children: [
                Expanded(
                  child: Theme(
                    data: themeScrollBar,
                    child: Scrollbar(
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return TextButton(
                              onPressed: () {
                                splitsizString = savedKuralar[index].kuraList;
                                splitList = splitsizString.split(', ');
                                setState(() {
                                  for (var item in splitList) {
                                    if (item != '') addList.add(item);
                                  }
                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()),
                                    (Route<dynamic> route) => false);
                              },
                              child: ListTile(
                                leading: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(color: btnOrange),
                                ),
                                title: Text(
                                  savedKuralar[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(savedKuralar[index]
                                    .kuraList
                                    .substring(
                                        0,
                                        savedKuralar[index]
                                            .kuraList
                                            .lastIndexOf(','))),
                                trailing: IconButton(
                                  onPressed: () async {
                                    await delete(context, _todoHelper, index);
                                  },
                                  icon: Icon(
                                    LineAwesomeIcons.trash,
                                  ),
                                  splashRadius: 20,
                                  iconSize: 20,
                                  color: btnOrange,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => listViewDivider,
                          itemCount: savedKuralar.length),
                    ),
                  ),
                ),
                connectivityController == true
                    ? admobBanner(bannerTwo)
                    : Container()
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/empty.json'),
                  Text(
                    deviceLanguage["kayitliBirKuraYok"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
    );
  }

  delete(BuildContext context, TodoHelper _todoHelper, int index) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                title: Text(
                  deviceLanguage["kuralarimdanSil"],
                ),
                actions: [
                  TextButton(
                    style: bgBtnGreen,
                    onPressed: () async {
                      _todoHelper.deleteTask(savedKuralar[index].id);
                      List<TaskModel> list = await _todoHelper.getAllTask();
                      setState(() {
                        savedKuralar = list;
                      });
                      Navigator.pop(context);

                      buildToast(
                          context, deviceLanguage["kuralarimdanSilindi"]);
                    },
                    child: Text(
                      deviceLanguage["yes"],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    style: bgBtnOrange,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      deviceLanguage["no"],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ));
        });
  }
}
