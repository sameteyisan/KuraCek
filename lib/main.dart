import 'dart:convert';

import 'dart:math';
import 'dart:ui';
import 'package:KuraCek/myKuralar.dart';
import 'package:KuraCek/second_screen.dart';
import 'package:KuraCek/sqflite.dart';
import 'package:KuraCek/sqfliteRating.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
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
          InterstitialAd.testAdUnitId, //ca-app-pub-4589290119610129/5977252855
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
            FirebaseAdMob.testAppId); //ca-app-pub-4589290119610129~8880007547
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
            BannerAd.testAdUnitId, //ca-app-pub-4589290119610129/6502664756
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
    return Scaffold(
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
                              splashRadius: 25,
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                if (inputController.text.isNotEmpty) {
                                  buildToast(
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
                              deviceLanguage["ButtonAdd"],
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
                                          deviceLanguage["addList.isNotEmpty"]);
                                    });
                                  });
                              }
                            },
                            child: Text(
                              deviceLanguage["ButtonClear"],
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
                              deviceLanguage["addList.length0"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(
                              deviceLanguage["addList.length!0"] +
                                  '    ${addList.length}',
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
                                      buildToast(
                                          deviceLanguage["IconButtonClear"]);
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
                                    title: deviceLanguage["kuralarim"],
                                    kuralarimdamSil:
                                        deviceLanguage["kuralarimdanSil"],
                                    kuralarimdanSilindi:
                                        deviceLanguage["kuralarimdanSilindi"],
                                    yes: deviceLanguage["yes"],
                                    no: deviceLanguage["no"],
                                    kayitliBirKuraYok:
                                        deviceLanguage["kayitliBirKuraYok"],
                                  )),
                        );
                      },
                      child: Text(
                        deviceLanguage["showKura"],
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
                                        deviceLanguage["KuraAdiBelirleme"],
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
                                              labelText:
                                                  deviceLanguage["KuraAdi"],
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
                                        child: Text(deviceLanguage["Iptal"]),
                                      ),
                                      FlatButton(
                                        color: Colors.deepOrange,
                                        onPressed: () {
                                          if (inputKuraAdiController
                                                  .text.length ==
                                              0) {
                                            buildToast(
                                                deviceLanguage["BirAdBelirle"]);
                                          } else if (inputKuraAdiController
                                                  .text.length >
                                              12) {
                                            buildToast(deviceLanguage[
                                                "karakterSiniri"]);
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
                                                  buildToast(deviceLanguage[
                                                      "KuraKaydedildi"]);
                                                });
                                              });
                                          }
                                        },
                                        child: Text(
                                            deviceLanguage["ButtonBelirle"]),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            deviceLanguage["ButtonKurayiKaydet"],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        FlatButton(
                          color: Colors.deepOrange,
                          child: Text(
                            deviceLanguage["ButtonKuraCekmeyiBaslat"],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (addList.length == 0) {
                              buildToast(deviceLanguage["adayList.lentgh==0"]);
                            } else {
                              kisiInputController.clear();
                              return showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          deviceLanguage["secimSorusu"] +
                                              '${addList.length} ' +
                                              deviceLanguage[
                                                  "secimSorusuExtra"], //'${addList.length} adaydan kaç aday seçilecek ?'
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
                                                labelText: deviceLanguage[
                                                    "adaySayisiSorgu"],
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
                                          child: Text(deviceLanguage["Iptal"]),
                                        ),
                                        FlatButton(
                                          color: Colors.deepOrange,
                                          onPressed: () {
                                            if (int.parse(
                                                    kisiInputController.text) >
                                                addList.length) {
                                              buildToast(
                                                '${addList.length} ' +
                                                    deviceLanguage["SuKadar"] +
                                                    ' ${int.parse(kisiInputController.text)} ' +
                                                    deviceLanguage["BuKadar"],
                                              );
                                              kisiInputController.clear();
                                            } else if (int.parse(
                                                    kisiInputController.text) <=
                                                0) {
                                              buildToast(
                                                "${kisiInputController.text} " +
                                                    deviceLanguage["girdi0"],
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
                                                          title: deviceLanguage[
                                                              "sonuclar"],
                                                          yeniKuraCek:
                                                              deviceLanguage[
                                                                  "newKura"],
                                                        )),
                                              );
                                              reklam..show();
                                            }
                                          },
                                          child: Text(deviceLanguage["devam"]),
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
      buildToast(deviceLanguage["adayGirilmedi"]);
    } else {
      if (addList.contains(inputController.text)) {
        buildToast(deviceLanguage["adayVar"]);
      } else if (inputController.text.contains(',')) {
        buildToast(deviceLanguage["virgul"]);
      } else if (inputController.text.length > 12) {
        buildToast(deviceLanguage["karakterSiniri"]);
      } else {
        addList.add(inputController.text);
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  title: Text("Bazı işleri daha iyi yapmamız için"),
                  content: Row(
                    children: [
                      Icon(Icons.rate_review),
                      Text("Bizi Oylamak İster Misiniz ?")
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        'Hiçbir Zaman',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onPressed: () {
                        TaskModelRating gonderilen;
                        gonderilen = TaskModelRating(rating: "Hiçbir Zaman.");
                        _td.insertTask(gonderilen);
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Daha Sonra',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Oyla',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () async {
                        TaskModelRating gonderilen;
                        gonderilen = TaskModelRating(rating: "Oylandı.");
                        _td.insertTask(gonderilen);
                        Navigator.pop(context);
                        _launchPlayStore();
                      },
                    )
                  ],
                ));
          });
    }
  }
}
