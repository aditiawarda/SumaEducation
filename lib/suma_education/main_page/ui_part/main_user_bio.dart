import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_theme/app_theme.dart';

SharedPreferences? prefs;

String? namaUser = "";
String? fotoProfil = "";

class UserBio extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const UserBio({Key? key, this.animationController, this.animation})
      : super(key: key);

  Future<String> getUser() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return
          FadeInUp(
            delay: Duration(milliseconds: 500),
            child: FadeTransition(
              opacity: animation!,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - animation!.value), 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 32, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/bg_header_img.png"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.5),
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 3.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 23),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder<String>(
                            future: getUser(),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(
                                  width: 80,
                                  height: 80,
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
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                      image: DecorationImage(
                                          image: NetworkImage('https://suma.geloraaksara.co.id/assets/img/avatar/default.jpg'),
                                          fit: BoxFit.fitWidth
                                      ),
                                    ),
                                  );
                                else
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                      image: DecorationImage(
                                          image: NetworkImage('https://suma.geloraaksara.co.id/assets/img/avatar/'+fotoProfil!),
                                          fit: BoxFit.fitWidth
                                      ),
                                    ),
                                  );
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child:
                            FutureBuilder<String>(
                              future: getUser(),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Text(namaUser!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                } else {
                                  if (snapshot.hasError)
                                    return Text(namaUser!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                  else
                                    return Text(namaUser!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
      },
    );
  }
}
