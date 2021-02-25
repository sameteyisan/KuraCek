import 'dart:ui';

import 'package:KuraCek/Database/sqflite.dart';
import 'package:KuraCek/widget/const.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'main.dart';

var savedKuralar = [];
InterstitialAd myKuralarReklam;

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
            ? Container(
                height: MediaQuery.of(context).size.height - 200,
                child: Column(
                  children: [
                    Expanded(
                      child: Theme(
                        data: themeScrollBar,
                        child: Scrollbar(
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return FlatButton(
                                  textColor: btnOrange,
                                  onPressed: () {
                                    splitsizString =
                                        savedKuralar[index].kuraList;
                                    splitList = splitsizString.split(', ');
                                    setState(() {
                                      for (var item in splitList) {
                                        if (item == '') {
                                          // ignore: unnecessary_statements
                                          null;
                                        } else {
                                          addList.add(item);
                                        }
                                      }
                                    });
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => MyApp()),
                                        (Route<dynamic> route) => false);
                                  },
                                  padding: EdgeInsets.all(0),
                                  child: ListTile(
                                    leading: Text((index + 1).toString()),
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
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 4.0,
                                                    sigmaY: 4.0,
                                                  ),
                                                  child: AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    title: Text(deviceLanguage[
                                                        "kuralarimdanSil"]),
                                                    actions: [
                                                      FlatButton(
                                                        color: btnGreen,
                                                        onPressed: () async {
                                                          _todoHelper
                                                              .deleteTask(
                                                                  savedKuralar[
                                                                          index]
                                                                      .id);
                                                          List<TaskModel> list =
                                                              await _todoHelper
                                                                  .getAllTask();
                                                          setState(() {
                                                            savedKuralar = list;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          myKuralarReklam
                                                            ..show()
                                                                .whenComplete(
                                                                    () {
                                                              buildToast(
                                                                  context,
                                                                  deviceLanguage[
                                                                      "kuralarimdanSilindi"]);
                                                            });
                                                        },
                                                        child: Text(
                                                            deviceLanguage[
                                                                "yes"]),
                                                      ),
                                                      FlatButton(
                                                        color: btnOrange,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            deviceLanguage[
                                                                "no"]),
                                                      ),
                                                    ],
                                                  ));
                                            });
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
                              separatorBuilder: (context, index) =>
                                  listViewDivider,
                              itemCount: savedKuralar.length),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Text(
                  deviceLanguage["kayitliBirKuraYok"],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 18),
                ),
              ));
  }
}
