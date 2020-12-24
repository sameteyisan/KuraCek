import 'package:KuraCek/sqflite.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'main.dart';

var savedKuralar = [];
InterstitialAd myKuralarReklam;

class MyKuralar extends StatefulWidget {
  final title;
  final kuralarimdamSil;
  final kuralarimdanSilindi;
  final yes;
  final no;
  final kayitliBirKuraYok;

  const MyKuralar(
      {Key key,
      this.title,
      this.kuralarimdamSil,
      this.kuralarimdanSilindi,
      this.yes,
      this.no,
      this.kayitliBirKuraYok})
      : super(key: key);

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
          title: Text(widget.title),
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
                                          return AlertDialog(
                                            title: Text(widget.kuralarimdamSil),
                                            actions: [
                                              FlatButton(
                                                color: Colors.green,
                                                onPressed: () async {
                                                  _todoHelper.deleteTask(
                                                      savedKuralar[index].id);
                                                  List<TaskModel> list =
                                                      await _todoHelper
                                                          .getAllTask();
                                                  setState(() {
                                                    savedKuralar = list;
                                                  });
                                                  Navigator.pop(context);
                                                  myKuralarReklam
                                                    ..show().whenComplete(() {
                                                      buildToast(widget
                                                          .kuralarimdanSilindi);
                                                    });
                                                },
                                                child: Text(widget.yes),
                                              ),
                                              FlatButton(
                                                color: Colors.deepOrange,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(widget.no),
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
                  widget.kayitliBirKuraYok,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 18),
                ),
              ));
  }

  void buildToast(String text) => Toast.show(
        text,
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
}
