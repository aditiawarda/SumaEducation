import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_theme/app_theme.dart';

SharedPreferences? prefs;

String? dear = "";
String? ucapan = "";

class UserBio extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const UserBio({Key? key, this.animationController, this.animation})
      : super(key: key);

  Future <String> _getUcapan() async {
    String time = DateFormat('kk').format(DateTime.now());
    if(int.parse(time)>=5 && int.parse(time)<11){
      ucapan = "Selamat pagi,";
    } else if(int.parse(time)>=11 && int.parse(time)<15){
      ucapan = "Selamat siang,";
    } else if(int.parse(time)>=15 && int.parse(time)<18){
      ucapan = "Selamat sore,";
    } else if(int.parse(time)>=18 && int.parse(time)<=23){
      ucapan = "Selamat malam,";
    } else if(int.parse(time)>=0 && int.parse(time)<5){
      ucapan = "Selamat malam,";
    }

    return 'true';
  }

  Future <String> _getName() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;

    if(prefs!.getString("data_NIK").toString()=="2151010115" || prefs!.getString("data_NIK").toString()=="1504060711"){
      dear = "Ibu";
    } else if (prefs!.getString("data_NIK").toString()=="P2182" || prefs!.getString("data_NIK")=="M0015"){
      dear = "Bapak";
    } else {
      dear = "";
    }

    return 'true';
  }

  Future <String> _getDetail() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;

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
                      gradient: LinearGradient(colors: [
                        HexColor("#b6410e"),
                        HexColor("#e5983f")
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          topRight: Radius.circular(50.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.5),
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 3.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 23, bottom: 23),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child:
                            FutureBuilder<String>(
                              future: _getUcapan(),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text(
                                    ucapan!,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: AppTheme.white,
                                    ),
                                  );
                                } else {
                                  if (snapshot.hasError)
                                    return Text(
                                      ucapan!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                  else
                                    return Text(
                                      ucapan!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child:
                            FutureBuilder<String>(
                              future: _getName(),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  if(dear==""){
                                    return Text(prefs!.getString("data_NmKaryawan").toString(),
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
                                    return Text(
                                      dear!+" "+prefs!.getString("data_NmKaryawan").toString(),
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

                                } else {
                                  if (snapshot.hasError)
                                    if(dear==""){
                                      return Text(prefs!.getString("data_NmKaryawan").toString(),
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
                                      return Text(
                                        dear!+" "+prefs!.getString("data_NmKaryawan").toString(),
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
                                  else
                                  if(dear==""){
                                    return Text(prefs!.getString("data_NmKaryawan").toString(),
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
                                    return Text(
                                      dear!+" "+prefs!.getString("data_NmKaryawan").toString(),
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
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child:
                            FutureBuilder<String>(
                              future: _getDetail(),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  if(prefs!.getString("data_NIK").toString()=='2151010115'){
                                    return Text(
                                      "Direktur Utama PT Gelora Aksara Pratama",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                  } else if(prefs!.getString("data_NIK").toString()=='1504060711'){
                                    return Text(
                                      "Ka.Dept Akunting dan Keuangan",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                  } else if (prefs!.getString("data_NIK").toString()=='Dom' || prefs!.getString("data_NIK").toString()=='Asrel') {
                                    return Text(
                                      "SUMA",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      prefs!.getString("data_KdDept").toString()+" | "+ prefs!.getString("data_NmHeadDept").toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                  }
                                } else {
                                  if (snapshot.hasError)
                                    if(prefs!.getString("data_NIK").toString()=='2151010115'){
                                      return Text(
                                        "Direktur Utama PT Gelora Aksara Pratama",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          letterSpacing: 0.0,
                                          color: AppTheme.white,
                                        ),
                                      );
                                    } else if(prefs!.getString("data_NIK").toString()=='1504060711'){
                                      return Text(
                                        "Ka.Dept Akunting dan Keuangan",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          letterSpacing: 0.0,
                                          color: AppTheme.white,
                                        ),
                                      );
                                    } else if (prefs!.getString("data_NIK").toString()=='Dom' || prefs!.getString("data_NIK").toString()=='Asrel') {
                                      return Text(
                                        "SUMA",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          letterSpacing: 0.0,
                                          color: AppTheme.white,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        prefs!.getString("data_KdDept").toString()+" | "+ prefs!.getString("data_NmHeadDept").toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          letterSpacing: 0.0,
                                          color: AppTheme.white,
                                        ),
                                      );
                                    }
                                  else
                                  if(prefs!.getString("data_NIK").toString()=='2151010115'){
                                    return Text(
                                      "Direktur Utama PT Gelora Aksara Pratama",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                  } else if(prefs!.getString("data_NIK").toString()=='1504060711'){
                                    return Text(
                                      "Ka.Dept Akunting dan Keuangan",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                  } else if (prefs!.getString("data_NIK").toString()=='P2182' || prefs!.getString("data_NIK").toString()=='M0015') {
                                    return Text(
                                      "SUMA",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      prefs!.getString("data_KdDept").toString()+" | "+ prefs!.getString("data_NmHeadDept").toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    );
                                  }
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
