import 'dart:convert';

import 'dart:math';
import 'dart:ui';
import 'package:KuraCek/Database/sqflite.dart';
import 'package:KuraCek/Database/sqfliteRating.dart';
import 'package:KuraCek/myKuralar.dart';
import 'package:KuraCek/second_screen.dart';
import 'package:KuraCek/widget/const.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:url_launcher/url_launcher.dart';

var deviceLanguage;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dilDestegi();
  runApp(MyApp());
}

Future<dynamic> dilDestegi() async {
  List languages = await Devicelocale.preferredLanguages;
  if (languages[0] == "tr_TR") {
    String data = await rootBundle.loadString('assets/languages/turk.json');
    deviceLanguage = json.decode(data);
  } else {
    String data = await rootBundle.loadString('assets/languages/eng.json');
    deviceLanguage = json.decode(data);
  }
  print(languages[0]);
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
      title: deviceLanguage["materialAppText"],
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
          "ca-app-pub-4589290119610129/5977252855", //ca-app-pub-4589290119610129/5977252855
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
    ratingVarMi();
    super.initState();
    FirebaseAdMob.instance.initialize(
        appId:
            "ca-app-pub-4589290119610129~8880007547"); //ca-app-pub-4589290119610129~8880007547
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
            "ca-app-pub-4589290119610129/6502664756", //ca-app-pub-4589290119610129/6502664756
        size: AdSize.largeBanner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
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
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 4.0,
                    sigmaY: 4.0,
                  ),
                  child: AlertDialog(
                    shape: shape,
                    title: Text(deviceLanguage["areYouSure"]),
                    content: Text(deviceLanguage["closeNow"]),
                    actions: <Widget>[
                      FlatButton(
                        color: btnOrange,
                        child: Text(
                          deviceLanguage["no"],
                          style: boldWhite,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        color: btnGreen,
                        child: Text(
                          deviceLanguage["yes"],
                          style: boldWhite,
                        ),
                        onPressed: () async {
                          SystemNavigator.pop();
                        },
                      )
                    ],
                  ));
            });
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(deviceLanguage["appBarText"]),
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
                                splashRadius: 20,
                                icon: Icon(
                                  LineAwesomeIcons.broom,
                                ),
                                onPressed: () {
                                  if (inputController.text.isNotEmpty) {
                                    buildToast(
                                      context,
                                      deviceLanguage[
                                          "inputController.text.isNotEmpty"],
                                    );
                                  }
                                  setState(() {
                                    inputController.clear();
                                  });
                                },
                              ),
                              hintText: deviceLanguage["hintText"],
                              labelText: deviceLanguage["labelText"],
                              icon: Icon(
                                Icons.add,
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              color: btnGreen,
                              onPressed: () async {
                                control();
                              },
                              child: buttonText(deviceLanguage["ButtonAdd"]),
                            ),
                            FlatButton(
                              color: btnOrange,
                              onPressed: () {
                                if (addList.isNotEmpty) {
                                  reklam
                                    ..show().whenComplete(() {
                                      setState(() {
                                        addList.clear();
                                        buildToast(
                                            context,
                                            deviceLanguage[
                                                "addList.isNotEmpty"]);
                                      });
                                    });
                                }
                              },
                              child: buttonText(deviceLanguage["ButtonClear"]),
                            ),
                          ],
                        ),
                        Divider(
                          height: 20,
                          indent: 500.0,
                        ),
                        addList.length == 0
                            ? Text(
                                deviceLanguage["addList.length0"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Text(
                                deviceLanguage["addList.length!0"] +
                                    '    ${addList.length}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                        Expanded(
                          child: Theme(
                            data: themeScrollBar,
                            child: Scrollbar(
                              thickness: 4,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    // ignore: missing_required_param
                                    return FlatButton(
                                        child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${index + 1}.  ' +
                                              '${addList[index]}'.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.primaries[Random()
                                                  .nextInt(Colors
                                                      .primaries.length)]),
                                        ),
                                        IconButton(
                                          highlightColor: btnOrange,
                                          splashRadius: 20,
                                          iconSize: 20,
                                          icon: Icon(LineAwesomeIcons.trash),
                                          onPressed: () {
                                            setState(() {
                                              addList.remove(addList[index]);
                                            });
                                            buildToast(
                                                context,
                                                deviceLanguage[
                                                    "IconButtonClear"]);
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                addList.length == 0
                    ? FlatButton(
                        color: btnOrange,
                        onPressed: () async {
                          reklam..show();
                          List<TaskModel> list = await _todoHelper.getAllTask();
                          savedKuralar = list;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyKuralar()),
                          );
                        },
                        child: buttonText(deviceLanguage["showKura"]),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            color: btnOrange,
                            onPressed: () async {
                              kuraAdiBelirle(context, _todoHelper, reklam);
                            },
                            child: buttonText(
                                deviceLanguage["ButtonKurayiKaydet"]),
                          ),
                          FlatButton(
                            color: btnOrange,
                            child: buttonText(
                                deviceLanguage["ButtonKuraCekmeyiBaslat"]),
                            onPressed: () {
                              if (addList.length == 0) {
                                buildToast(
                                  context,
                                  deviceLanguage["adayList.lentgh==0"],
                                );
                              } else {
                                kisiInputController.clear();
                                return showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 4.0,
                                            sigmaY: 4.0,
                                          ),
                                          child: AlertDialog(
                                            shape: shape,
                                            title: Text(
                                              deviceLanguage["secimSorusu"] +
                                                  '${addList.length} ' +
                                                  deviceLanguage[
                                                      "secimSorusuExtra"],
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black),
                                            ),
                                            content: Container(
                                              height: 100,
                                              child: Column(
                                                children: [
                                                  TextField(
                                                    maxLength: 8,
                                                    onChanged: (value) {},
                                                    controller:
                                                        kisiInputController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                      labelText: deviceLanguage[
                                                          "adaySayisiSorgu"],
                                                      suffixIcon: IconButton(
                                                        splashRadius: 20,
                                                        icon: Icon(
                                                          LineAwesomeIcons
                                                              .broom,
                                                        ),
                                                        onPressed: () {
                                                          kisiInputController
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
                                                color: btnGreen,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  kisiInputController.clear();
                                                },
                                                child: Text(
                                                    deviceLanguage["Iptal"]),
                                              ),
                                              FlatButton(
                                                color: btnOrange,
                                                onPressed: () {
                                                  try {
                                                    if (int.parse(
                                                            kisiInputController
                                                                .text) >
                                                        addList.length) {
                                                      buildToast(
                                                        context,
                                                        '${addList.length} ' +
                                                            deviceLanguage[
                                                                "SuKadar"] +
                                                            ' ${int.parse(kisiInputController.text)} ' +
                                                            deviceLanguage[
                                                                "BuKadar"],
                                                      );
                                                      kisiInputController
                                                          .clear();
                                                    } else if (int.parse(
                                                            kisiInputController
                                                                .text) <=
                                                        0) {
                                                      buildToast(
                                                        context,
                                                        "${kisiInputController.text} " +
                                                            deviceLanguage[
                                                                "girdi0"],
                                                      );
                                                      kisiInputController
                                                          .clear();
                                                    } else {
                                                      selectedList = [];
                                                      count = int.parse(
                                                          kisiInputController
                                                              .text);

                                                      for (var i = 0;
                                                          i < count;
                                                          i++) {
                                                        var aday = addList[
                                                            _random.nextInt(
                                                                addList
                                                                    .length)];
                                                        setState(() {
                                                          addList.remove(aday);
                                                          selectedList
                                                              .add(aday);
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
                                                                SecondScreen()),
                                                      );
                                                      reklam..show();
                                                    }
                                                  } catch (_) {
                                                    buildToast(context,
                                                        "Bir sayı girin.");
                                                  }
                                                },
                                                child: Text(
                                                    deviceLanguage["devam"]),
                                              )
                                            ],
                                          ));
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
      ),
    );
  }

  Future<String> kuraAdiBelirle(
      BuildContext context, TodoHelper _todoHelper, InterstitialAd reklam) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: AlertDialog(
                shape: shape,
                title: Text(
                  deviceLanguage["KuraAdiBelirleme"],
                  style: TextStyle(fontSize: 17, color: Colors.black),
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
                          labelText: deviceLanguage["KuraAdi"],
                          suffixIcon: IconButton(
                            splashRadius: 20,
                            icon: Icon(
                              LineAwesomeIcons.broom,
                            ),
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
                    color: btnGreen,
                    onPressed: () {
                      Navigator.pop(context);
                      inputKuraAdiController.clear();
                    },
                    child: Text(deviceLanguage["Iptal"]),
                  ),
                  FlatButton(
                    color: btnOrange,
                    onPressed: () {
                      if (inputKuraAdiController.text.length == 0) {
                        buildToast(
                          context,
                          deviceLanguage["BirAdBelirle"],
                        );
                      } else if (inputKuraAdiController.text.length > 12) {
                        buildToast(
                          context,
                          deviceLanguage["karakterSiniri"],
                        );
                      } else {
                        for (var i = 0; i < addList.length; i++) {
                          setState(() {
                            listeler += addList[i] + ', ';
                          });
                        }
                        gonderilen = TaskModel(
                            kuraList: listeler,
                            name: inputKuraAdiController.text);
                        _todoHelper.insertTask(gonderilen);
                        reklam
                          ..show().whenComplete(() {
                            setState(() {
                              listeler = '';
                              addList.clear();
                              Navigator.pop(context);
                              inputKuraAdiController.clear();
                              buildToast(
                                context,
                                deviceLanguage["KuraKaydedildi"],
                              );
                            });
                          });
                      }
                    },
                    child: Text(deviceLanguage["ButtonBelirle"]),
                  )
                ],
              ));
        });
  }

  Text buttonText(String text) {
    return Text(
      text,
      style: boldWhite,
    );
  }

  void control() {
    if (inputController.text.trim().length == 0) {
      buildToast(
        context,
        deviceLanguage["adayGirilmedi"],
      );
    } else {
      if (addList.contains(inputController.text.trim())) {
        buildToast(
          context,
          deviceLanguage["adayVar"],
        );
      } else if (inputController.text.contains(',')) {
        buildToast(
          context,
          deviceLanguage["virgul"],
        );
      } else if (inputController.text.length > 12) {
        buildToast(
          context,
          deviceLanguage["karakterSiniri"],
        );
      } else {
        addList.add(inputController.text.trim());
        setState(() {
          addList = addList;
        });
      }
    }
    inputController.clear();
  }

  _launchPlayStore() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.appID.KuraCek';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<dynamic> ratingVarMi() async {
    final TodoHelperRating _td = TodoHelperRating();
    await _td.initDatabase();
    List<TaskModelRating> list = await _td.getAllTask();
    if (list.isEmpty) {
      String token = await _firebaseMessaging.getToken();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true, provisional: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        print("Push Messaging token: $token");
      });
      print("FirebaseMessaging token: $token");
      await ratingDialog(
          _td,
          deviceLanguage["bildirimSesAc"],
          Text(deviceLanguage["bildirimYardim"]),
          deviceLanguage["bildirimSesAc"]);
    } else if (list.length == 1) {
      await ratingDialog(
          _td,
          deviceLanguage["oylamaMemnun"],
          Row(
            children: [
              Icon(
                LineAwesomeIcons.star,
              ),
              Text(deviceLanguage["oylamaistemek"])
            ],
          ),
          deviceLanguage["oylamaRating"]);
    }
  }

  ratingDialog(
    TodoHelperRating _td,
    String title,
    dynamic content,
    String btnText,
  ) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: AlertDialog(
                shape: shape,
                title: Text(title),
                content: content,
                actions: <Widget>[
                  FlatButton(
                    color: btnOrange,
                    child: Text(
                      deviceLanguage["oylamaDahaSonra"],
                      style: boldWhite,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: btnGreen,
                    child: Text(
                      btnText,
                      style: boldWhite,
                    ),
                    onPressed: () async {
                      if (btnText == deviceLanguage["bildirimSesAc"]) {
                        TaskModelRating gonderilen;
                        gonderilen = TaskModelRating(rating: "Bildirimler.");
                        await _td.insertTask(gonderilen);
                        Navigator.pop(context);
                        await OpenAppSettings.openNotificationSettings();
                      } else if (btnText == deviceLanguage["oylamaRating"]) {
                        TaskModelRating gonderilen;
                        gonderilen = TaskModelRating(rating: "Oylandı.");
                        _td.insertTask(gonderilen);
                        Navigator.pop(context);
                        _launchPlayStore();
                      }
                    },
                  )
                ],
              ));
        });
  }
}
