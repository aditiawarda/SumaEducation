import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/appointment_approver/model/appointment_list_data.dart';
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_detail_view.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_list_data.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../main.dart';

class AppointmentListQueue extends StatefulWidget {
  const AppointmentListQueue(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _AppointmentListQueueState createState() => _AppointmentListQueueState();
}

class _AppointmentListQueueState extends State<AppointmentListQueue>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<AppointmentData> appointmentlListData = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<String> getAppointmentQueueDirector() async {
    final SharedPreferences prefs = await _prefs;
    try {
      var response = await http.post(Uri.parse("https://appointment.geloraaksara.co.id/api/appointment_queue"),
          body: {
            "nik": "2151010115",
          });
      appointmentlListData = [];
      var dataAntrianAppointment = json.decode(response.body);
      print(dataAntrianAppointment);
      for (var i = 0; i < dataAntrianAppointment['data'].length; i++) {
        //print(i);
        var id = dataAntrianAppointment['data'][i]['id'].toString();
        var nik = dataAntrianAppointment['data'][i]['nik'].toString();
        var nik_requester = dataAntrianAppointment['data'][i]['nik_requester'].toString();
        var nama_requester = dataAntrianAppointment['data'][i]['nama_requester'].toString();
        var bagian_requester = dataAntrianAppointment['data'][i]['bagian_requester'].toString();
        var deskripsi = dataAntrianAppointment['data'][i]['deskripsi'].toString();
        var lokasi = dataAntrianAppointment['data'][i]['lokasi'].toString();
        var detail_lokasi = dataAntrianAppointment['data'][i]['detail_lokasi'].toString();
        var urgent = dataAntrianAppointment['data'][i]['urgent'].toString();
        var date = dataAntrianAppointment['data'][i]['date'].toString();
        var start_date = dataAntrianAppointment['data'][i]['start_date'].toString();
        var end_date = dataAntrianAppointment['data'][i]['end_date'].toString();
        var status = dataAntrianAppointment['data'][i]['status'].toString();
        var visitor_name = dataAntrianAppointment['data'][i]['visitor_name'].toString();
        var visitor_address = dataAntrianAppointment['data'][i]['visitor_address'].toString();
        var erlangga_area = dataAntrianAppointment['data'][i]['erlangga_area'].toString();
        var number_visitor = dataAntrianAppointment['data'][i]['number_visitor'].toString();
        var tipe_jadwal = dataAntrianAppointment['data'][i]['tipe_jadwal'].toString();
        var created_at = dataAntrianAppointment['data'][i]['created_at'].toString();
        var updated_at = dataAntrianAppointment['data'][i]['updated_at'].toString();

        appointmentlListData.add(
            AppointmentData(id, nik, nik_requester, nama_requester, bagian_requester, deskripsi, lokasi, detail_lokasi, urgent, date, start_date, end_date, status, visitor_name, visitor_address, erlangga_area, number_visitor, tipe_jadwal, created_at, updated_at)
        );
      }
    } catch (e) {
      print("Error "+e.toString());
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
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Wrap(
                    children: <Widget>[
                      FadeInUp(
                        delay: Duration(milliseconds: 500),
                          child:
                          Container(
                            margin: EdgeInsets.only(left: 8, right: 8, bottom: 10),
                            child: Text(
                              "Antrian Request",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                letterSpacing: 0.5,
                                color: AppTheme.lightText,
                              ),
                            ),
                          ),
                      ),
                      FutureBuilder<String>(
                        future: getAppointmentQueueDirector(), // function where you call your api
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.5,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 10),
                                itemCount: appointmentlListData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final int count = appointmentlListData.length;
                                  final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: animationController!,
                                          curve: Interval((1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn)));
                                  animationController?.forward();
                                  return itemProposalQueue(appointmentlListData[index], context, animationController!, animation);
                                });
                          } else {
                            if (snapshot.hasError)
                              return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.5,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 10),
                                  itemCount: appointmentlListData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final int count = appointmentlListData.length;
                                    final Animation<double> animation =
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                        CurvedAnimation(
                                            parent: animationController!,
                                            curve: Interval((1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn)));
                                    animationController?.forward();
                                    return itemProposalQueue(appointmentlListData[index], context, animationController!, animation);
                                  });
                            else
                            if(appointmentlListData.length==0)
                              return
                                FadeInUp(
                                  delay: Duration(milliseconds: 500),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 100),
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
                                              'Data appointment tidak tersedia',
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
                                  padding: EdgeInsets.only(bottom: 100),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.5,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 10),
                                  itemCount: appointmentlListData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final int count = appointmentlListData.length;
                                    final Animation<double> animation =
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                        CurvedAnimation(
                                            parent: animationController!,
                                            curve: Interval((1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn)));
                                    animationController?.forward();
                                    return itemProposalQueue(appointmentlListData[index], context, animationController!, animation);
                                  });  // snapshot.data  :- get your object which is pass from your downloadData() function
                          }
                        },
                      )
                    ],
                  ),
                )

          ),
        );
      },
    );
  }
}

Widget itemProposalQueue(AppointmentData appointmentData, BuildContext context, AnimationController animationController, Animation<double> animation){
  return
    AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeInUp(
          delay: Duration(milliseconds: 600),
          child: ZoomTapAnimation(
            onTap: () {
              new Future.delayed(new Duration(milliseconds: 300), () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => AppointmentDetail(animationController: animationController, appointmentId: appointmentData.id),
                    )
                );
              });
            },
            child: SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.4),
                              offset: Offset(1.1, 1.0),
                              blurRadius: 5.0),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            if(appointmentData.tipe_jadwal=='0')...{
                              HexColor("#8864f4"),
                              HexColor("#FFB295"),
                            } else if(appointmentData.tipe_jadwal=='2') ...{
                              HexColor("#0eabcf"),
                              HexColor("#f2c04f"),
                            },
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 54, left: 16, right: 16, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if(appointmentData.tipe_jadwal=='0')...{
                              Text(
                                'Meeting',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.2,
                                  color: AppTheme.white,
                                ),
                              ),
                            } else if(appointmentData.tipe_jadwal=='2') ...{
                              Text(
                                'Guest Visit',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.2,
                                  color: AppTheme.white,
                                ),
                              ),
                            },
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                          appointmentData.deskripsi,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.2,
                                            color: AppTheme.white,
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  appointmentData.start_date.substring(0,5),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    letterSpacing: 0.2,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  appointmentData.date.substring(8, 10)+'/'+appointmentData.date.substring(5, 7)+'/'+appointmentData.date.substring(0, 4),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    letterSpacing: 0.2,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 2,
                    child: SizedBox(
                        width: 75,
                        height: 75,
                        child:
                        Stack(
                          children: [
                            Image.asset('assets/suma_education/appointment.png'),
                          ],
                        )
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    right: 15,
                    child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: AppTheme.nearlyWhite.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: RippleAnimation(
                          repeat: true,
                          color: Colors.white,
                          minRadius: 10,
                          ripplesCount: 6, child: null,
                        )
                    ),
                  ),
                ],
              ),
          ),
          ),
        );
      },
    );
}

