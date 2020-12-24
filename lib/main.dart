import 'dart:math';
import 'package:KuraCek/myKuralar.dart';
import 'package:KuraCek/second_screen.dart';
import 'package:KuraCek/sqflite.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(EasyLocalization(
      path: 'assets/languages',
      supportedLocales: [Locale('tr', 'TR'), Locale('en', 'UK')],
      child: MyApp()));
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'materialAppText'.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
      adUnitId:
          'ca-app-pub-4589290119610129/5977252855', //ca-app-pub-4589290119610129/5977252855
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
    FirebaseAdMob.instance.initialize(
        appId:
            'ca-app-pub-4589290119610129~8880007547'); //ca-app-pub-4589290119610129~8880007547
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
        adUnitId:
            'ca-app-pub-4589290119610129/6502664756', //ca-app-pub-4589290119610129/6502664756
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
        title: Text('appBarText'.tr()),
        actions: [
          PopupMenuButton<int>(
            tooltip: "flag".tr(),
            onSelected: (value) {
              if (value == 1) {
                setState(() {
                  context.locale = Locale('tr', 'TR');
                });
              } else if (value == 2) {
                setState(() {
                  context.locale = Locale('en', 'UK');
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset("assets/turkey.png"),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset("assets/united-states.png"),
                ),
              ),
            ],
            icon: context.locale == Locale('tr', 'TR')
                ? Image.asset("assets/turkey.png")
                : Image.asset("assets/united-states.png"),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => _onBackPressed(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 240,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextField(
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          control();
                        },
                        controller: inputController,
                        maxLength: 12,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              splashRadius: 25,
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                if (inputController.text.isNotEmpty) {
                                  buildToast(
                                    "inputController.text.isNotEmpty".tr(),
                                  );
                                }
                                setState(() {
                                  inputController.clear();
                                });
                              },
                            ),
                            hintText: 'hintText'.tr(),
                            labelText: 'labelText'.tr(),
                            icon: Icon(Icons.add)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            color: Colors.green,
                            onPressed: () async {
                              control();
                            },
                            child: Text(
                              'ButtonAdd'.tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          FlatButton(
                            color: Colors.red,
                            onPressed: () {
                              if (addList.isNotEmpty) {
                                reklam
                                  ..show().whenComplete(() {
                                    setState(() {
                                      addList.clear();
                                      buildToast(
                                        "addList.isNotEmpty".tr(),
                                      );
                                    });
                                  });
                              }
                            },
                            child: Text(
                              'ButtonClear'.tr(),
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
                              'addList.length0'.tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'addList.length!0'.tr() + '    ${addList.length}',
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
                                      buildToast("IconButtonClear".tr());
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
                          MaterialPageRoute(
                              builder: (context) => MyKuralar(
                                    title: "kuralarim".tr(),
                                    kuralarimdamSil: "kuralarimdanSil".tr(),
                                    kuralarimdanSilindi:
                                        "kuralarimdanSilindi".tr(),
                                    yes: "yes".tr(),
                                    no: "no".tr(),
                                    kayitliBirKuraYok: "kayitliBirKuraYok".tr(),
                                  )),
                        );
                      },
                      child: Text(
                        'showKura'.tr(),
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
                                        'KuraAdiBelirleme'.tr(),
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
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              labelText: 'KuraAdi'.tr(),
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.clear),
                                                onPressed: () {
                                                  inputKuraAdiController
                                                      .clear();
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
                                        child: Text('Iptal'.tr()),
                                      ),
                                      FlatButton(
                                        color: Colors.deepOrange,
                                        onPressed: () {
                                          if (inputKuraAdiController
                                                  .text.length ==
                                              0) {
                                            buildToast("BirAdBelirle".tr());
                                          } else if (inputKuraAdiController
                                                  .text.length >
                                              12) {
                                            buildToast("karakterSiniri".tr());
                                          } else {
                                            for (var i = 0;
                                                i < addList.length;
                                                i++) {
                                              setState(() {
                                                listeler += addList[i] + ', ';
                                              });
                                            }
                                            gonderilen = TaskModel(
                                                kuraList: listeler,
                                                name: inputKuraAdiController
                                                    .text);
                                            _todoHelper.insertTask(gonderilen);
                                            reklam
                                              ..show().whenComplete(() {
                                                setState(() {
                                                  listeler = '';
                                                  addList.clear();
                                                  Navigator.pop(context);
                                                  inputKuraAdiController
                                                      .clear();
                                                  buildToast(
                                                      "KuraKaydedildi".tr());
                                                });
                                              });
                                          }
                                        },
                                        child: Text('ButtonBelirle'.tr()),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            'ButtonKurayiKaydet'.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        FlatButton(
                          color: Colors.deepOrange,
                          child: Text(
                            'ButtonKuraCekmeyiBaslat'.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (addList.length == 0) {
                              buildToast("adayList.lentgh==0".tr());
                            } else {
                              kisiInputController.clear();
                              return showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "secimSorusu".tr() +
                                              '${addList.length} ' +
                                              'secimSorusuExtra'
                                                  .tr(), //'${addList.length} adaydan kaç aday seçilecek ?'
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
                                              keyboardType:
                                                  TextInputType.number,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'adaySayisiSorgu'.tr(),
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
                                          child: Text('Iptal'.tr()),
                                        ),
                                        FlatButton(
                                          color: Colors.deepOrange,
                                          onPressed: () {
                                            if (int.parse(
                                                    kisiInputController.text) >
                                                addList.length) {
                                              buildToast(
                                                '${addList.length} ' +
                                                    'SuKadar'.tr() +
                                                    ' ${int.parse(kisiInputController.text)} ' +
                                                    'BuKadar'.tr(),
                                              );
                                              kisiInputController.clear();
                                            } else if (int.parse(
                                                    kisiInputController.text) <=
                                                0) {
                                              buildToast(
                                                "${kisiInputController.text} " +
                                                    "girdi0".tr(),
                                              );
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
                                                inputController.clear();
                                              });
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SecondScreen(
                                                          title:
                                                              'sonuclar'.tr(),
                                                          yeniKuraCek:
                                                              'newKura'.tr(),
                                                        )),
                                              );
                                              reklam..show();
                                            }
                                          },
                                          child: Text('devam'.tr()),
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
      ),
    );
  }

  void buildToast(String text) => Toast.show(
        text,
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );

  void control() {
    if (inputController.text.length == 0) {
      buildToast("adayGirilmedi".tr());
    } else {
      if (addList.contains(inputController.text)) {
        buildToast("adayVar".tr());
      } else if (inputController.text.contains(',')) {
        buildToast("virgul".tr());
      } else if (inputController.text.length > 12) {
        buildToast("karakterSiniri.".tr());
      } else {
        addList.add(inputController.text);
        setState(() {
          addList = addList;
        });
      }
    }
    inputController.clear();
  }
}
