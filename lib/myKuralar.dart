import 'package:KuraCek/sqflite.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'main.dart';

var savedKuralar = [];
var myKuralarReklam;

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
        appBar: AppBar(
          leading: IconButton(
            splashRadius: 25,
            highlightColor: Colors.deepOrange,
            icon: Icon(LineAwesomeIcons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Kuralarım'),
        ),
        body: savedKuralar.length != 0
            ? Container(
                height: MediaQuery.of(context).size.height - 200,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return FlatButton(
                              textColor: Colors.deepOrange,
                              onPressed: () {
                                splitsizString = savedKuralar[index].kuraList;
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
                                title: Text(savedKuralar[index].name),
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
                                          return AlertDialog(
                                            title: Text(
                                                'Bu Kurayı Silmek İstediğinize Emin Misiniz ?'),
                                            actions: [
                                              FlatButton(
                                                color: Colors.green,
                                                onPressed: () async {
                                                  myKuralarReklam..show();
                                                  _todoHelper.deleteTask(
                                                      savedKuralar[index].id);
                                                  List<TaskModel> list =
                                                      await _todoHelper
                                                          .getAllTask();
                                                  setState(() {
                                                    savedKuralar = list;
                                                  });
                                                  Navigator.pop(context);
                                                  Flushbar(
                                                    boxShadows: [
                                                      BoxShadow(
                                                          color:
                                                              Colors.deepOrange,
                                                          offset:
                                                              Offset(0.0, 2.0),
                                                          blurRadius: 3.0)
                                                    ],
                                                    backgroundGradient:
                                                        LinearGradient(colors: [
                                                      Colors.deepOrange,
                                                      Colors.deepOrange[200]
                                                    ]),
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                    title: 'İşlem Başarılı',
                                                    message: 'Kura silindi.',
                                                    duration:
                                                        Duration(seconds: 1),
                                                  )..show(context);
                                                },
                                                child: Text('Evet'),
                                              ),
                                              FlatButton(
                                                color: Colors.deepOrange,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Hayır'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.delete),
                                  splashRadius: 20,
                                  iconSize: 20,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                height: 0,
                                indent: 500,
                              ),
                          itemCount: savedKuralar.length),
                    ),
                  ],
                ),
              )
            : Center(
                child: Text(
                  'Kayıtlı Bir Kura Bulunmamaktadır.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 18),
                ),
              ));
  }
}
