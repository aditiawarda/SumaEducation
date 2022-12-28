// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/appointment_approver/model/appointment_attacment_data.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_attacment_data.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_list_data.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../main.dart';

class AppointmentListLampiran extends StatefulWidget {
  const AppointmentListLampiran(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.idRequest})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? idRequest;

  @override
  _AppointmentListLampiranState createState() => _AppointmentListLampiranState();
}

class _AppointmentListLampiranState extends State<AppointmentListLampiran>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<AppointmentAttachment> appointmentAttachment = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    getAppointmentAttachment();
    getUser();
    super.initState();
  }

  Future<String> getAppointmentAttachment() async {
    try {
      var response = await http.post(Uri.parse("https://appointment.geloraaksara.co.id/api/list_attachment"),
          body: {
            "id_request": widget.idRequest!,
          });
      appointmentAttachment = [];
      var dataAttachment= json.decode(response.body);
      print(dataAttachment);
      for (var i = 0; i < dataAttachment['data'].length; i++) {
        var id = dataAttachment['data'][i]['id'].toString();
        var id_jadwal = dataAttachment['data'][i]['id_jadwal'].toString();
        var nama_file = dataAttachment['data'][i]['nama_file'].toString();

        appointmentAttachment.add(AppointmentAttachment(id, id_jadwal, nama_file));
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  Future<String> getUser() async {
    prefs = await _prefs;
    return 'true';
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  child: Container(
                      padding: const EdgeInsets.only(right: 25, left: 27, top: 15),
                      child:  Text(
                        "Attachment :",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          letterSpacing: 0.5,
                          color: AppTheme.lightText.withOpacity(0.5),
                        ),
                      ),
                    ),
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  child: Theme(
                    data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange[100])),
                    child:
                    FutureBuilder<String>(
                      future: getAppointmentAttachment(), // function where you call your api
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 5, right: 16, left: 16),
                            itemCount: appointmentAttachment.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              final int count = appointmentAttachment.length;
                              final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                              animationController?.forward();

                              return itemAttachment(appointmentAttachment[index], context, animationController!, animation, index.toString());

                            },
                          );
                        } else {
                          if (snapshot.hasError)
                            return ListView.builder(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 5, right: 16, left: 16),
                              itemCount: appointmentAttachment.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                final int count = appointmentAttachment.length;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval((1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn)));
                                animationController?.forward();

                                return itemAttachment(appointmentAttachment[index], context, animationController!, animation, index.toString());

                              },
                            );
                          else
                          if (appointmentAttachment.length==0)
                            return
                              FadeInUp(
                                delay: Duration(milliseconds: 300),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/empty_data.png",
                                          height: 80),
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Data tidak tersedia',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: 0.5,
                                                  color: Colors.blueGrey.shade200,
                                                ),
                                              ),
                                              Text(
                                                'Attachment tidak tersedia',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11,
                                                  letterSpacing: 0.5,
                                                  color: Colors.blueGrey.shade200,
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              );
                          else
                            return ListView.builder(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 5, right: 16, left: 16),
                              itemCount: appointmentAttachment.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                final int count = appointmentAttachment.length;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval((1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn)));
                                animationController?.forward();

                                return itemAttachment(appointmentAttachment[index], context, animationController!, animation, index.toString());

                              },
                            ); // snapshot.data  :- get your object which is pass from your downloadData() function
                        }
                      },
                    ),
                  ),
                ),
              ],
            )

          ),
        );
      },
    );
  }
}

Widget itemAttachment(AppointmentAttachment appointmentAttachment, BuildContext context, AnimationController animationController, Animation<double> animation, String i){
  return
    AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: ZoomTapAnimation(
              onTap: () {
                new Future.delayed(new Duration(milliseconds: 1000), () async {
                  await launch("https://appointment.geloraaksara.co.id/appointments_fix/public/lampiran/"+appointmentAttachment.nama_file);
                });
              },
            child: Transform(
              transform: Matrix4.translationValues(100 * (1.0 - animation.value), 0.0, 0.0),
              child: SizedBox(
                width: 150,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32, left: 8, right: 8, bottom: 16),
                      child: Container(
                        width: 150,
                        height: 70,
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.grey.withOpacity(0.2),
                                offset: Offset(1.1, 1.1),
                                blurRadius: 5.0),
                          ],
                          gradient: LinearGradient(
                            colors: <HexColor>[
                                HexColor("#FFFFFF"),
                                HexColor("#FFFFFF"),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Lampiran "+(int.parse(i)+1).toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Colors.teal.withOpacity(0.8),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 6, bottom: 5),
                                child: Container(
                                  height: 1.5,
                                  decoration: BoxDecoration(
                                    color: AppTheme.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                ),
                              ),
                              Text(
                                appointmentAttachment.nama_file,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Colors.teal.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 6,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 8,
                      child: SizedBox(
                          width: 40,
                          height: 40,
                          child:
                          Stack(
                            children: [
                              Image.asset('assets/suma_education/marking_appointment.png'),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
        );
      },
    );
}

