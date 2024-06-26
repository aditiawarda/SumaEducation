import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/main_page/games/puzzle/src/inject_dependencies.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/my_app.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/main.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/keyword_list.dart';
import 'package:suma_education/suma_education/main_page/model/menu_data.dart';
import 'package:suma_education/suma_education/main_page/screen/book_content_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/book_konten_detail.dart';
import 'package:suma_education/suma_education/main_page/screen/interaktif_video_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/kreasi_video_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/login_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/tutorial_video_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'dart:math' as math;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

List<MenuData> listMenu = [];
SharedPreferences? prefs;
String namaUser = "";
String fotoProfil = "";
String boolLogin = "";
List<BookData> book = [];
List<KeywordList> keywordList = [];
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class MainMenu extends StatelessWidget {
  final AnimationController? animationController;
  final AnimationController? animationControllerBottomSheet;
  final Animation<double>? animation;

  const MainMenu(
      {Key? key, this.animationController, this.animation, required this.animationControllerBottomSheet})
      : super(key: key);

  Future<String> getUser() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getBool('login') == true){
      boolLogin = "true";
      namaUser = prefs.getString("data_username")!;
      try {
        var response = await http.post(
            Uri.parse("https://suma.geloraaksara.co.id/api/profile_picture"),
            body: {
              "id": prefs.getString("data_id")!,
            });
        var json = jsonDecode(response.body);
        String status = json["status"];
        if (status == "Success") {
          fotoProfil = json["filename"];
          for (var i = 0; i < json['keyword'].length; i++) {
            var judul = json['keyword'][i]['judul'];
            keywordList.add(KeywordList(judul));
          }
          print(fotoProfil.toString());
        } else {
          print("error");
        }
      } catch (e) {
        print("error");
      }
    } else {
      boolLogin = "false";
    }
    return 'true';
  }

  Future<String> _getNewBook() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/get_content_book_new"),
          body: {
            "id_user": "request",
          });
      book = [];
      var dataBookNew = json.decode(response.body);
      print(dataBookNew);
      for (var i = 0; i < dataBookNew['data'].length; i++) {
        var id = dataBookNew['data'][i]['id'].toString();
        var judul = dataBookNew['data'][i]['judul'].toString();
        var deskripsi = dataBookNew['data'][i]['deskripsi'].toString();
        var cover = dataBookNew['data'][i]['cover'].toString();
        var created_at = dataBookNew['data'][i]['created_at'].toString();
        var jumlah_halaman = dataBookNew['data'][i]['jumlah_halaman'].toString();
        var voice_cover = dataBookNew['data'][i]['voice_cover'].toString();
        var backsound = dataBookNew['data'][i]['backsound'].toString();
        var viewer = dataBookNew['data'][i]['viewer'].toString();
        var with_login = dataBookNew['data'][i]['with_login'].toString();

        book.add(BookData(id, judul, deskripsi, cover, created_at, jumlah_halaman, voice_cover, backsound, viewer, with_login));
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return
          FadeInUp(
            delay : Duration(milliseconds: 500),
            child : FadeTransition(
              opacity: animation!,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - animation!.value), 0.0),
                child:
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 16),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.only(bottom: 5, top: 23, left: 5, right: 5),
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                gradient: LinearGradient(colors: [
                                  AppTheme.white,
                                  Colors.yellow.shade50
                                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.2),
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 2.0),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 10, right: 10,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrange.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 17, right: 55,
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Container(
                            height: 85,
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 10, top: 10, left: 5, right: 5),
                            child:
                            FutureBuilder<String>(
                              future: getUser(),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                return
                                  Row(
                                    children: [
                                      if (boolLogin == "true") ...{
                                        Expanded(
                                            flex: 2,
                                            child:
                                            Stack(
                                              children: [
                                                Container(
                                                  width: 85,
                                                  height: 85,
                                                  margin: EdgeInsets.only(right: 15),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                                    image: DecorationImage(
                                                        image: AssetImage('assets/images/default_profile.jpg'),
                                                        fit: BoxFit.contain
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(right: 15),
                                                    child:
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      child: CircularProgressIndicator(
                                                        color: Colors.deepOrange.withOpacity(0.8),
                                                        strokeWidth: 2.5,
                                                      ),
                                                    )
                                                ),
                                                FutureBuilder<String>(
                                                  future: getUser(),
                                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return
                                                        Container(
                                                          margin: EdgeInsets.only(top: 13),
                                                          child: CircleAvatar(
                                                            radius: 30.0,
                                                            backgroundColor: Colors.white,
                                                            child: CircleAvatar(
                                                              backgroundColor: Colors.orange,
                                                              backgroundImage: AssetImage('assets/images/default_profile.jpg'),
                                                              radius: 28.0,
                                                            ),
                                                          ),
                                                        );
                                                    } else {
                                                      if (snapshot.hasError)
                                                        return
                                                          Container(
                                                            margin: EdgeInsets.only(top: 13),
                                                            child: CircleAvatar(
                                                              radius: 30.0,
                                                              backgroundColor: Colors.white,
                                                              child: CircleAvatar(
                                                                backgroundColor: Colors.orange,
                                                                backgroundImage: AssetImage('assets/images/default_profile.jpg'),
                                                                radius: 28.0,
                                                              ),
                                                            ),
                                                          );
                                                      else
                                                        return
                                                          Container(
                                                            margin: EdgeInsets.only(top: 13),
                                                            child: CircleAvatar(
                                                              radius: 30.0,
                                                              backgroundColor: Colors.white,
                                                              child: CircleAvatar(
                                                                backgroundColor: Colors.orange,
                                                                backgroundImage: NetworkImage('https://suma.geloraaksara.co.id/uploads/profile_pic/'+fotoProfil),
                                                                radius: 28.0,
                                                              ),
                                                            ),
                                                          );
                                                    }
                                                  },
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child:
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            FutureBuilder<String>(
                                              future: getUser(), // function where you call your api
                                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Memuat data...",
                                                        textAlign: TextAlign.left,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontFamily: 'RobotoMono',
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.orange
                                                        ),
                                                      ),
                                                      AnimatedTextKit(
                                                        animatedTexts: [
                                                          TypewriterAnimatedText('Memuat data...',
                                                            textStyle: const TextStyle(
                                                              color: Colors.orange,
                                                              fontSize: 11.0,
                                                            ),
                                                            speed: const Duration(milliseconds: 100),
                                                          )
                                                        ],
                                                        totalRepeatCount: 100,
                                                        pause: const Duration(milliseconds: 1000),
                                                        displayFullTextOnTap: true,
                                                        stopPauseOnTap: true,
                                                      )
                                                    ],
                                                  );
                                                } else {
                                                  if (snapshot.hasError)
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Gagal terhubung...",
                                                          textAlign: TextAlign.left,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontFamily: 'RobotoMono',
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.orange
                                                          ),
                                                        ),
                                                        AnimatedTextKit(
                                                          animatedTexts: [
                                                            TypewriterAnimatedText('Gagal terhubung...',
                                                              textStyle: const TextStyle(
                                                                color: Colors.orange,
                                                                fontSize: 11.0,
                                                              ),
                                                              speed: const Duration(milliseconds: 100),
                                                            ),
                                                          ],
                                                          totalRepeatCount: 100,
                                                          pause: const Duration(milliseconds: 1000),
                                                          displayFullTextOnTap: true,
                                                          stopPauseOnTap: true,
                                                        )
                                                      ],
                                                    );
                                                  else
                                                    return
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Hallo, "+namaUser,
                                                            textAlign: TextAlign.left,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontFamily: 'RobotoMono',
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.orange
                                                            ),
                                                          ),
                                                          AnimatedTextKit(
                                                            animatedTexts: [
                                                              for(int i=0; i<keywordList.length; i++)...{
                                                                TypewriterAnimatedText(keywordList[i].judul,
                                                                  textStyle: const TextStyle(
                                                                    color: Colors.orange,
                                                                    fontSize: 11.0,
                                                                  ),
                                                                  speed: const Duration(milliseconds: 100),
                                                                ),
                                                              },
                                                            ],
                                                            repeatForever: true,
                                                            pause: const Duration(milliseconds: 1000),
                                                            displayFullTextOnTap: true,
                                                            stopPauseOnTap: true,
                                                          )
                                                        ],
                                                      );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      } else ...{
                                        Expanded(
                                            child:
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child:
                                              ZoomTapAnimation(
                                                onTap: () {
                                                  new Future.delayed(new Duration(milliseconds: 300), () {
                                                    Navigator.push<dynamic>(
                                                        context,
                                                        MaterialPageRoute<dynamic>(
                                                          builder: (BuildContext context) => LoginScreen(animationController: animationController),
                                                        )
                                                    );
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(left: 11, right: 11),
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.deepOrange,
                                                        shape: BoxShape.circle,
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(
                                                              color: AppTheme.grey.withOpacity(0.5),
                                                              offset: Offset(0.0, 1.0), //(x,y)
                                                              blurRadius: 1.0),
                                                        ],
                                                      ),
                                                      child:
                                                      Container(
                                                        child: Icon(
                                                          Icons.login,
                                                          size: 22,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child:
                                                      Text(
                                                        'Login Sekarang',
                                                        style: TextStyle(
                                                            color: Colors.orange,
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: 20
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                        )
                                      }
                                    ],
                                  );
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topRight: Radius.circular(30.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.grey.withOpacity(0.2),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 2.0),
                          ],
                        ),
                        child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'VIDEO',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    ),
                                    Text(
                                      'LEARNING',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Rekomendasi Pembelajaran',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'RobotoMono',
                                      color: Colors.black87.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child:
                                      Column(
                                        children: [
                                          ZoomTapAnimation(
                                            onTap: () {
                                              new Future.delayed(new Duration(milliseconds: 300), () {
                                                Navigator.push<dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext context) => KreasiScreen(animationController: animationController),
                                                    )
                                                );
                                              });
                                            },
                                            child:
                                            Stack(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(right: 15, left: 7),
                                                  height: 90,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.shade50,
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10.0),
                                                        bottomLeft: Radius.circular(10.0),
                                                        bottomRight: Radius.circular(10.0),
                                                        topRight: Radius.circular(10.0)),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          color: AppTheme.grey.withOpacity(0.1),
                                                          offset: Offset(0.0, 1.0), //(x,y)
                                                          blurRadius: 0.5),
                                                    ],
                                                  ),
                                                  child:
                                                  Image.asset(
                                                    'assets/images/ic_kreasi.png',
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 2, right: 17,
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                        Icons.play_arrow,
                                                        color: Colors.blue.shade200,
                                                        size: 16,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(right: 8),
                                                  width: double.infinity,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(5.0),
                                                        bottomLeft: Radius.circular(5.0),
                                                        bottomRight: Radius.circular(5.0),
                                                        topRight: Radius.circular(5.0)),
                                                    color: Colors.blue.shade200,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                              margin: EdgeInsets.only(right: 10),
                                              child: Text(
                                                  "Kreasi",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14
                                                  )
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child:
                                      Column(
                                        children: [
                                          ZoomTapAnimation(
                                            onTap: () {
                                              new Future.delayed(new Duration(milliseconds: 300), () {
                                                Navigator.push<dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext context) => InteraktifScreen(animationController: animationController),
                                                    )
                                                );
                                              });
                                            },
                                            child:
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 90,
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(right: 10, left: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.shade50,
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10.0),
                                                        bottomLeft: Radius.circular(10.0),
                                                        bottomRight: Radius.circular(10.0),
                                                        topRight: Radius.circular(10.0)),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          color: AppTheme.grey.withOpacity(0.1),
                                                          offset: Offset(0.0, 1.0), //(x,y)
                                                          blurRadius: 0.5),
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    'assets/images/ic_interaktif.png',
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 2, right: 12,
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.green.shade200,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(right: 3, left: 3),
                                                  width: double.infinity,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(5.0),
                                                        bottomLeft: Radius.circular(5.0),
                                                        bottomRight: Radius.circular(5.0),
                                                        topRight: Radius.circular(5.0)),
                                                    color: Colors.green.shade200,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                              child: Text(
                                                  "Interaktif",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14
                                                  )
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child:
                                      Column(
                                        children: [
                                          ZoomTapAnimation(
                                            onTap: () {
                                              new Future.delayed(new Duration(milliseconds: 300), () {
                                                Navigator.push<dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext context) => TutorialScreen(animationController: animationController),
                                                    )
                                                );
                                              });
                                            },
                                            child:
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 90,
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(left: 15, right: 7),
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple.shade50,
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10.0),
                                                        bottomLeft: Radius.circular(10.0),
                                                        bottomRight: Radius.circular(10.0),
                                                        topRight: Radius.circular(10.0)),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          color: AppTheme.grey.withOpacity(0.1),
                                                          offset: Offset(0.0, 1.0), //(x,y)
                                                          blurRadius: 0.5),
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    'assets/images/ic_tutorial.png',
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 2, right: 10,
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.purple.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.purple.shade200,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(left: 8),
                                                  width: double.infinity,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(5.0),
                                                        bottomLeft: Radius.circular(5.0),
                                                        bottomRight: Radius.circular(5.0),
                                                        topRight: Radius.circular(5.0)),
                                                    color: Colors.purple.shade200,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                                "Tutorial",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14
                                                )
                                            )
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 25, left: 20, right: 20),
                                  height: 10,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange.shade100,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0)
                                    ),
                                  ),
                                )
                              ],
                            )
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.2),
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 2.0),
                            ],
                          ),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'READING',
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  ),
                                  Text(
                                    'STORY',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Cerita terbaru dari Suma dan Sahabat',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'RobotoMono',
                                    color: Colors.black87.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child:
                                FutureBuilder<String>(
                                  future: _getNewBook(),
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container(
                                          height: MediaQuery.of(context).size.height*0.6,
                                          width: MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
                                            margin: EdgeInsets.only(
                                                right: 10),
                                            child: CircularProgressIndicator(
                                              color: Colors.orange,
                                              strokeWidth: 3,
                                            ),
                                          )
                                      );
                                    } else {
                                      if (snapshot.hasError)
                                        return FadeInUp(
                                          delay: Duration(milliseconds: 500),
                                          child: Container(
                                            margin: EdgeInsets.only(top: 130),
                                            padding: EdgeInsets.only(bottom: 100),
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(bottom: 10),
                                                  child: Image.asset("assets/images/empty_data.png", height: 100),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Belum ada konten',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                        letterSpacing: 0.5,
                                                        color: Colors.blueGrey.shade200,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Data konten belum tersedia',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        letterSpacing: 0.5,
                                                        color: Colors.blueGrey.shade200,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      else
                                      if(book.length==0)
                                        return
                                          FadeInUp(
                                            delay: Duration(milliseconds: 500),
                                            child: Container(
                                              margin: EdgeInsets.only(top: 130),
                                              padding: EdgeInsets.only(bottom: 100),
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(bottom: 10),
                                                    child: Image.asset("assets/images/empty_data.png", height: 100),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Belum ada konten',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 16,
                                                          letterSpacing: 0.5,
                                                          color: Colors.blueGrey.shade200,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Data konten belum tersedia',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12,
                                                          letterSpacing: 0.5,
                                                          color: Colors.blueGrey.shade200,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                      else
                                        return GridView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.7325,
                                                crossAxisSpacing: 15,
                                                mainAxisSpacing: 15),
                                            itemCount: book.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              animationController?.forward();
                                              return itemBuku(book[index], context, animationController!);
                                            });
                                    }
                                  },
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 30, bottom: 10),
                                child:
                                ZoomTapAnimation(
                                    child: GestureDetector(
                                        onTap: () {
                                          new Future.delayed(new Duration(milliseconds: 300), () {
                                            Navigator.push<dynamic>(
                                                context,
                                                MaterialPageRoute<dynamic>(
                                                  builder: (BuildContext context) => BookContentScreen(animationController: animationController),
                                                )
                                            );
                                          });
                                        },
                                        child:
                                        Text(
                                          "Lihat Selengkapnya",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            letterSpacing: 0.5,
                                            color: AppTheme.grey.withOpacity(0.7),
                                          ),
                                        )
                                    )
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 25, left: 20, right: 20),
                                height: 10,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0)
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.grey.withOpacity(0.2),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 2.0),
                          ],
                        ),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'SUMA',
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                                Text(
                                  'GAMES',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Mainkan games Suma',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'RobotoMono',
                                  color: Colors.black87.withOpacity(0.5),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child:
                                  Column(
                                    children: [
                                      ZoomTapAnimation(
                                        onTap: () {
                                          mainPuzzle(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          height: 150,
                                          width: double.infinity,
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.pink.shade50,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft: Radius.circular(10.0),
                                                bottomRight: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: AppTheme.grey.withOpacity(0.1),
                                                  offset: Offset(0.0, 1.0), //(x,y)
                                                  blurRadius: 0.5),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child:
                                            Image.asset(
                                              'assets/images/games_1.png',
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Text(
                                              "Puzzle",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14
                                              )
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child:
                                  Column(
                                    children: [
                                      ZoomTapAnimation(
                                        onTap: () {
                                          mainTICTAC(context);
                                        },
                                        child: Container(
                                          height: 150,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.teal.shade50,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft: Radius.circular(10.0),
                                                bottomRight: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: AppTheme.grey.withOpacity(0.1),
                                                  offset: Offset(0.0, 1.0), //(x,y)
                                                  blurRadius: 0.5),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child:
                                            Image.asset(
                                              'assets/images/games_2.png',
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                              "Tic Tac Toe",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14
                                              )
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 25, left: 20, right: 20),
                              height: 10,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0)
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),
            )
          );
      },
    );
  }
}

Widget itemBuku(BookData book, BuildContext context, AnimationController animationController) {
  return
    FadeInUp(
        delay : Duration(milliseconds: 100),
        child : FadeTransition(
          opacity: animationController,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - animationController.value), 0.0),
            child:
            ZoomTapAnimation(
              child: GestureDetector(
                onTap: () {
                  if(boolLogin == "false" && book.with_login == '1'){
                    new Future.delayed(new Duration(milliseconds: 300), () {
                      Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => LoginScreen(animationController: animationController),
                          )
                      );
                    });
                  } else {
                    new Future.delayed(new Duration(milliseconds: 300), () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => DetailBukuState(book: book)
                          )
                      );
                    });
                  }
                },
                // you can add more gestures...
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.2),
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 2.0),
                    ],
                  ),
                  child:
                  Column(
                    children: [
                      Wrap(
                        children: [
                          Stack(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                    Image.asset(
                                      'assets/images/no_image_2.png',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                    CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: 'https://suma.geloraaksara.co.id/uploads/cover_book/'+book.cover,
                                      placeholder: (context, url) => Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 30.0,
                                          width: 30.0,
                                          padding: EdgeInsets.all(3.0),
                                          child: CircularProgressIndicator(
                                            color: Colors.orange,
                                            strokeWidth: 2.5,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => new Icon(Icons.error),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                    Image.asset(
                                      'assets/images/no_image_blank_2.png',
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    height: 33,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade600,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0)),
                                    ),
                                  ),
                                  Positioned(
                                      right: 3,
                                      bottom: 8,
                                      child: new Align(
                                          alignment: FractionalOffset.bottomRight,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(7.0),
                                                    bottomLeft: Radius.circular(7.0),
                                                    bottomRight: Radius.circular(7.0),
                                                    topRight: Radius.circular(7.0)),
                                              ),
                                              margin: EdgeInsets.only(right: 5),
                                              padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                              child:
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(bottom: 1.5),
                                                    margin: EdgeInsets.only(right: 3),
                                                    alignment: Alignment.center,
                                                    child: Icon(FontAwesomeIcons.sheetPlastic,color: Colors.white, size: 11),
                                                  ),
                                                  Text(book.jumlah_halaman.toString(), style: TextStyle(color: Colors.white, fontSize: 12),),
                                                ],
                                              )
                                          )
                                      )
                                  ),
                                  Positioned(
                                      left: 3,
                                      bottom: 8,
                                      child: new Align(
                                          alignment: FractionalOffset.bottomLeft,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(7.0),
                                                    bottomLeft: Radius.circular(7.0),
                                                    bottomRight: Radius.circular(7.0),
                                                    topRight: Radius.circular(7.0)),
                                              ),
                                              margin: EdgeInsets.only(left: 5),
                                              padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                              child:
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(bottom: 1),
                                                    margin: EdgeInsets.only(right: 5),
                                                    alignment: Alignment.center,
                                                    child: Icon(FontAwesomeIcons.eye,color: Colors.white, size: 12),
                                                  ),
                                                  Text(book.viewer.toString(), style: TextStyle(color: Colors.white, fontSize: 12),),
                                                ],
                                              )
                                          )
                                      )
                                  ),
                                ],
                              ),
                              if(boolLogin == "false" && book.with_login == '1')...{
                                Container(
                                  padding: EdgeInsets.only(right: 5,top: 5),
                                  width: double.infinity,
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1.5),
                                        color: Colors.red
                                    ),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                )
                              }
                            ],
                          )
                        ],
                      ),
                    ],
                  ) ,
                )
              ),
            )
          ),
        )
    );
}

void mainPuzzle(var context) async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies();
  new Future.delayed(new Duration(milliseconds: 500), () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppGAME()));
  });
}

void mainTICTAC(var context) async {
  new Future.delayed(new Duration(milliseconds: 500), () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppTICTAC()));
  });
}

void _onDeveloping(var context, AnimationController animationController) {
  showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      transitionAnimationController: animationController,
      builder: (BuildContext context) {
        return
          SlideInUp(
            delay: Duration(milliseconds: 200),
            child:  Container(
              height: 190,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    topRight: Radius.circular(20.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.5),
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
                    margin: EdgeInsets.only(top: 3, bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 35),
                      Image.asset('assets/images/on_developing.png', height: 80, width: 80),
                      Padding(
                          padding: const EdgeInsets.only( left: 20),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text('Coming soon',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: 0.0,
                                        color: AppTheme.grey.withOpacity(0.6)
                                    )
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.6,
                                padding: EdgeInsets.only(right: 5),
                                child: Text('Maaf ya sahabat, games ini masih dalam tahap pengembangan',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        color: AppTheme.grey.withOpacity(0.6)
                                    )
                                ),
                              ),
                              SizedBox(width: 35),
                            ],
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                        width: MediaQuery.of(context).size.width,
                        child: GFButton(
                          color: Colors.grey,
                          textStyle: TextStyle(fontSize: 15),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          text: "Tutup",
                          blockButton: true,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
      }
  );
}

class CurvePainter extends CustomPainter {
  final double? angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle! + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
