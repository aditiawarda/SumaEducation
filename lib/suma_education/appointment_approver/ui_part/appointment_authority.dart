// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:intl/intl.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_all_approved.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_revision.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

SharedPreferences? prefs;

class AppointmentAuthority extends StatefulWidget {
  const AppointmentAuthority(
      {Key? key,
        this.mainScreenAnimationController,
        this.mainScreenAnimation,
        this.IdRequest,
      })
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? IdRequest;
  @override
  _AppointmentAuthorityState createState() => _AppointmentAuthorityState();
}

class _AppointmentAuthorityState extends State<AppointmentAuthority>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    getUser();
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  void action() async {
    prefs = await _prefs;
    try {
      var response = await http.post(
          Uri.parse("https://appointment.geloraaksara.co.id/api/approve_func"),
          body: {
            "id_request": widget.IdRequest,
          });
      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
          await Future.delayed(Duration(milliseconds: 500));
          await CoolAlert.show(
              context: context,
              borderRadius: 25,
              type: CoolAlertType.success,
              backgroundColor: Colors.lightGreen.shade50,
              title: 'Diterima!',
              text: "Appointment berhasil diterima",
              confirmBtnText: 'OK',
              width: 30,
              loopAnimation: true,
              animType: CoolAlertAnimType.scale,
              confirmBtnColor: Colors.green.shade300,
              onConfirmBtnTap: (){
                setState(() {
                  new Future.delayed(new Duration(milliseconds: 500), () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => AppointmentAllApproved(animationController: widget.mainScreenAnimationController),
                        )
                    );
                  });
                });
                Navigator.of(context, rootNavigator: true).pop('dialog');
              }
          );
      } else {
          await Future.delayed(Duration(milliseconds: 500));
          await CoolAlert.show(
            context: context,
            borderRadius: 25,
            type: CoolAlertType.error,
            backgroundColor: Colors.red.shade50,
            title: 'Oops...',
            text: "Terjadi kesalahan",
            confirmBtnText: 'OK',
            width: 30,
            loopAnimation: true,
            animType: CoolAlertAnimType.scale,
            confirmBtnColor: Colors.red.shade300,
          );
      }
    } catch (e) {
        await Future.delayed(Duration(milliseconds: 500));
        await CoolAlert.show(
          context: context,
          borderRadius: 25,
          type: CoolAlertType.error,
          backgroundColor: Colors.red.shade50,
          title: 'Oops...',
          text: "Terjadi kesalahan",
          confirmBtnText: 'OK',
          width: 30,
          loopAnimation: true,
          animType: CoolAlertAnimType.scale,
          confirmBtnColor: Colors.red.shade300,
        );
    }
  }

  Future<String> getUser() async {
    prefs = await _prefs;
    print(prefs!.getString('IdUser'));
    return 'true';
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void actionApproval(String key) {
    if(key=="revisi"){
      CoolAlert.show(
          context: context,
          title: 'Perhatian',
          backgroundColor: Colors.lightBlue.shade50,
          borderRadius: 25,
          type: CoolAlertType.confirm,
          text: 'Apakah anda yakin untuk revisi jadwal?',
          confirmBtnText: 'OK',
          cancelBtnText: 'Batal',
          animType: CoolAlertAnimType.scale,
          width: 30,
          loopAnimation: true,
          confirmBtnColor: Colors.orange.shade300,
          onConfirmBtnTap: (){
            Navigator.of(context, rootNavigator: true).pop('dialog');

          }
      );
    } else if(key=="terima"){
      CoolAlert.show(
          context: context,
          title: 'Perhatian',
          backgroundColor: Colors.lightBlue.shade50,
          borderRadius: 25,
          type: CoolAlertType.confirm,
          text: 'Apakah anda yakin untuk terima jadwal?',
          confirmBtnText: 'OK',
          cancelBtnText: 'Batal',
          animType: CoolAlertAnimType.scale,
          width: 30,
          loopAnimation: true,
          confirmBtnColor: Colors.green.shade300,
          onConfirmBtnTap: (){
            Navigator.of(context, rootNavigator: true).pop('dialog');
            action();
          }
      );
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    final widthButton = fullWidth * 0.5 / 2.7;
    return
      AnimatedBuilder(
        animation: widget.mainScreenAnimationController!,
        builder: (BuildContext context, Widget? child) {
          return
            FadeInUp(
               delay: Duration(milliseconds: 500),
               child: FadeTransition(
                  opacity: widget.mainScreenAnimation!,
                  child: new Transform(
                    transform: new Matrix4.translationValues(
                        0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 15, bottom: 5),
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
                                color: AppTheme.grey.withOpacity(0.5),
                                offset: Offset(1.1, 1.0),
                                blurRadius: 5.0),
                          ],
                        ),
                        child: FutureBuilder<String>(
                          future: getUser(),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(width: double.infinity);
                            } else {
                              if (snapshot.hasError)
                                return SizedBox(width: double.infinity);
                              else
                                return Column(
                                  children: <Widget>[
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 16, left: 16, right: 24),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 4, bottom: 3),
                                                    child: Text(
                                                      'Persetujuan :',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15,
                                                          color: Colors.grey
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.access_time,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                        size: 16,
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(left: 4.0),
                                                        child:
                                                        StreamBuilder(
                                                            stream: Stream.periodic(const Duration(seconds: 1)),
                                                            builder: (context, snapshot) {
                                                              return Text(
                                                                "Hari ini, "+DateFormat('kk:mm').format(DateTime.now())+" "+DateTime.now().timeZoneName.toString(),
                                                                textAlign: TextAlign.right,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    AppTheme.fontName,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 14,
                                                                    letterSpacing: 0.0,
                                                                    color: AppTheme.grey
                                                                        .withOpacity(0.5)),
                                                              );
                                                            }
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
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
                                            left: 24, right: 24, top: 3, bottom: 16),
                                        child:
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          height: 50,
                                          child: GFButton(
                                            color: Colors.green,
                                            textStyle: TextStyle(fontSize: 15),
                                            onPressed: (){
                                              actionApproval("terima");
                                            },
                                            text: "Terima",
                                            blockButton: true,
                                          ),
                                        ),
                                      )

                                  ],
                                );
                            }
                          },
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
