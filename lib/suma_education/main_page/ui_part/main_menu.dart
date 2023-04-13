import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:intl/intl.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/main_page/games/puzzle/src/inject_dependencies.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/my_app.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/main.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/menu_data.dart';
import 'package:suma_education/suma_education/main_page/screen/book_content_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/book_konten_detail.dart';
import 'package:suma_education/suma_education/main_page/screen/interaktif_video_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/kreasi_video_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/tutorial_video_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'dart:math' as math;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

List<MenuData> listMenu = [];
SharedPreferences? prefs;
String namaUser = "";
String fotoProfil = "";
List<BookData> book = [];
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
        print(fotoProfil.toString());
      } else {
        print("error");
      }
    } catch (e) {
      print("error");
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
        var id = dataBookNew['data'][i]['id'];
        var judul = dataBookNew['data'][i]['judul'];
        var deskripsi = dataBookNew['data'][i]['deskripsi'];
        var cover = dataBookNew['data'][i]['cover'];
        var created_at = dataBookNew['data'][i]['created_at'];
        book.add(BookData(id, judul, deskripsi, cover, created_at));
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
                      left: 24, right: 24, top: 16),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 7, right: 7),
                          height: 100,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child:
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child:
                                      Stack(
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 150,
                                            margin: EdgeInsets.only(right: 15),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                              image: DecorationImage(
                                                  image: AssetImage('assets/images/default_profile.jpg'),
                                                  fit: BoxFit.fitWidth
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
                                                return Container(
                                                  width: 150,
                                                  height: 150,
                                                  margin: EdgeInsets.only(right: 15),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange,
                                                    shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                                    image: DecorationImage(
                                                        image: NetworkImage('https://suma.geloraaksara.co.id/assets/img/avatar/default.jpg'),
                                                        fit: BoxFit.fitWidth
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                if (snapshot.hasError)
                                                  return Container(
                                                    width: 150,
                                                    height: 150,
                                                    margin: EdgeInsets.only(right: 15),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                                      image: DecorationImage(
                                                          image: NetworkImage('https://suma.geloraaksara.co.id/assets/img/avatar/default.jpg'),
                                                          fit: BoxFit.fitWidth
                                                      ),
                                                    ),
                                                  );
                                                else
                                                  return
                                                    Container(
                                                      width: 150,
                                                      height: 150,
                                                      margin: EdgeInsets.only(right: 15),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                                        image: DecorationImage(
                                                            image: NetworkImage('https://suma.geloraaksara.co.id/assets/img/avatar/'+fotoProfil),
                                                            fit: BoxFit.fitWidth
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
                                      child: FutureBuilder<String>(
                                        future: getUser(), // function where you call your api
                                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Hallo, "+namaUser,
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'RobotoMono',
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white
                                                  ),
                                                ),
                                                AnimatedTextKit(
                                                  animatedTexts: [
                                                    TypewriterAnimatedText('Berkreasi bersama Suma',
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                      ),
                                                      speed: const Duration(milliseconds: 100),
                                                    ),
                                                    TypewriterAnimatedText('Menggambar dengan teknik baru',
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                      ),
                                                      speed: const Duration(milliseconds: 100),
                                                    ),
                                                    TypewriterAnimatedText('Cerita Suma menangkap ikan',
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                      ),
                                                      speed: const Duration(milliseconds: 100),
                                                    ),
                                                    TypewriterAnimatedText('Lindung suka pisang',
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                      ),
                                                      speed: const Duration(milliseconds: 100),
                                                    ),
                                                    TypewriterAnimatedText('Paima si paling tangguh',
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
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
                                          } else {
                                            if (snapshot.hasError)
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Hallo, "+namaUser,
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'RobotoMono',
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                  AnimatedTextKit(
                                                    animatedTexts: [
                                                      TypewriterAnimatedText('Berkreasi bersama Suma',
                                                        textStyle: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                        ),
                                                        speed: const Duration(milliseconds: 100),
                                                      ),
                                                      TypewriterAnimatedText('Menggambar dengan teknik baru',
                                                        textStyle: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                        ),
                                                        speed: const Duration(milliseconds: 100),
                                                      ),
                                                      TypewriterAnimatedText('Cerita Suma menangkap ikan',
                                                        textStyle: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                        ),
                                                        speed: const Duration(milliseconds: 100),
                                                      ),
                                                      TypewriterAnimatedText('Lindung suka pisang',
                                                        textStyle: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                        ),
                                                        speed: const Duration(milliseconds: 100),
                                                      ),
                                                      TypewriterAnimatedText('Paima si paling tangguh',
                                                        textStyle: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0,
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
                                                          fontSize: 20,
                                                          fontFamily: 'RobotoMono',
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                    AnimatedTextKit(
                                                      animatedTexts: [
                                                        TypewriterAnimatedText('Berkreasi bersama Suma',
                                                          textStyle: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                          ),
                                                          speed: const Duration(milliseconds: 100),
                                                        ),
                                                        TypewriterAnimatedText('Menggambar dengan teknik baru',
                                                          textStyle: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                          ),
                                                          speed: const Duration(milliseconds: 100),
                                                        ),
                                                        TypewriterAnimatedText('Cerita Suma menangkap ikan',
                                                          textStyle: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                          ),
                                                          speed: const Duration(milliseconds: 100),
                                                        ),
                                                        TypewriterAnimatedText('Lindung suka pisang',
                                                          textStyle: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                          ),
                                                          speed: const Duration(milliseconds: 100),
                                                        ),
                                                        TypewriterAnimatedText('Paima si paling tangguh',
                                                          textStyle: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.0,
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
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      Container(
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
                        margin: EdgeInsets.only(bottom: 10),
                        child:
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 7, bottom: 7, right: 9, left: 9),
                              child: StreamBuilder(
                                stream: Stream.periodic(const Duration(seconds: 1)),
                                builder: (context, snapshot) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: Image.asset(
                                            "assets/suma_education/time_main.png"),
                                      ),
                                      Text(
                                        DateFormat('kk:mm:ss').format(DateTime.now())+" "+DateTime.now().timeZoneName.toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          letterSpacing: 0.5,
                                          color: AppTheme.lightText,
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 0, right: 0,
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                child: SizedBox(
                                  height: 38,
                                  child: AspectRatio(
                                    aspectRatio: 1.714,
                                    child: Image.asset(
                                        "assets/suma_education/back.png"),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 25, bottom: 25, left: 20, right: 20),
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
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 2, right: 27,
                                                  child: Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 2, right: 17,
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
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
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 2, right: 22,
                                                  child: Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 2, right: 12,
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                              child: Text(
                                                  "Interaktif",
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
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 2, right: 20,
                                                  child: Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 2, right: 10,
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
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
                                )
                              ],
                            )
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(top: 25, bottom: 25, left: 20, right: 20),
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
                                      return SizedBox(
                                          height: MediaQuery.of(context).size.height*0.6,
                                          child: null
                                      );
                                    } else {
                                      if (snapshot.hasError)
                                        return GridView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.7427,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 20),
                                            itemCount: book.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              animationController?.forward();
                                              return itemBuku(book[index], context, animationController!);
                                            });
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
                                                        'Data tidak tersedia',
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
                                                        'Data peserta tidak tersedia',
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
                                                childAspectRatio: 0.7427,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 20),
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
                              )
                            ],
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(top: 25, bottom: 25, left: 20, right: 20),
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
                                          margin: EdgeInsets.only(right: 15, left: 10),
                                          height: 120,
                                          width: double.infinity,
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
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Text(
                                              "Puzzle",
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
                                          height: 120,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(left: 15, right: 10),
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
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                              "Tic Tac Toe",
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
        child :  FadeTransition(
          opacity: animationController,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - animationController.value), 0.0),
            child:
            ZoomTapAnimation(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => DetailBukuState(book: book)
                      )
                  );
                },
                // you can add more gestures...
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                    Container(
                      decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(9)),
                      child:
                      Column(
                        children: [
                          Wrap(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child:
                                    Image.asset(
                                      'assets/images/no_image_2.png',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child:
                                    Image.network(
                                      'https://suma.geloraaksara.co.id/uploads/cover_book/'+book.cover,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ) ,
                    )
                ),
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
