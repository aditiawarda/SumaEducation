// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:intl/intl.dart';
import 'package:suma_education/main.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_all_approved.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_revision.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

SharedPreferences? prefs;
DateTime? _dateTime;

class AppointmentDetailVisitor extends StatefulWidget {
  const AppointmentDetailVisitor(
      {Key? key,
        this.mainScreenAnimationController,
        this.mainScreenAnimation,
        this.idRequest,
        this.dateRequest,
        this.startDate,
        this.endDate,
        this.description,
        this.location,
        this.roomName,
        this.detailLocation,
        this.typeRequest,
        this.statusRequest,
        this.urgent,
        this.visitorName,
        this.visitorAddress,
        this.erlanggaArea,
        this.numberVisitor,

      })
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? idRequest;
  final String? dateRequest;
  final String? startDate;
  final String? endDate;
  final String? description;
  final String? location;
  final String? roomName;
  final String? detailLocation;
  final String? typeRequest;
  final String? statusRequest;
  final String? urgent;
  final String? visitorName;
  final String? visitorAddress;
  final String? erlanggaArea;
  final String? numberVisitor;

  @override
  _AppointmentDetailVisitorState createState() => _AppointmentDetailVisitorState();
}

class _AppointmentDetailVisitorState extends State<AppointmentDetailVisitor>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var dateController = TextEditingController();
  var startTime = TextEditingController();
  var finishTime = TextEditingController();
  bool detectChange = false;
  int change = 0;
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _finishTime;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    dateController.text = widget.dateRequest!;
    startTime.text = widget.startDate!;
    finishTime.text = widget.endDate!;
    _date = new DateFormat("yyyy-MM-dd").parse(widget.dateRequest!);
    _startTime = TimeOfDay(hour:int.parse(widget.startDate!.split(":")[0]),minute: int.parse(widget.startDate!.split(":")[1]));
    _finishTime = TimeOfDay(hour:int.parse(widget.endDate!.split(":")[0]),minute: int.parse(widget.endDate!.split(":")[1]));
    super.initState();
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
          text: 'Apakah anda yakin untuk terima dan revisi jadwal?',
          confirmBtnText: 'OK',
          cancelBtnText: 'Batal',
          animType: CoolAlertAnimType.scale,
          width: 30,
          loopAnimation: true,
          confirmBtnColor: Colors.orange.shade300,
          onConfirmBtnTap: (){
            Navigator.of(context, rootNavigator: true).pop('dialog');
            actionRev();
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

  void action() async {
    prefs = await _prefs;
    try {
      var response = await http.post(
          Uri.parse("https://appointment.geloraaksara.co.id/api/approve_func"),
          body: {
            "id_request": widget.idRequest,
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

  void actionRev() async {
    prefs = await _prefs;
    try {
      var response = await http.post(
          Uri.parse("https://appointment.geloraaksara.co.id/api/approve_rev"),
          body: {
            "id_request": widget.idRequest,
            "date": dateController.text,
            "start_date": startTime.text,
            "end_date": finishTime.text,
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
            text: "Appointment berhasil diterima dengan revisi",
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

  void _change() {
    if (change==0){
      change = 1;
      setState(() {
        detectChange = !detectChange;
      });
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
    final width = fullWidth * 0.5 / 2;
    return
      FadeInUp(
          delay : Duration(milliseconds: 500),
          child : AnimatedBuilder(
            animation: widget.mainScreenAnimationController!,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.mainScreenAnimation!,
                child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                  child:
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 32, bottom: 3),
                        child:
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              HexColor("#ffffff"),
                              HexColor("#ffffff"),
                            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(50.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.5),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 3.0),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 2, left: 7, right: 7),
                                //   child: Text(
                                //     'Id Request',
                                //     textAlign: TextAlign.center,
                                //     style: TextStyle(
                                //       fontFamily: AppTheme.fontName,
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 12,
                                //       color:
                                //       AppTheme.lightText.withOpacity(0.5),
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 1, left: 7, right: 7),
                                //   child: Text(
                                //     widget.idRequest!,
                                //     overflow: TextOverflow.ellipsis,
                                //     maxLines: 1,
                                //     style: TextStyle(
                                //       fontFamily: AppTheme.fontName,
                                //       fontWeight: FontWeight.w500,
                                //       fontSize: 15,
                                //       letterSpacing: 0.0,
                                //       color: AppTheme.lightText.withOpacity(0.8),
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 1, left: 7, right: 15),
                                    child: TextField(
                                        controller: dateController, //editing controller of this TextField
                                        decoration: const InputDecoration(
                                            icon: Icon(Icons.calendar_today), //icon of text field
                                            labelText: "Date" //label text of field
                                        ),
                                        readOnly: true,  // when true user cannot edit text
                                        onTap: () async {
                                          if(widget.statusRequest!='1'){
                                            //when click we have to show the datepicker
                                            showDatePicker(
                                              context: context,
                                              initialDate: _date!,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2099),
                                            ).then((date) {  //tambahkan setState dan panggil variabel _dateTime.
                                              setState(() {
                                                _change();
                                                dateController.text = date.toString().substring(0,10);
                                                _date = new DateFormat("yyyy-MM-dd").parse(dateController.text);
                                              });
                                            });
                                          }
                                        }
                                    )
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7, right: 7, top: 2, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            TextField(
                                                controller: startTime, //editing controller of this TextField
                                                decoration: const InputDecoration(
                                                    labelText: "Time Start" //label text of field
                                                ),
                                                readOnly: true,  // when true user cannot edit text
                                                onTap: () async {
                                                  if(widget.statusRequest!='1'){
                                                    //when click we have to show the datepicker
                                                    showTimePicker(
                                                      context: context,
                                                      initialTime: _startTime!,
                                                    ).then((date) {  //tambahkan setState dan panggil variabel _dateTime.
                                                      setState(() {
                                                        _change();
                                                        startTime.text = date!.format(context)+':00';
                                                        _startTime = TimeOfDay(hour:int.parse(startTime.text.split(":")[0]),minute: int.parse(startTime.text.split(":")[1]));
                                                      });
                                                    });
                                                  }
                                                }
                                            )
                                          ],
                                        ) ,
                                      ),
                                      Container(
                                        width: width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            TextField(
                                                controller: finishTime, //editing controller of this TextField
                                                decoration: const InputDecoration(
                                                    labelText: "Time Finish" //label text of field
                                                ),
                                                readOnly: true,  // when true user cannot edit text
                                                onTap: () async {
                                                  if(widget.statusRequest!='1'){
                                                    showTimePicker(
                                                      context: context,
                                                      initialTime: _finishTime!,
                                                    ).then((date) {  //tambahkan setState dan panggil variabel _dateTime.
                                                      setState(() {
                                                        _change();
                                                        finishTime.text = date!.format(context)+':00';
                                                        _finishTime = TimeOfDay(hour:int.parse(finishTime.text.split(":")[0]),minute: int.parse(finishTime.text.split(":")[1]));
                                                      });
                                                    });
                                                  }
                                                }
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
                                  child: Text(
                                    'Description',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: AppTheme.lightText.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 7, right: 7),
                                  child: Text(widget.description!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      letterSpacing: 0.0,
                                      color: AppTheme.lightText.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6, right: 6, top: 2, bottom: 5),
                                  child: Container(
                                    height: 1.5,
                                    decoration: BoxDecoration(
                                      color: AppTheme.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
                                  child: Text(
                                    'Room Meeting',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: AppTheme.lightText.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 7, right: 7),
                                  child: Text(widget.roomName!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      letterSpacing: 0.0,
                                      color: AppTheme.lightText.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if(widget.statusRequest=='0')...{
                        Padding(
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

                                          child: detectChange ?
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            height: 50,
                                            child: GFButton(
                                              color: Colors.orange,
                                              textStyle: TextStyle(fontSize: 15),
                                              onPressed: (){
                                                actionApproval("revisi");
                                              },
                                              text: "Terima dengan Revisi",
                                              blockButton: true,
                                            ),
                                          )
                                              :
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
                      }

                    ],
                  )
                ),
              );
            },
          )
      );
  }
}

