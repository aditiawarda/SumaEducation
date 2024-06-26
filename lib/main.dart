// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/main_page/bottom_navigation_view/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return
      MaterialApp(
        title: 'Suma App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          platform: TargetPlatform.iOS,
        ),
        home: MyHomePage()
      );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  AnimationController? animationController;
  String? versionUse = '1.1.4';
  String? currentVersion = '';
  bool load = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _getVersionApp();
  }

  void _load() {
    setState(() {
      load = !load;
    });
  }

  _getVersionApp() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/app_version"),
          body: {
            "request": "request",
          });
      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        var version = json["version"];
        var link = json["link"];
        currentVersion = version;
        setState(() {
           check(link.toString());
        });
      }
    } catch (e) {
      print('Error '+e.toString());
      load = false;

      showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          transitionAnimationController: animationController,
          builder: (BuildContext context) {
            return
              SlideInUp(
                delay: Duration(milliseconds: 200),
                child:  Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0),
                        topRight: Radius.circular(20.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 3.0),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 3,
                        margin: EdgeInsets.only(top: 20, bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 35),
                          Image.asset('assets/images/not_connection.png', height: 80, width: 80),
                          Padding(
                              padding: const EdgeInsets.only( left: 20),
                              child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text('Koneksi terputus',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.6,
                                    padding: EdgeInsets.only(right: 5),
                                    child: Text('Pastikan perangkat kamu terhubung dengan internet.',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                        )
                                    ),
                                  ),
                                  SizedBox(width: 35),
                                ],
                              )
                          ),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 15),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child:
                          ZoomTapAnimation(
                            onTap: () async {
                              Navigator.pop(context);
                              _load();
                              Timer(Duration(seconds: 3), () => { _getVersionApp() });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.orange.shade600,
                              ),
                              child: Text(
                                'Coba Hubungkan',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child:
                          ZoomTapAnimation(
                            onTap: () async {
                              Navigator.pop(context);
                              Timer(Duration(seconds: 2), () => { SystemNavigator.pop() });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.orange.shade50,
                              ),
                              child: Text(
                                'Tutup',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              );
          }
      );

    }

    return 'true';

  }

  void check(String link) async {
    load = false;
    Timer(Duration(seconds: 2), () => {
      if(versionUse==currentVersion){
        Navigator.of(context).pop(), masuk()
      } else {
        showBottomSheet(link)
      }
    });
  }

  void showBottomSheet(String link) {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        transitionAnimationController: animationController,
        builder: (BuildContext context) {
          return
            SlideInUp(
              delay: Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topRight: Radius.circular(20.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 3.0),
                  ],
                ),
                child:
                Wrap(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 3,
                          margin: EdgeInsets.only(top: 20, bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 20),
                            Image.asset('assets/images/sl_logo_app.png', height: 80, width: 80),
                            Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text('Update Aplikasi',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                          )
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.6,
                                      padding: EdgeInsets.only(right: 5),
                                      child: Text('Suma App v '+currentVersion!+' telah tersedia di Google Play Store.',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: 0,
                                              height: 1.5,
                                          )
                                      ),
                                    ),
                                    SizedBox(width: 35),
                                  ],
                                )
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child:
                          ZoomTapAnimation(
                            onTap: () async {
                              Navigator.pop(context);
                              await launch(link);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.orange.shade600,
                              ),
                              child: Text(
                                'Update Sekarang',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child:
                            ZoomTapAnimation(
                              onTap: () async {
                                Navigator.pop(context);
                                _load();
                                Timer(Duration(seconds: 1), () => { masuk() });
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.orange.shade50,
                                ),
                                child: Text(
                                  'Nanti',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
        });
    future.then((void value) => closeBottomSheet(value));
  }
  void closeBottomSheet(void value) {
    print('modal closed');
    Timer(Duration(seconds: 1), () => { masuk() });
  }

  void masuk() async {
    final SharedPreferences prefs = await _prefs;
    print(prefs.getBool('login'));
    //Di komen dulu (Semuanya bisa ke home)
    // if (prefs.getBool('login') == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainPage()
          ),
          ModalRoute.withName("/Home")
      );
    // } else {
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => LoginScreen(animationController: animationController,)
    //       ),
    //       ModalRoute.withName("/Login")
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Scaffold(
              body:
              AnimatedBuilder(
                animation: animationController!,
                builder: (BuildContext context, Widget? child) {
                  return
                    Container(
                      child:
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 60),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FadeInUp(
                                    delay : Duration(milliseconds: 1000),
                                    child : Image.asset('assets/images/sl_logo_app.png', height: 200, width: 200),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 40),
                                    child: load ?  CircularProgressIndicator(
                                      color: Colors.orange.shade200,
                                      strokeWidth: 4,
                                    ) : null,
                                  ),
                                  FadeInUp(
                                    delay : Duration(milliseconds: 1000),
                                    child : Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('Powered by :', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Image.asset('assets/images/logogap.png', width: 153),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Image.asset('assets/images/suma_logo.png', width: 22),
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      )
                  );
                },
              ),
            )
          ]
      )
    );
  }

}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
