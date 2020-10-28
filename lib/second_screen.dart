import 'dart:math';
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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Sonuçlar'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 200,
        child: Column(
          children: [
            Expanded(
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
                                Random().nextInt(Colors.primaries.length)]),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        height: 0,
                        indent: 500,
                      ),
                  itemCount: selectedList.length),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  FlatButton(
                    color: Colors.deepOrange,
                    onPressed: () {
                      secondReklam..show();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Yeni Kura Çek',
                      style: TextStyle(color: Colors.white),
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
