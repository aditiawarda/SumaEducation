// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_agenda.dart';
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_all_approved.dart';
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_all_disapear.dart';
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_all_waiting.dart';
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_detail_view.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_all_list.dart';
import 'dart:math' as math;
import 'package:ripple_animation/ripple_animation.dart';


String? approved = "0";
String? waiting = "0";
String? dissapear = "0";

String? id_appointment = "";
String? date = "0000-00-00";
String? start_date = "00:00:00";
String? end_date = "00:00:00";
String? deskripsi = "";

String? dataDitolak = "0";
String? tahun = "0000";
double widthBarDiterima = 0;
double widthBarRevisi = 0;
double widthBarDitolak = 0;
int? secondsRemaining = 60;
bool enableResend = false;
late Timer timer;

class AppointmentStatistics extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const AppointmentStatistics(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  Future <String>_getStatisticAppointment() async {
    try {
      var response = await http.post(
          Uri.parse("https://appointment.geloraaksara.co.id/api/appointment_statistic"),
          body: {
            "request": "request",
          });
      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        approved = json["approved"];
        waiting = json["waiting"];
        dissapear = json["dissapear"];
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  Future <String>_getAgendaTerdekat() async {
    try {
      var response = await http.post(
          Uri.parse("https://appointment.geloraaksara.co.id/api/oncoming_agenda"),
          body: {
            "nik": "2151010115",
          });
      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        id_appointment = json["data"]["id"].toString();
        date = json["data"]["date"].toString();
        start_date = json["data"]["start_date"].toString();
        end_date = json["data"]["end_date"].toString();
        deskripsi = json["data"]["deskripsi"].toString();
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    final widthPart = fullWidth * 0.5 / 2.7;
    String time = DateFormat('kk').format(DateTime.now());
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
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 40, bottom: 18),
                  child:
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                  topRight: Radius.circular(40.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.3),
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 3.0),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      width: 2,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.4),
                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 13,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: 10, bottom: 10),
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            if(int.parse(time)>=5 && int.parse(time)<11)...{
                                              Text("Selamat pagi,",
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontSize: 12,
                                                  letterSpacing: 0.5,
                                                  color: AppTheme.lightText,
                                                ),
                                              ),
                                            } else if(int.parse(time)>=11 && int.parse(time)<15)...{
                                              Text("Selamat siang,",
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontSize: 12,
                                                  letterSpacing: 0.5,
                                                  color: AppTheme.lightText,
                                                ),
                                              ),
                                            } else if(int.parse(time)>=15 && int.parse(time)<18)...{
                                              Text("Selamat sore,",
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontSize: 12,
                                                  letterSpacing: 0.5,
                                                  color: AppTheme.lightText,
                                                ),
                                              ),
                                            } else if(int.parse(time)>=18 && int.parse(time)<=23)...{
                                              Text("Selamat malam,",
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontSize: 12,
                                                  letterSpacing: 0.5,
                                                  color: AppTheme.lightText,
                                                ),
                                              ),
                                            } else if(int.parse(time)>=0 && int.parse(time)<5)...{
                                              Text("Selamat malam,",
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontSize: 12,
                                                  letterSpacing: 0.5,
                                                  color: AppTheme.lightText,
                                                ),
                                              ),
                                            },

                                            Text("Ibu Deborah Hutauruk",
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: 0.5,
                                                color: AppTheme.lightText.withOpacity(0.8),
                                              ),
                                            ),

                                            Text("Direktur Utama PT Gelora Aksara Pratama",
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                letterSpacing: 0.5,
                                                color: AppTheme.lightText.withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        )

                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                  child:
                                      Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 24, right: 24, top: 12),
                                            child: FutureBuilder<String>(
                                              future: _getAgendaTerdekat(), // function where you call your api
                                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return SizedBox();
                                                } else {
                                                  if (snapshot.hasError)
                                                    return SizedBox();
                                                  else
                                                    if(deskripsi!="")
                                                      return InkWell(
                                                          onTap: (){
                                                            new Future.delayed(new Duration(milliseconds: 300), () {
                                                              Navigator.push<dynamic>(
                                                                  context,
                                                                  MaterialPageRoute<dynamic>(
                                                                    builder: (BuildContext context) => AppointmentDetail(animationController: animationController, appointmentId: id_appointment!),
                                                                  )
                                                              );
                                                            });
                                                          },
                                                          child: FadeInUp(
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.only(bottom: 25),
                                                                  padding: EdgeInsets.only(left: 15, right: 15, top: 13, bottom: 17),
                                                                  decoration: BoxDecoration(
                                                                    boxShadow: <BoxShadow>[
                                                                      BoxShadow(
                                                                          color: AppTheme.grey.withOpacity(0.3),
                                                                          offset: Offset(0.0, 1.0), //(x,y)
                                                                          blurRadius: 3.0),
                                                                    ],
                                                                    gradient: LinearGradient(
                                                                      colors: <HexColor>[
                                                                        HexColor("#FA7D82"),
                                                                        HexColor("#FFB295"),
                                                                      ],
                                                                      begin: Alignment.topLeft,
                                                                      end: Alignment.bottomRight,
                                                                    ),
                                                                    borderRadius: const BorderRadius.only(
                                                                      bottomRight: Radius.circular(8.0),
                                                                      bottomLeft: Radius.circular(8.0),
                                                                      topLeft: Radius.circular(8.0),
                                                                      topRight: Radius.circular(30.0),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.only(
                                                                            left: 35, right: 8, top: 8, bottom: 8),
                                                                        child:
                                                                        Text("Agenda Terdekat",
                                                                          textAlign: TextAlign.left,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                            fontFamily: AppTheme.fontName,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 15,
                                                                            letterSpacing: 0.5,
                                                                            color: Colors.white.withOpacity(0.9),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left: 5, right: 5, top: 10, bottom: 8),
                                                                        child: Container(
                                                                          height: 1.5,
                                                                          decoration: BoxDecoration(
                                                                            color: AppTheme.background.withOpacity(0.5),
                                                                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 6,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width: 6,
                                                                          ),
                                                                          SizedBox(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child: Image.asset(
                                                                                "assets/suma_education/date.png"),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 6,
                                                                          ),
                                                                          Text(
                                                                            date!.substring(8, 10)+'/'+date!.substring(5, 7)+'/'+date!.substring(0, 4),
                                                                            textAlign: TextAlign.left,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                              fontFamily: AppTheme.fontName,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                              letterSpacing: 0.5,
                                                                              color: AppTheme.white.withOpacity(0.8),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width: 6,
                                                                          ),
                                                                          SizedBox(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child: Image.asset(
                                                                                "assets/suma_education/time.png"),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 6,
                                                                          ),
                                                                          Text(
                                                                            start_date!+" s.d. "+end_date!,
                                                                            textAlign: TextAlign.left,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                              fontFamily: AppTheme.fontName,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                              letterSpacing: 0.5,
                                                                              color: AppTheme.white.withOpacity(0.8),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left: 40, right: 5, top: 8, bottom: 8),
                                                                        child: Container(
                                                                          height: 1.5,
                                                                          decoration: BoxDecoration(
                                                                            color: AppTheme.background.withOpacity(0.5),
                                                                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding: EdgeInsets.only(left: 42, top: 5, bottom: 3, right: 5),
                                                                        child:
                                                                        Text(deskripsi!,
                                                                          textAlign: TextAlign.left,
                                                                          style: TextStyle(
                                                                            fontFamily: AppTheme.fontName,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 14,
                                                                            letterSpacing: 0.5,
                                                                            color: AppTheme.white.withOpacity(0.8),
                                                                          ),
                                                                        ),
                                                                      )

                                                                    ],
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 20,
                                                                  left: 17,
                                                                  child: Container(
                                                                    width: 20,
                                                                    height: 20,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.redAccent,
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Stack(
                                                                      alignment: Alignment.center,
                                                                      children: [
                                                                        RippleAnimation(
                                                                          repeat: true,
                                                                          color: Colors.redAccent,
                                                                          minRadius: 20,
                                                                          ripplesCount: 6, child: null,
                                                                        ),
                                                                        Icon(Icons.notifications,
                                                                          size: 13,
                                                                          color: Colors.white.withOpacity(0.7),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          )
                                                      );
                                                    else
                                                      return SizedBox();
                                                }
                                              },
                                            ),
                                          ),
                                          FutureBuilder<String>(
                                            future: _getAgendaTerdekat(), // function where you call your api
                                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return SizedBox();
                                              } else {
                                                if (snapshot.hasError)
                                                  return SizedBox();
                                                else
                                                if(deskripsi!="")
                                                  return Positioned(
                                                    right: 15,
                                                    top: 3,
                                                    child: FadeInUp(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius.circular(10.0),
                                                            bottomLeft: Radius.circular(10.0),
                                                            bottomRight: Radius.circular(10.0),
                                                            topRight: Radius.circular(50.0)),
                                                        child: SizedBox(
                                                          height: 70,
                                                          child: AspectRatio(
                                                            aspectRatio: 1.714,
                                                            child: Image.asset(
                                                                "assets/suma_education/on_coming.png"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                else
                                                  return SizedBox();
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            padding: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.3),
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 3.0),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 7, bottom: 5),
                                  child: Text("Appointment Statistics",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: 0.5,
                                      color: AppTheme.lightText.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 24, top: 12, bottom: 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: widthPart,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: (){
                                                Navigator.push<dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext context) => AppointmentAllApproved(animationController: animationController),
                                                    )
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 75,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(100.0),
                                                      ),
                                                    ),
                                                    child: RippleAnimation(
                                                      repeat: true,
                                                      color: Colors.green.shade100.withOpacity(0.8),
                                                      minRadius: 20,
                                                      ripplesCount: 2, child: null,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 75,
                                                    height: 75,
                                                    margin: EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(100.0),
                                                      ),
                                                      border: new Border.all(
                                                          width: 4,
                                                          color: Colors.green.withOpacity(0.4)),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        FutureBuilder<String>(
                                                          future: _getStatisticAppointment(), // function where you call your api
                                                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                              return Text(
                                                                '${(int.parse(approved!) * animation!.value).toInt()}',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                  AppTheme.fontName,
                                                                  fontWeight: FontWeight.normal,
                                                                  fontSize: 35,
                                                                  letterSpacing: 0.0,
                                                                  color: Colors.green.withOpacity(0.8),
                                                                ),
                                                              );
                                                            } else {
                                                              if (snapshot.hasError)
                                                                return Text(
                                                                  '${(int.parse(approved!) * animation!.value).toInt()}',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    AppTheme.fontName,
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 35,
                                                                    letterSpacing: 0.0,
                                                                    color: Colors.green.withOpacity(0.8),
                                                                  ),
                                                                );
                                                              else
                                                                return Text(
                                                                  '${(int.parse(approved!) * animation!.value).toInt()}',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    AppTheme.fontName,
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 35,
                                                                    letterSpacing: 0.0,
                                                                    color: Colors.green.withOpacity(0.8),
                                                                  ),
                                                                ); // snapshot.data  :- get your object which is pass from your downloadData() function
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Text(
                                              'Approved',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: -0.2,
                                                color: AppTheme.darkText.withOpacity(0.8),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: FutureBuilder<String>(
                                                future: _getStatisticAppointment(), // function where you call your api
                                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Text(
                                                      approved!+' Data',
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        color:
                                                        AppTheme.grey.withOpacity(0.5),
                                                      ),
                                                    );
                                                  } else {
                                                    if (snapshot.hasError)
                                                      return Text(
                                                        approved!+' Data',
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                          color:
                                                          AppTheme.grey.withOpacity(0.5),
                                                        ),
                                                      );
                                                    else
                                                      return Text(
                                                        approved!+' Data',
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                          color:
                                                          AppTheme.grey.withOpacity(0.5),
                                                        ),
                                                      );  // snapshot.data  :- get your object which is pass from your downloadData() function
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: widthPart,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[

                                            InkWell(
                                              onTap: (){
                                                Navigator.push<dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext context) => AppointmentAllWaiting(animationController: animationController),
                                                    )
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 75,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(100.0),
                                                      ),
                                                    ),
                                                    child: RippleAnimation(
                                                      repeat: true,
                                                      color: Colors.yellow.shade300.withOpacity(0.1),
                                                      minRadius: 20,
                                                      ripplesCount: 2, child: null,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 75,
                                                    height: 75,
                                                    margin: EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(100.0),
                                                      ),
                                                      border: new Border.all(
                                                          width: 4,
                                                          color: Colors.yellow.shade700.withOpacity(0.4)),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        FutureBuilder<String>(
                                                          future: _getStatisticAppointment(), // function where you call your api
                                                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                              return Text(
                                                                '${(int.parse(waiting!) * animation!.value).toInt()}',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                  AppTheme.fontName,
                                                                  fontWeight: FontWeight.normal,
                                                                  fontSize: 35,
                                                                  letterSpacing: 0.0,
                                                                  color: Colors.yellow.shade700.withOpacity(1),
                                                                ),
                                                              );
                                                            } else {
                                                              if (snapshot.hasError)
                                                                return Text(
                                                                  '${(int.parse(waiting!) * animation!.value).toInt()}',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    AppTheme.fontName,
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 35,
                                                                    letterSpacing: 0.0,
                                                                    color: Colors.yellow.shade700.withOpacity(1),
                                                                  ),
                                                                );
                                                              else
                                                                return Text(
                                                                  '${(int.parse(waiting!) * animation!.value).toInt()}',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    AppTheme.fontName,
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 35,
                                                                    letterSpacing: 0.0,
                                                                    color: Colors.yellow.shade700.withOpacity(1),
                                                                  ),
                                                                ); // snapshot.data  :- get your object which is pass from your downloadData() function
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Text(
                                              'Waiting',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: -0.2,
                                                color: AppTheme.darkText.withOpacity(0.8),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: FutureBuilder<String>(
                                                future: _getStatisticAppointment(), // function where you call your api
                                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Text(
                                                      waiting!+' Data',
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    );
                                                  } else {
                                                    if (snapshot.hasError)
                                                      return Text(
                                                        waiting!+' Data',
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                          color:
                                                          AppTheme.grey.withOpacity(0.5),
                                                        ),
                                                      );
                                                    else
                                                      return Text(
                                                        waiting!+' Data',
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                          color:
                                                          AppTheme.grey.withOpacity(0.5),
                                                        ),
                                                      );  // snapshot.data  :- get your object which is pass from your downloadData() function
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: widthPart,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[

                                            InkWell(
                                              onTap: (){
                                                Navigator.push<dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext context) => AppointmentAllDisapear(animationController: animationController),
                                                    )
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 75,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(100.0),
                                                      ),
                                                    ),
                                                    child: RippleAnimation(
                                                      repeat: true,
                                                      color: Colors.red.shade100,
                                                      minRadius: 20,
                                                      ripplesCount: 2, child: null,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 75,
                                                    height: 75,
                                                    margin: EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(100.0),
                                                      ),
                                                      border: new Border.all(
                                                          width: 4,
                                                          color: Colors.red.withOpacity(0.4)),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        FutureBuilder<String>(
                                                          future: _getStatisticAppointment(), // function where you call your api
                                                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                              return Text(
                                                                '${(int.parse(dissapear!) * animation!.value).toInt()}',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                  AppTheme.fontName,
                                                                  fontWeight: FontWeight.normal,
                                                                  fontSize: 35,
                                                                  letterSpacing: 0.0,
                                                                  color: Colors.red.withOpacity(0.8),
                                                                ),
                                                              );
                                                            } else {
                                                              if (snapshot.hasError)
                                                                return Text(
                                                                  '${(int.parse(dissapear!) * animation!.value).toInt()}',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    AppTheme.fontName,
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 35,
                                                                    letterSpacing: 0.0,
                                                                    color: Colors.red.withOpacity(0.8),
                                                                  ),
                                                                );
                                                              else
                                                                return Text(
                                                                  '${(int.parse(dissapear!) * animation!.value).toInt()}',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    AppTheme.fontName,
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 35,
                                                                    letterSpacing: 0.0,
                                                                    color: Colors.red.withOpacity(0.8),
                                                                  ),
                                                                ); // snapshot.data  :- get your object which is pass from your downloadData() function
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Text(
                                              'Disappear',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: -0.2,
                                                color: AppTheme.darkText.withOpacity(0.8),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: FutureBuilder<String>(
                                                future: _getStatisticAppointment(), // function where you call your api
                                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Text(
                                                      dissapear!+' Data',
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    );
                                                  } else {
                                                    if (snapshot.hasError)
                                                      return Text(
                                                        dissapear!+' Data',
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                          color:
                                                          AppTheme.grey.withOpacity(0.5),
                                                        ),
                                                      );
                                                    else
                                                      return Text(
                                                        dissapear!+' Data',
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                          color:
                                                          AppTheme.grey.withOpacity(0.5),
                                                        ),
                                                      );  // snapshot.data  :- get your object which is pass from your downloadData() function
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => AppointmentAgenda(animationController: animationController),
                                  )
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 15),
                              padding: EdgeInsets.only(top: 15),
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                gradient: LinearGradient(
                                  colors: <HexColor>[
                                    HexColor("#f2ad45"),
                                    HexColor("#f4b25f"),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.3),
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 3.0),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text("Calendar Agenda",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        letterSpacing: 0.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                ),
              ),
            )
          );
      },
    );
  }
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
