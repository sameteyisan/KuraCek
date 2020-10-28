import 'dart:math';

import 'package:KuraCek/myKuralar.dart';
import 'package:KuraCek/second_screen.dart';
import 'package:KuraCek/sqflite.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

var splitsizString = '';
var splitList = [];
var addList = [];
var selectedList = [];
var _random = Random();
var count = 0;
var digerCount = 0;
var listeler = '';
List<TaskModel> tumHsepsi = [];
TaskModel gonderilen;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kura Çek',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// ignore: missing_return
Future<bool> _onBackPressed(BuildContext context) {
  FocusScope.of(context).unfocus();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    nonPersonalizedAds: true,
  );
  InterstitialAd myInterstitial;
  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      targetingInfo: targetingInfo,
      adUnitId: 'ca-app-pub-4589290119610129/5977252855',
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial..load();
        } else if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  void showInterstitialAd() {
    myInterstitial..show();
  }

  void showRandomInterstitialAd() {
    Random r = new Random();
    bool value = r.nextBool();

    if (value == true) {
      myInterstitial..show();
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-4589290119610129~8880007547');
    myBanner = buildBannerAd()..load();
    myInterstitial = buildInterstitialAd()..load();
  }

  @override
  void dispose() {
    myInterstitial.dispose();
    myBanner.dispose();
    super.dispose();
  }

  BannerAd myBanner;
  BannerAd buildBannerAd() {
    return BannerAd(
        targetingInfo: targetingInfo,
        adUnitId: 'ca-app-pub-4589290119610129/9586923860',
        size: AdSize.largeBanner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }

  TextEditingController inputController = TextEditingController();
  TextEditingController kisiInputController = TextEditingController();
  TextEditingController inputKuraAdiController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final TodoHelper _todoHelper = TodoHelper();
    var reklam = buildInterstitialAd()..load();
    secondReklam = reklam;
    myKuralarReklam = reklam;
    setState(() {
      addList = addList;
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Kura Çek'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 240,
              child: GestureDetector(
                onTap: () {
                  _onBackPressed(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextField(
                        controller: inputController,
                        maxLength: 12,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              splashRadius: 25,
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  inputController.clear();
                                });
                              },
                            ),
                            hintText: 'Aday',
                            labelText: 'Bir Aday Gir',
                            icon: Icon(Icons.add)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            color: Colors.green,
                            onPressed: () {
                              if (inputController.text.length == 0) {
                                flushbar(context, 'Aday girilmedi.',
                                    'Bir aday girin.');
                              } else {
                                if (addList.contains(inputController.text)) {
                                  flushbar(context, 'Bu aday zaten var',
                                      'Başka bir aday girin.');
                                } else if (inputController.text.contains(',')) {
                                  flushbar(context, ', koyulamaz.',
                                      "Aday adında ',' olamaz. ");
                                } else {
                                  addList.add(inputController.text);
                                  setState(() {
                                    addList = addList;
                                  });
                                }
                              }
                              inputController.clear();
                            },
                            child: Text(
                              'Ekle',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          FlatButton(
                            color: Colors.red,
                            onPressed: () {
                              reklam..show();
                              setState(() {
                                addList.clear();
                                flushbar(context, 'İşlem Başarılı',
                                    'Adaylar silindi.');
                              });
                            },
                            child: Text(
                              'Her Şeyi Sil',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 20,
                        indent: 500.0,
                      ),
                      addList.length == 0
                          ? Text(
                              'Henüz Eklenen Bir Aday Yok',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'Adaylar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // ignore: missing_required_param
                              return FlatButton(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${index + 1}.  ' +
                                        '${addList[index]}'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.primaries[Random()
                                            .nextInt(Colors.primaries.length)]),
                                  ),
                                  IconButton(
                                    highlightColor: Colors.deepOrange,
                                    splashRadius: 20,
                                    iconSize: 20,
                                    color: Colors.black,
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        addList.remove(addList[index]);
                                      });
                                      flushbar(context, 'İşlem Başarılı',
                                          'Aday silindi.');
                                    },
                                  )
                                ],
                              ));
                            },
                            separatorBuilder: (context, index) => Divider(
                                  height: 0,
                                  indent: 500,
                                ),
                            itemCount: addList.length),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            addList.length == 0
                ? FlatButton(
                    color: Colors.deepOrange,
                    onPressed: () async {
                      reklam..show();
                      List<TaskModel> list = await _todoHelper.getAllTask();
                      savedKuralar = list;
                      print(list.length);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyKuralar()),
                      );
                    },
                    child: Text(
                      'Kuralarımı Göster',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        color: Colors.deepOrange,
                        onPressed: () async {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Bir Kura Adı Belirleyiniz.',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  content: Container(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: inputKuraAdiController,
                                          maxLength: 12,
                                          onChanged: (value) {},
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            labelText: 'Kura Adı',
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.clear),
                                              onPressed: () {
                                                inputKuraAdiController.clear();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                      color: Colors.green,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        inputKuraAdiController.clear();
                                      },
                                      child: Text('İptal'),
                                    ),
                                    FlatButton(
                                      color: Colors.deepOrange,
                                      onPressed: () {
                                        if (inputKuraAdiController
                                                .text.length ==
                                            0) {
                                          print('Bir Ad Belirle');
                                        } else {
                                          for (var i = 0;
                                              i < addList.length;
                                              i++) {
                                            setState(() {
                                              listeler += addList[i] + ', ';
                                            });
                                          }
                                          print(listeler);
                                          gonderilen = TaskModel(
                                              kuraList: listeler,
                                              name:
                                                  inputKuraAdiController.text);
                                          _todoHelper.insertTask(gonderilen);
                                          setState(() {
                                            listeler = '';
                                            addList.clear();
                                            Navigator.pop(context);
                                            inputKuraAdiController.clear();
                                            flushbar(context, 'İşlem Başarılı',
                                                'Kura kaydedildi.');
                                            reklam..show();
                                          });
                                        }
                                      },
                                      child: Text('Belirle'),
                                    )
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'Kurayı Kaydet',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      FlatButton(
                        color: Colors.deepOrange,
                        child: Text(
                          'Kura Çekmeyi Başlat',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (addList.length == 0) {
                            flushbar(context, 'Hiçbir aday girilmedi.',
                                'Bir aday girin.');
                          } else {
                            kisiInputController.clear();
                            return showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${addList.length} adaydan kaç aday seçilecek ?',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    content: Container(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          TextField(
                                            maxLength: 3,
                                            onChanged: (value) {},
                                            controller: kisiInputController,
                                            keyboardType: TextInputType.number,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Aday Sayısını Giriniz',
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.clear),
                                                onPressed: () {
                                                  kisiInputController.clear();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        color: Colors.green,
                                        onPressed: () {
                                          Navigator.pop(context);
                                          kisiInputController.clear();
                                        },
                                        child: Text('İptal'),
                                      ),
                                      FlatButton(
                                        color: Colors.deepOrange,
                                        onPressed: () {
                                          if (int.parse(
                                                  kisiInputController.text) >
                                              addList.length) {
                                            Navigator.pop(context);
                                            flushbar(
                                                context,
                                                '${addList.length} adaydan ${int.parse(kisiInputController.text)} aday seçilememektedir.',
                                                'Geçerli bir sayı girin.');
                                            kisiInputController.clear();
                                          } else if (int.parse(
                                                  kisiInputController.text) <=
                                              0) {
                                            Navigator.pop(context);
                                            flushbar(
                                                context,
                                                '${kisiInputController.text} aday seçilemez.',
                                                'Geçerli bir sayı girin.');
                                            kisiInputController.clear();
                                          } else {
                                            selectedList = [];
                                            count = int.parse(
                                                kisiInputController.text);

                                            for (var i = 0; i < count; i++) {
                                              var aday = addList[_random
                                                  .nextInt(addList.length)];
                                              setState(() {
                                                addList.remove(aday);
                                                selectedList.add(aday);
                                              });
                                            }
                                            setState(() {
                                              addList = [];
                                            });
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SecondScreen()),
                                            );
                                            reklam..show();
                                          }
                                        },
                                        child: Text('Devam'),
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Flushbar flushbar(BuildContext context, String title, String message) {
    return Flushbar(
      boxShadows: [
        BoxShadow(
            color: Colors.deepOrange, offset: Offset(0.0, 2.0), blurRadius: 3.0)
      ],
      backgroundGradient:
          LinearGradient(colors: [Colors.deepOrange, Colors.deepOrange[200]]),
      flushbarPosition: FlushbarPosition.TOP,
      title: title,
      message: message,
      duration: Duration(seconds: 1),
    )..show(context);
  }
}
