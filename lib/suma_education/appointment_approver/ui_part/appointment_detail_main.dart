// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';
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

class AppointmentDetailMain extends StatefulWidget {
  const AppointmentDetailMain(
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
  _AppointmentDetailMainState createState() => _AppointmentDetailMainState();
}

class _AppointmentDetailMainState extends State<AppointmentDetailMain>
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
    if(change==0){
      if(dateController.text!=widget.dateRequest.toString()||startTime.text!=widget.startDate.toString()||finishTime.text!=widget.endDate.toString()){
        change = 1;
        setState(() {
          detectChange = !detectChange;
        });
      }
    } else {
      if(dateController.text==widget.dateRequest.toString()&&startTime.text==widget.startDate.toString()&&finishTime.text==widget.endDate.toString()){
        change = 0;
        setState(() {
          detectChange = !detectChange;
        });
      }
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
    final widthButton = fullWidth * 0.5 / 1.3;
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
                        child: Stack(
                          children: [
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
                                      height: 15,
                                    ),

                                    if(widget.statusRequest=='0')...{
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Image.asset(
                                                "assets/suma_education/date.png"),
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                            child:
                                            SizedBox(
                                              height: 45,
                                              child: TextFormField(
                                                onTap: () {
                                                  if(widget.statusRequest!='1'){
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate: _date!,
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2099),
                                                    ).then((date) {
                                                      setState(() {
                                                        dateController.text = date.toString().substring(0,10);
                                                        _date = new DateFormat("yyyy-MM-dd").parse(dateController.text);
                                                        _change();
                                                      });
                                                    });
                                                  }
                                                },
                                                controller: dateController,
                                                style: GoogleFonts.inter(
                                                  fontSize: 18.0,
                                                  color: const Color(0xFF151624),
                                                ),
                                                readOnly: true,
                                                cursorColor: const Color(0xFF151624),
                                                decoration: InputDecoration(
                                                  label: Text(
                                                    'Date',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                      color: AppTheme.lightText.withOpacity(0.5),
                                                    ),
                                                  ),
                                                  contentPadding: EdgeInsets.only(bottom: 1, left: 15, right: 15),
                                                  hintStyle: GoogleFonts.inter(
                                                    fontSize: 16.0,
                                                    color: const Color(0xFF151624).withOpacity(0.5),
                                                  ),
                                                  filled: false,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                      borderSide: BorderSide(
                                                          color: Colors.blueGrey.shade100
                                                      )
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                      borderSide: BorderSide(
                                                        color: Colors.orange.shade600,
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    } else if(widget.statusRequest=='1')...{
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Image.asset(
                                                "assets/suma_education/date.png"),
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                            child:
                                            SizedBox(
                                              height: 45,
                                              child: TextFormField(
                                                onTap: () {
                                                  if(widget.statusRequest!='1'){
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate: _date!,
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2099),
                                                    ).then((date) {
                                                      setState(() {
                                                        _change();
                                                        dateController.text = date.toString().substring(0,10);
                                                        _date = new DateFormat("yyyy-MM-dd").parse(dateController.text);
                                                      });
                                                    });
                                                  }
                                                },
                                                controller: dateController,
                                                style: GoogleFonts.inter(
                                                  fontSize: 18.0,
                                                  color: const Color(0xFF151624),
                                                ),
                                                readOnly: true,
                                                cursorColor: const Color(0xFF151624),
                                                decoration: InputDecoration(
                                                  label: Text(
                                                    'Date',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                      color: AppTheme.lightText.withOpacity(0.5),
                                                    ),
                                                  ),
                                                  contentPadding: EdgeInsets.only(bottom: 1, left: 15, right: 15),
                                                  hintStyle: GoogleFonts.inter(
                                                    fontSize: 16.0,
                                                    color: const Color(0xFF151624).withOpacity(0.5),
                                                  ),
                                                  filled: false,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                      borderSide: BorderSide(
                                                          color: Colors.blueGrey.shade100
                                                      )
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                      borderSide: BorderSide(
                                                        color: Colors.blueGrey.withOpacity(0.5),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    },

                                    SizedBox(
                                      height: 10,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: widthButton,
                                          height: 50,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: Image.asset(
                                                    "assets/suma_education/time_start.png"),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              if(widget.statusRequest=='0')...{
                                                Expanded(
                                                  child:
                                                  SizedBox(
                                                    height: 45,
                                                    child: TextFormField(
                                                      onTap: () {
                                                        if(widget.statusRequest!='1'){
                                                          showTimePicker(
                                                            context: context,
                                                            initialTime: _startTime!,
                                                          ).then((date) {
                                                            setState(() {
                                                              startTime.text = date!.format(context)+':00';
                                                              _startTime = TimeOfDay(hour:int.parse(startTime.text.split(":")[0]),minute: int.parse(startTime.text.split(":")[1]));
                                                              _change();
                                                            });
                                                          });
                                                        }
                                                      },
                                                      controller: startTime,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 18.0,
                                                        color: const Color(0xFF151624),
                                                      ),
                                                      readOnly: true,
                                                      cursorColor: const Color(0xFF151624),
                                                      decoration: InputDecoration(
                                                        label: Text(
                                                          'Start Time',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 14,
                                                            color: AppTheme.lightText.withOpacity(0.5),
                                                          ),
                                                        ),
                                                        contentPadding: EdgeInsets.only(bottom: 1, left: 15, right: 15),
                                                        hintStyle: GoogleFonts.inter(
                                                          fontSize: 16.0,
                                                          color: const Color(0xFF151624).withOpacity(0.5),
                                                        ),
                                                        filled: false,
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(
                                                                color: Colors.blueGrey.shade100
                                                            )
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(
                                                              color: Colors.orange.shade600,
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              } else if(widget.statusRequest=='1')...{
                                                Expanded(
                                                  child:
                                                  SizedBox(
                                                    height: 45,
                                                    child: TextFormField(
                                                      onTap: () {
                                                        if(widget.statusRequest!='1'){
                                                          showTimePicker(
                                                            context: context,
                                                            initialTime: _startTime!,
                                                          ).then((date) {
                                                            setState(() {
                                                              startTime.text = date!.format(context)+':00';
                                                              _startTime = TimeOfDay(hour:int.parse(startTime.text.split(":")[0]),minute: int.parse(startTime.text.split(":")[1]));
                                                              _change();
                                                            });
                                                          });
                                                        }
                                                      },
                                                      controller: startTime,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 18.0,
                                                        color: const Color(0xFF151624),
                                                      ),
                                                      readOnly: true,
                                                      cursorColor: const Color(0xFF151624),
                                                      decoration: InputDecoration(
                                                        label: Text(
                                                          'Start Time',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 14,
                                                            color: AppTheme.lightText.withOpacity(0.5),
                                                          ),
                                                        ),
                                                        contentPadding: EdgeInsets.only(bottom: 1, left: 15, right: 15),
                                                        hintStyle: GoogleFonts.inter(
                                                          fontSize: 16.0,
                                                          color: const Color(0xFF151624).withOpacity(0.5),
                                                        ),
                                                        filled: false,
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(
                                                                color: Colors.blueGrey.shade100
                                                            )
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(
                                                              color: Colors.blueGrey.withOpacity(0.5),
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              },
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: widthButton,
                                          height: 50,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: Image.asset(
                                                    "assets/suma_education/time.png"),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              if(widget.statusRequest=='0')...{
                                                Expanded(
                                                  child:
                                                  SizedBox(
                                                    height: 45,
                                                    child: TextFormField(
                                                      onTap: () {
                                                        if(widget.statusRequest!='1'){
                                                          showTimePicker(
                                                            context: context,
                                                            initialTime: _finishTime!,
                                                          ).then((date) {  //tambahkan setState dan panggil variabel _dateTime.
                                                            setState(() {
                                                              finishTime.text = date!.format(context)+':00';
                                                              _finishTime = TimeOfDay(hour:int.parse(finishTime.text.split(":")[0]),minute: int.parse(finishTime.text.split(":")[1]));
                                                              _change();
                                                            });
                                                          });
                                                        }
                                                      },
                                                      controller: finishTime,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 18.0,
                                                        color: const Color(0xFF151624),
                                                      ),
                                                      readOnly: true,
                                                      cursorColor: const Color(0xFF151624),
                                                      decoration: InputDecoration(
                                                        label: Text(
                                                          'Finish Time',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 14,
                                                            color: AppTheme.lightText.withOpacity(0.5),
                                                          ),
                                                        ),
                                                        contentPadding: EdgeInsets.only(bottom: 1, left: 15, right: 15),
                                                        hintStyle: GoogleFonts.inter(
                                                          fontSize: 16.0,
                                                          color: const Color(0xFF151624).withOpacity(0.5),
                                                        ),
                                                        filled: false,
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(
                                                                color: Colors.blueGrey.shade100
                                                            )
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(
                                                              color: Colors.orange.shade600,
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              } else if(widget.statusRequest=='1')...{
                                                Expanded(
                                                  child:
                                                  SizedBox(
                                                    height: 45,
                                                    child: TextFormField(
                                                      onTap: () {
                                                        if(widget.statusRequest!='1'){
                                                          showTimePicker(
                                                            context: context,
                                                            initialTime: _finishTime!,
                                                          ).then((date) {  //tambahkan setState dan panggil variabel _dateTime.
                                                            setState(() {
                                                              finishTime.text = date!.format(context)+':00';
                                                              _finishTime = TimeOfDay(hour:int.parse(finishTime.text.split(":")[0]),minute: int.parse(finishTime.text.split(":")[1]));
                                                              _change();
                                                            });
                                                          });
                                                        }
                                                      },
                                                      controller: finishTime,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 18.0,
                                                        color: const Color(0xFF151624),
                                                      ),
                                                      readOnly: true,
                                                      cursorColor: const Color(0xFF151624),
                                                      decoration: InputDecoration(
                                                        label: Text(
                                                          'Finish Time',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 14,
                                                            color: AppTheme.lightText.withOpacity(0.5),
                                                          ),
                                                        ),
                                                        contentPadding: EdgeInsets.only(bottom: 1, left: 15, right: 15),
                                                        hintStyle: GoogleFonts.inter(
                                                          fontSize: 16.0,
                                                          color: const Color(0xFF151624).withOpacity(0.5),
                                                        ),
                                                        filled: false,
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(
                                                                color: Colors.blueGrey.shade100
                                                            )
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(
                                                              color: Colors.blueGrey.withOpacity(0.5),
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              },
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 5,
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
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
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

                                    if(widget.typeRequest=='0')...{
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
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: AppTheme.lightText.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    } else if(widget.typeRequest=='2')...{
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
                                        child: Text(
                                          'Visitor Name',
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
                                        child: Text(widget.visitorName!,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: AppTheme.lightText.withOpacity(0.8),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
                                        child: Text(
                                          'Visitor Address',
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
                                        child: Text(widget.visitorAddress!,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: AppTheme.lightText.withOpacity(0.8),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
                                        child: Text(
                                          'Room',
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
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: AppTheme.lightText.withOpacity(0.8),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
                                        child: Text(
                                          'Detail',
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
                                        child: Text(widget.detailLocation!,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: AppTheme.lightText.withOpacity(0.8),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
                                        child: Text(
                                          'Number of Visitor',
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
                                        child: Text(widget.numberVisitor!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: AppTheme.lightText.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    },
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if(widget.typeRequest=='0')...{
                              Positioned(
                                right: 0,
                                top: 0,
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      topRight: Radius.circular(50.0)),
                                  child: SizedBox(
                                    height: 90,
                                    child: AspectRatio(
                                      aspectRatio: 1.714,
                                      child: Image.asset(
                                          "assets/suma_education/back_meeting.png"),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                right: 15,
                                child:
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade700.withOpacity(0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade700.withOpacity(0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      width: 17,
                                      height: 17,
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade700.withOpacity(0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            } else if(widget.typeRequest=='2')...{
                              Positioned(
                                right: 0,
                                top: 0,
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      topRight: Radius.circular(50.0)),
                                  child: SizedBox(
                                    height: 90,
                                    child: AspectRatio(
                                      aspectRatio: 1.714,
                                      child: Image.asset(
                                          "assets/suma_education/back_visit.png"),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                right: 15,
                                child:
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.8),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.8),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      width: 17,
                                      height: 17,
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.8),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            }
                          ],
                        )
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

