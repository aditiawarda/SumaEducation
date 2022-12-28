import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/appointment_approver/model/appointment_list_data.dart';
import 'package:suma_education/suma_education/appointment_approver/model/appointment_list_participant.dart';
import 'package:suma_education/suma_education/appointment_approver/model/appointment_list_participant_ext.dart';
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_detail_view.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_list_data.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../main.dart';

class AppointmentParticipant extends StatefulWidget {
  const AppointmentParticipant(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.idRequest})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String idRequest;

  @override
  _AppointmentParticipantState createState() => _AppointmentParticipantState();
}

class _AppointmentParticipantState extends State<AppointmentParticipant>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<ParticipantData> appointmentParticipant = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<String> getParticipantExt() async {
    print(widget.idRequest);
    try {
      var response = await http.post(Uri.parse("https://appointment.geloraaksara.co.id/api/list_participant"),
          body: {
            "id_request": widget.idRequest,
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
                  child: Wrap(
                    children: <Widget>[
                      FutureBuilder<String>(
                        future: getParticipantExt(), // function where you call your api
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox(child: null);
                          } else {
                            if (snapshot.hasError)
                              return GridView.builder(
                                  padding: EdgeInsets.only(bottom: 5, left: 23, right: 23, top: 15),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: 5,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 10),
                                  itemCount: appointmentParticipant.length,
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
                                  });
                            else
                            if(appointmentParticipant.length==0)
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
                                  padding: EdgeInsets.only(bottom: 5, left: 23, right: 23, top: 15),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: 5,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 10),
                                  itemCount: appointmentParticipant.length,
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
                                  });  // snapshot.data  :- get your object which is pass from your downloadData() function
                          }
                        },
                      ),
                    ],
                  ),
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
        return FadeInUp(
          delay: Duration(milliseconds: 600),
          child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.4),
                      offset: Offset(1.0, 1.1),
                      blurRadius: 3.0),
                ],
                gradient: LinearGradient(
                  colors: <HexColor>[
                    HexColor("#ffffff"),
                    HexColor("#ffffff"),
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
              child:
                  Stack(
                    children: [
                      Positioned(
                        bottom: 0, right: 0,
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          child: SizedBox(
                            height: 50,
                            child: AspectRatio(
                              aspectRatio: 1.714,
                              child: Image.asset(
                                  "assets/suma_education/participant.png"),
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            width: 10,
                            height: 39,
                            decoration: BoxDecoration(
                              color: Colors.purple.shade900.withOpacity(0.6),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(4.0), bottomRight: Radius.circular(4.0)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(participantData.nama,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                    color: AppTheme.lightText,
                                  ),
                                ),
                                Text(participantData.nik,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                    color: AppTheme.lightText,
                                  ),
                                ),
                                Text(participantData.bagian,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                    color: AppTheme.lightText,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )

          ),
        );
      },
    );
}

