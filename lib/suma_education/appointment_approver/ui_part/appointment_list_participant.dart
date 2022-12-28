// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/appointment_approver/model/appointment_list_participant.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_attacment_data.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_list_data.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../main.dart';

class AppointmentListParticipant extends StatefulWidget {
  const AppointmentListParticipant(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.idProposal})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? idProposal;

  @override
  _AppointmentListParticipantState createState() => _AppointmentListParticipantState();
}

class _AppointmentListParticipantState extends State<AppointmentListParticipant>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<ParticipantData> appointmentParticipant = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    getParticipant();
    getUser();
    super.initState();
  }

  Future<String> getParticipant() async {
    try {
      var response = await http.post(Uri.parse("https://appointment.geloraaksara.co.id/api/list_participant"),
          body: {
            "id_request": '409',
          });
      appointmentParticipant = [];
      var dataParticipant = json.decode(response.body);
      print(dataParticipant);
      for (var i = 0; i < dataParticipant['data'].length; i++) {
        var id = dataParticipant['data'][i]['id'].toString();
        var nik = dataParticipant['data'][i]['nik'].toString();
        var nama = dataParticipant['data'][i]['nama'].toString();
        var bagian = dataParticipant['data'][i]['bagian'].toString();
        var meeting_id = dataParticipant['data'][i]['meeting_id'].toString();

        appointmentParticipant.add(ParticipantData(id, nik, nama, bagian, meeting_id));
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

            Container(
              child: Column(
                children: [
                  FadeInUp(
                    delay: Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.only(right: 25, left: 27, top: 15),
                      child:  Text(
                        "Participant :",
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

                  // FutureBuilder<String>(
                  //   future: getParticipant(), // function where you call your api
                  //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return GridView.builder(
                  //           shrinkWrap: true,
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //               crossAxisCount: 1,
                  //               childAspectRatio: 4,
                  //               crossAxisSpacing: 0,
                  //               mainAxisSpacing: 2),
                  //           itemCount: appointmentParticipant.length,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             final int count = appointmentParticipant.length;
                  //             final Animation<double> animation =
                  //             Tween<double>(begin: 0.0, end: 1.0).animate(
                  //                 CurvedAnimation(
                  //                     parent: animationController!,
                  //                     curve: Interval((1 / count) * index, 1.0,
                  //                         curve: Curves.fastOutSlowIn)));
                  //             animationController?.forward();
                  //             return itemParticipant(appointmentParticipant[index], context, animationController!, animation);
                  //           });
                  //     } else {
                  //       if (snapshot.hasError)
                  //         return GridView.builder(
                  //             shrinkWrap: true,
                  //             physics: const NeverScrollableScrollPhysics(),
                  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //                 crossAxisCount: 1,
                  //                 childAspectRatio: 4,
                  //                 crossAxisSpacing: 0,
                  //                 mainAxisSpacing: 2),
                  //             itemCount: appointmentParticipant.length,
                  //             itemBuilder: (BuildContext context, int index) {
                  //               final int count = appointmentParticipant.length;
                  //               final Animation<double> animation =
                  //               Tween<double>(begin: 0.0, end: 1.0).animate(
                  //                   CurvedAnimation(
                  //                       parent: animationController!,
                  //                       curve: Interval((1 / count) * index, 1.0,
                  //                           curve: Curves.fastOutSlowIn)));
                  //               animationController?.forward();
                  //               return itemParticipant(appointmentParticipant[index], context, animationController!, animation);
                  //             });
                  //       else
                  //       if(appointmentParticipant.length==0)
                  //         return
                  //           FadeInUp(
                  //             delay: Duration(milliseconds: 500),
                  //             child: Container(
                  //               margin: EdgeInsets.only(top: 130),
                  //               alignment: Alignment.center,
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                  //                 children: [
                  //                   Container(
                  //                     margin: EdgeInsets.only(bottom: 10),
                  //                     child: Image.asset("assets/images/empty_data.png", height: 100),
                  //                   ),
                  //                   Column(
                  //                     mainAxisAlignment: MainAxisAlignment.center,
                  //                     crossAxisAlignment: CrossAxisAlignment.center,
                  //                     children: [
                  //                       Text(
                  //                         'Data tidak tersedia',
                  //                         textAlign: TextAlign.left,
                  //                         style: TextStyle(
                  //                           fontFamily: AppTheme.fontName,
                  //                           fontWeight: FontWeight.w500,
                  //                           fontSize: 16,
                  //                           letterSpacing: 0.5,
                  //                           color: Colors.blueGrey.shade200,
                  //                         ),
                  //                       ),
                  //                       Text(
                  //                         'Data participant tidak tersedia',
                  //                         textAlign: TextAlign.left,
                  //                         style: TextStyle(
                  //                           fontFamily: AppTheme.fontName,
                  //                           fontWeight: FontWeight.w500,
                  //                           fontSize: 12,
                  //                           letterSpacing: 0.5,
                  //                           color: Colors.blueGrey.shade200,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //       else
                  //         return GridView.builder(
                  //             padding: EdgeInsets.only(bottom: 100),
                  //             shrinkWrap: true,
                  //             physics: const NeverScrollableScrollPhysics(),
                  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //                 crossAxisCount: 1,
                  //                 childAspectRatio: 4,
                  //                 crossAxisSpacing: 0,
                  //                 mainAxisSpacing: 2),
                  //             itemCount: appointmentParticipant.length,
                  //             itemBuilder: (BuildContext context, int index) {
                  //               final int count = appointmentParticipant.length;
                  //               final Animation<double> animation =
                  //               Tween<double>(begin: 0.0, end: 1.0).animate(
                  //                   CurvedAnimation(
                  //                       parent: animationController!,
                  //                       curve: Interval((1 / count) * index, 1.0,
                  //                           curve: Curves.fastOutSlowIn)));
                  //               animationController?.forward();
                  //               return itemParticipant(appointmentParticipant[index], context, animationController!, animation);
                  //             });  // snapshot.data  :- get your object which is pass from your downloadData() function
                  //     }
                  //   },
                  // ),

                  FutureBuilder<String>(
                    future: getParticipant(), // function where you call your api
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 5, right: 16, left: 16),
                          itemCount: appointmentParticipant.length,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final int count = appointmentParticipant.length;
                            final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                            animationController?.forward();

                            return itemParticipant(appointmentParticipant[index], context, animationController!, animation);

                          },
                        );
                      } else {
                        if (snapshot.hasError)
                          return ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 5, right: 16, left: 16),
                            itemCount: appointmentParticipant.length,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final int count = appointmentParticipant.length;
                              final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                              animationController?.forward();

                              return itemParticipant(appointmentParticipant[index], context, animationController!, animation);

                            },
                          );
                        else
                        if (appointmentParticipant.length==0)
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
                            itemCount: appointmentParticipant.length,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final int count = appointmentParticipant.length;
                              final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                              animationController?.forward();

                              return itemParticipant(appointmentParticipant[index], context, animationController!, animation);

                            },
                          ); // snapshot.data  :- get your object which is pass from your downloadData() function
                      }
                    },
                  ),

                ],
              )
            )

          ),
        );
      },
    );
  }
}

Widget itemParticipant(ParticipantData participantData, BuildContext context, AnimationController animationController, Animation<double> animation){
  return
    AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: ZoomTapAnimation(
              onTap: () {
                // new Future.delayed(new Duration(milliseconds: 1000), () async {
                //   await launch("https://proposal.sumasistem.co.id/file_proposal/"+proposalAttachment.FileProposal);
                // });
              },
            child: Transform(
              transform: Matrix4.translationValues(100 * (1.0 - animation.value), 0.0, 0.0),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 8, right: 8, bottom: 5),
                      child: Container(
                        height: 50,
                        width: double.infinity,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                participantData.nama,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
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

