// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:ripple_animation/ripple_animation.dart';

import '../screen/proposal_all_list.dart';

String? totalAjuan = "0";
String? dataDiterima = "0";
String? dataRevisi = "0";
String? dataDitolak = "0";
String? tahun = "0000";
double widthBarDiterima = 0;
double widthBarRevisi = 0;
double widthBarDitolak = 0;
int? secondsRemaining = 60;
bool enableResend = false;
late Timer timer;

class ProposalStatistics extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ProposalStatistics(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  Future <String>_getStatisticProposal() async {
    try {
      var response = await http.post(
          Uri.parse("https://proposal.sumasistem.co.id/api/proposal_statistik"),
          body: {
            "request": "request",
          });
      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        totalAjuan = json["total_ajuan"];
        dataDiterima = json["diterima"];
        dataRevisi = json["revisi"];
        dataDitolak = json["ditolak"];
        tahun = json["tahun"];

        if(totalAjuan!="0"){
          widthBarDiterima = ((int.parse(dataDiterima!)/int.parse(totalAjuan!))*100)-((int.parse(dataDiterima!)*16)/100);
          widthBarRevisi = ((int.parse(dataRevisi!)/int.parse(totalAjuan!))*100)-((int.parse(dataRevisi!)*16)/100);
          widthBarDitolak = ((int.parse(dataDitolak!)/int.parse(totalAjuan!))*100)-((int.parse(dataDitolak!)*16)/100);
        } else {
          widthBarDiterima = 0;
          widthBarRevisi = 0;
          widthBarDitolak = 0;
        }

      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String currentDateDay = DateFormat('dd').format(now);
    String currentDateMonth = DateFormat('MM').format(now);
    String currentDateYear = DateFormat('yyyy').format(now);
    final fullWidth = MediaQuery.of(context).size.width;
    final widthPart = fullWidth * 0.5 / 2.7;

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
                      left: 24, right: 24, top: 32, bottom: 18),
                  child:
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(50.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.3),
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 3.0),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          height: 48,
                                          width: 2,
                                          decoration: BoxDecoration(
                                            color: HexColor('#87A0E5')
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4, bottom: 2),
                                                child: Text(
                                                  'Per tanggal',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                    AppTheme.fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    letterSpacing: -0.1,
                                                    color: AppTheme.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 28,
                                                    height: 28,
                                                    child: Image.asset(
                                                        "assets/suma_education/date.png"),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 4, bottom: 3),
                                                    child:
                                                    Text(
                                                      '${(int.parse(currentDateDay) * animation!.value).toInt()}'+'/'+'${(int.parse(currentDateMonth) * animation!.value).toInt()}'+'/'+'${(int.parse(currentDateYear) * animation!.value).toInt()}',
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily:
                                                        AppTheme
                                                            .fontName,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontSize: 16,
                                                        color: AppTheme
                                                            .darkerText,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          height: 48,
                                          width: 2,
                                          decoration: BoxDecoration(
                                            color: HexColor('#F56E98')
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4, bottom: 2),
                                                child: Text(
                                                  'Jam',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                    AppTheme.fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    letterSpacing: -0.1,
                                                    color: AppTheme.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 28,
                                                    height: 28,
                                                    child: Image.asset(
                                                        "assets/suma_education/time.png"),
                                                  ),
                                                  Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                      child:
                                                      StreamBuilder(
                                                        stream: Stream.periodic(const Duration(seconds: 1)),
                                                        builder: (context, snapshot) {
                                                          return Center(
                                                            child:
                                                            Text(
                                                              DateFormat('kk:mm').format(DateTime.now())+' '+DateTime.now().timeZoneName.toString(),
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                AppTheme
                                                                    .fontName,
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                fontSize: 16,
                                                                color: AppTheme
                                                                    .darkerText,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Positioned(
                                    right: 10, top: 10,
                                    child:  InkWell(
                                      onTap: (){
                                        Navigator.push<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) => ProposalAllList(animationController: animationController),
                                            )
                                        );
                                      },
                                      child: Center(
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child:
                                              Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.white,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(100.0),
                                                  ),
                                                ),
                                                child: RippleAnimation(
                                                  repeat: true,
                                                  color: Colors.orange.shade100.withOpacity(0.8),
                                                  minRadius: 30,
                                                  ripplesCount: 2, child: null,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(100.0),
                                                  ),
                                                  border: new Border.all(
                                                      width: 4,
                                                      color: AppTheme
                                                          .nearlyDarkOrange
                                                          .withOpacity(0.2)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    FutureBuilder<String>(
                                                      future: _getStatisticProposal(), // function where you call your api
                                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return Text(
                                                            '${(int.parse(totalAjuan!) * animation!.value).toInt()}',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                              AppTheme.fontName,
                                                              fontWeight: FontWeight.normal,
                                                              fontSize: 35,
                                                              letterSpacing: 0.0,
                                                              color: AppTheme
                                                                  .nearlyDarkOrange,
                                                            ),
                                                          );
                                                        } else {
                                                          if (snapshot.hasError)
                                                            return Text(
                                                              '${(int.parse(totalAjuan!) * animation!.value).toInt()}',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                AppTheme.fontName,
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 35,
                                                                letterSpacing: 0.0,
                                                                color: AppTheme
                                                                    .nearlyDarkOrange,
                                                              ),
                                                            );
                                                          else
                                                            return Text(
                                                              '${(int.parse(totalAjuan!) * animation!.value).toInt()}',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                AppTheme.fontName,
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 35,
                                                                letterSpacing: 0.0,
                                                                color: AppTheme
                                                                    .nearlyDarkOrange,
                                                              ),
                                                            ); // snapshot.data  :- get your object which is pass from your downloadData() function
                                                        }
                                                      },
                                                    ),
                                                    Text(
                                                      'Ajuan',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                        AppTheme.fontName,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                        letterSpacing: 0.0,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: CustomPaint(
                                                painter: CurvePainter(
                                                    colors: [
                                                      HexColor("#b6410e"),
                                                      HexColor("#e5983f"),
                                                      HexColor("#e5983f")
                                                    ],
                                                    angle: 140 +
                                                        (360 - 140) *
                                                            (1.0 - animation!.value)),
                                                child: SizedBox(
                                                  width: 108,
                                                  height: 108,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 8, bottom: 8),
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 8, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: widthPart,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Diterima',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: AppTheme.darkText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Container(
                                        height: 4,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color:
                                          HexColor('#47c12a').withOpacity(0.2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            FutureBuilder<String>(
                                              future: _getStatisticProposal(), // function where you call your api
                                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Container(
                                                    width: ((widthBarDiterima.toInt() / 1.45) * animation!.value),
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(colors: [
                                                        HexColor('#47c12a'),
                                                        HexColor('#47c12a')
                                                            .withOpacity(0.5),
                                                      ]),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                    ),
                                                  );
                                                } else {
                                                  if (snapshot.hasError)
                                                    return Container(
                                                      width: ((widthBarDiterima.toInt() / 1.45) * animation!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(colors: [
                                                          HexColor('#47c12a'),
                                                          HexColor('#47c12a')
                                                              .withOpacity(0.5),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    );
                                                  else
                                                    return Container(
                                                      width: ((widthBarDiterima.toInt() / 1.45) * animation!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(colors: [
                                                          HexColor('#47c12a'),
                                                          HexColor('#47c12a')
                                                              .withOpacity(0.5),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    );  // snapshot.data  :- get your object which is pass from your downloadData() function
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: FutureBuilder<String>(
                                        future: _getStatisticProposal(), // function where you call your api
                                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              dataDiterima!+' Proposal',
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
                                                dataDiterima!+' Proposal',
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
                                                dataDiterima!+' Proposal',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Revisi',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: AppTheme.darkText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Container(
                                        height: 4,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: HexColor('#d8cc4b')
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            FutureBuilder<String>(
                                              future: _getStatisticProposal(), // function where you call your api
                                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Container(
                                                    width: ((widthBarRevisi.toInt() / 1.45) *
                                                        animationController!.value),
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                      LinearGradient(colors: [
                                                        HexColor('#d8cc4b')
                                                            .withOpacity(0.1),
                                                        HexColor('#d8cc4b'),
                                                      ]),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                    ),
                                                  );
                                                } else {
                                                  if (snapshot.hasError)
                                                    return Container(
                                                      width: ((widthBarRevisi.toInt() / 1.45) *
                                                          animationController!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                        LinearGradient(colors: [
                                                          HexColor('#d8cc4b')
                                                              .withOpacity(0.1),
                                                          HexColor('#d8cc4b'),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    );
                                                  else
                                                    return Container(
                                                      width: ((widthBarRevisi.toInt() / 1.45) *
                                                          animationController!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                        LinearGradient(colors: [
                                                          HexColor('#d8cc4b')
                                                              .withOpacity(0.1),
                                                          HexColor('#d8cc4b'),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    );  // snapshot.data  :- get your object which is pass from your downloadData() function
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: FutureBuilder<String>(
                                        future: _getStatisticProposal(), // function where you call your api
                                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              dataRevisi!+' Proposal',
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
                                                dataRevisi!+' Proposal',
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
                                                dataRevisi!+' Proposal',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Ditolak',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: AppTheme.darkText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 0, top: 4),
                                      child: Container(
                                        height: 4,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: HexColor('#cf3f2d')
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            FutureBuilder<String>(
                                              future: _getStatisticProposal(), // function where you call your api
                                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Container(
                                                    width: ((widthBarDitolak.toInt() / 1.45) *
                                                        animationController!.value),
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                      LinearGradient(colors: [
                                                        HexColor('#cf3f2d')
                                                            .withOpacity(0.1),
                                                        HexColor('#cf3f2d'),
                                                      ]),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                    ),
                                                  );
                                                } else {
                                                  if (snapshot.hasError)
                                                    return Container(
                                                      width: ((widthBarDitolak.toInt() / 1.45) *
                                                          animationController!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                        LinearGradient(colors: [
                                                          HexColor('#cf3f2d')
                                                              .withOpacity(0.1),
                                                          HexColor('#cf3f2d'),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    );
                                                  else
                                                    return Container(
                                                      width: ((widthBarDitolak.toInt() / 1.45) *
                                                          animationController!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                        LinearGradient(colors: [
                                                          HexColor('#cf3f2d')
                                                              .withOpacity(0.1),
                                                          HexColor('#cf3f2d'),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    );  // snapshot.data  :- get your object which is pass from your downloadData() function
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: FutureBuilder<String>(
                                        future: _getStatisticProposal(), // function where you call your api
                                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              dataDitolak!+' Proposal',
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
                                                dataDitolak!+' Proposal',
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
                                                dataDitolak!+' Proposal',
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
