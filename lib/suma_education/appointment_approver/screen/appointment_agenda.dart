// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:suma_education/suma_education/appointment_approver/model/appointment_data_agenda.dart';
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_detail_view.dart';
import 'package:suma_education/suma_education/appointment_approver/ui_part/appointment_calendar_agenda.dart';
import 'package:suma_education/suma_education/appointment_approver/ui_part/appointment_list_approved.dart';
import 'package:suma_education/suma_education/main_page/bottom_navigation_view/main_page.dart';
import 'package:suma_education/suma_education/proposal_approver/ui_part/proposal_list_all_data.dart';
import 'package:flutter/material.dart';
import 'package:suma_education/suma_education/proposal_approver/ui_part/proposal_note_color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../app_theme/app_theme.dart';

DateTime get _now => DateTime.now();

class AppointmentAgenda extends StatefulWidget {
  const AppointmentAgenda({Key? key, required this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _AppointmentAgendaState createState() => _AppointmentAgendaState();
}

class _AppointmentAgendaState extends State<AppointmentAgenda>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  AnimationController? animationControllerBottomSheet;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<CalendarEventData<Agenda>> _events = [];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    animationControllerBottomSheet = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }


  Future<String> addData() async {
    try {
      var response = await http.post(Uri.parse("https://appointment.geloraaksara.co.id/api/agenda_list"),
          body: {
            "id_user": "2151010115",
          });
      _events = [];
      var dataAgenda = json.decode(response.body);
      print(dataAgenda);
      for (var i = 0; i < dataAgenda['data'].length; i++) {
        var id = dataAgenda['data'][i]['id'].toString();
        var tipe_jadwal = dataAgenda['data'][i]['tipe_jadwal'].toString();
        var date = dataAgenda['data'][i]['date'].toString();
        var start_date = dataAgenda['data'][i]['start_date'].toString();
        var end_date = dataAgenda['data'][i]['end_date'].toString();
        var deskripsi = dataAgenda['data'][i]['deskripsi'].toString();

        var tipe = "";
        if(tipe_jadwal=="0"){
          tipe = "Meeting";
        } else if(tipe_jadwal=="2") {
          tipe = "Guest Visit";
        }

    _events.add(
            CalendarEventData(
              date: DateTime.parse(date.toString()),
              event: Agenda(id: id.toString()),
              title: tipe.toString(),
              description: deskripsi.toString(),
              startTime: DateTime(int.parse(date.toString().substring(0, 4)), int.parse(date.toString().substring(5, 7)), int.parse(date.toString().substring(8, 10)), int.parse(start_date.toString().substring(0,2)), int.parse(start_date.toString().substring(3,5))),
              endTime: DateTime(int.parse(date.toString().substring(0, 4)), int.parse(date.toString().substring(5, 7)), int.parse(date.toString().substring(8, 10)), int.parse(end_date.toString().substring(0,2)), int.parse(end_date.toString().substring(3,5))),
            )
        );

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

  void _onRefresh() async{
    setState(() {
      addData();
    });
    await Future.delayed(Duration(milliseconds: 1500));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: AppBar().preferredSize.height + MediaQuery.of(context).padding.top),
              child:  SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: WaterDropHeader(),
                footer: null,
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child:
                Column(
                  children: [
                    Expanded(
                        child:
                        FadeInUp(
                          child: Container(
                            alignment: Alignment.topLeft,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
                            padding: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.3),
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 3.0),
                              ],
                              gradient: LinearGradient(
                                colors: <HexColor>[
                                  HexColor("#DDF0FF"),
                                  HexColor("#FFFFFF"),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                            ),
                            child:
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(right: 9, left: 15, top: 15),
                                      child: StreamBuilder(
                                        stream: Stream.periodic(const Duration(seconds: 1)),
                                        builder: (context, snapshot) {
                                          return Row(
                                            children: [
                                              SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: Image.asset(
                                                    "assets/suma_education/time_main.png"),
                                              ),
                                              Text(
                                                DateFormat('kk:mm:ss').format(DateTime.now())+" "+DateTime.now().timeZoneName.toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  letterSpacing: 0.5,
                                                  color: AppTheme.lightText,
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child:
                                      FutureBuilder<String>(
                                        future: addData(), // function where you call your api
                                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return DayView(
                                              controller: EventController<Agenda>()..addAll(_events),
                                              eventTileBuilder: (date, events, boundry, start, end) {
                                                return
                                                  Stack(
                                                    children: [
                                                      Container(
                                                          margin: EdgeInsets.only(left: 35, right: 15),
                                                          padding: EdgeInsets.only(left: 15, right: 15),
                                                          decoration: BoxDecoration(
                                                            boxShadow: <BoxShadow>[
                                                              BoxShadow(
                                                                  color: AppTheme.grey.withOpacity(0.1),
                                                                  offset: Offset(0.0, 1.0), //(x,y)
                                                                  blurRadius: 2.0),
                                                            ],
                                                            gradient: LinearGradient(
                                                              colors: <HexColor>[
                                                                if(events[0].event.toString().substring(2,3)=="0")...{
                                                                  HexColor("#d5b3f1"),
                                                                  HexColor("#e7d6f5"),
                                                                } else if(events[0].event.toString().substring(2,3)=="2") ...{
                                                                  HexColor("#9ff57f"),
                                                                  HexColor("#cdf3be"),
                                                                },
                                                              ],
                                                              begin: Alignment.topCenter,
                                                              end: Alignment.bottomCenter,
                                                            ),
                                                            borderRadius: const BorderRadius.only(
                                                              bottomRight: Radius.circular(8.0),
                                                              bottomLeft: Radius.circular(10.0),
                                                              topLeft: Radius.circular(8.0),
                                                              topRight: Radius.circular(8.0),
                                                            ),
                                                          ),
                                                          child:
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.notifications,
                                                                    size: 15,
                                                                    color: Colors.blueGrey,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    events[0].title.toString(),
                                                                    textAlign: TextAlign.left,
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontFamily: AppTheme.fontName,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 15,
                                                                      letterSpacing: 0.5,
                                                                      color: AppTheme.lightText.withOpacity(0.8),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 19, top: 3, bottom: 3),
                                                                child: Container(
                                                                  height: 1,
                                                                  decoration: BoxDecoration(
                                                                    color: AppTheme.background.withOpacity(0.5),
                                                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 19),
                                                                child: Text(
                                                                  events[0].description.toString(),
                                                                  textAlign: TextAlign.left,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontFamily: AppTheme.fontName,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 15,
                                                                    letterSpacing: 0.5,
                                                                    color: AppTheme.lightText.withOpacity(0.8),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                      Positioned(
                                                        top: 5,
                                                        right: 20,
                                                        child:
                                                        Row(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.only(top: 10, bottom: 10),
                                                              width: 8,
                                                              height: 8,
                                                              decoration: BoxDecoration(
                                                                color: Colors.white.withOpacity(0.7),
                                                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(left: 5),
                                                              padding: EdgeInsets.only(top: 10, bottom: 10),
                                                              width: 11,
                                                              height: 11,
                                                              decoration: BoxDecoration(
                                                                color: Colors.white.withOpacity(0.7),
                                                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(left: 5),
                                                              padding: EdgeInsets.only(top: 10, bottom: 10),
                                                              width: 9,
                                                              height: 9,
                                                              decoration: BoxDecoration(
                                                                color: Colors.white.withOpacity(0.7),
                                                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  );
                                              },
                                              showVerticalLine: true,
                                              showLiveTimeLineInAllDays: true,
                                              minDay: DateTime(1990),
                                              maxDay: DateTime(2050),
                                              initialDay: _now,
                                              heightPerMinute: 1,
                                              eventArranger: SideEventArranger(),
                                              onEventTap: (events, date) => print(events),
                                              onDateLongPress: (date) => print(date),
                                            );
                                          } else {
                                            if (snapshot.hasError)
                                              return DayView(
                                                controller: EventController<Agenda>()..addAll(_events),
                                                eventTileBuilder: (date, events, boundry, start, end) {
                                                  return
                                                    Stack(
                                                      children: [
                                                        Container(
                                                            margin: EdgeInsets.only(left: 35, right: 15),
                                                            padding: EdgeInsets.only(left: 15, right: 15),
                                                            decoration: BoxDecoration(
                                                              boxShadow: <BoxShadow>[
                                                                BoxShadow(
                                                                    color: AppTheme.grey.withOpacity(0.1),
                                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                                    blurRadius: 2.0),
                                                              ],
                                                              gradient: LinearGradient(
                                                                colors: <HexColor>[
                                                                  if(events[0].event.toString().substring(2,3)=="0")...{
                                                                    HexColor("#d5b3f1"),
                                                                    HexColor("#e7d6f5"),
                                                                  } else if(events[0].event.toString().substring(2,3)=="2") ...{
                                                                    HexColor("#9ff57f"),
                                                                    HexColor("#cdf3be"),
                                                                  },
                                                                ],
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                              ),
                                                              borderRadius: const BorderRadius.only(
                                                                bottomRight: Radius.circular(8.0),
                                                                bottomLeft: Radius.circular(10.0),
                                                                topLeft: Radius.circular(8.0),
                                                                topRight: Radius.circular(8.0),
                                                              ),
                                                            ),
                                                            child:
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons.notifications,
                                                                      size: 15,
                                                                      color: Colors.blueGrey,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Text(
                                                                      events[0].title.toString(),
                                                                      textAlign: TextAlign.left,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(
                                                                        fontFamily: AppTheme.fontName,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 15,
                                                                        letterSpacing: 0.5,
                                                                        color: AppTheme.lightText.withOpacity(0.8),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 19, top: 3, bottom: 3),
                                                                  child: Container(
                                                                    height: 1,
                                                                    decoration: BoxDecoration(
                                                                      color: AppTheme.background.withOpacity(0.5),
                                                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 19),
                                                                  child: Text(
                                                                    events[0].description.toString(),
                                                                    textAlign: TextAlign.left,
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontFamily: AppTheme.fontName,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 15,
                                                                      letterSpacing: 0.5,
                                                                      color: AppTheme.lightText.withOpacity(0.8),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                        ),
                                                        Positioned(
                                                          top: 5,
                                                          right: 20,
                                                          child:
                                                          Row(
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                width: 8,
                                                                height: 8,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white.withOpacity(0.7),
                                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(left: 5),
                                                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                width: 11,
                                                                height: 11,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white.withOpacity(0.7),
                                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(left: 5),
                                                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                width: 9,
                                                                height: 9,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white.withOpacity(0.7),
                                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                },
                                                showVerticalLine: true,
                                                showLiveTimeLineInAllDays: true,
                                                minDay: DateTime(1990),
                                                maxDay: DateTime(2050),
                                                initialDay: _now,
                                                heightPerMinute: 1,
                                                eventArranger: SideEventArranger(),
                                                onEventTap: (events, date) => print(events),
                                                onDateLongPress: (date) => print(date),
                                              );
                                            else
                                              return DayView(
                                                controller: EventController<Agenda>()..addAll(_events),
                                                eventTileBuilder: (date, events, boundry, start, end) {
                                                  return
                                                    InkWell(
                                                      onTap: (){
                                                        var id = events[0].event.toString();

                                                        new Future.delayed(new Duration(milliseconds: 300), () {
                                                          Navigator.push<dynamic>(
                                                              context,
                                                              MaterialPageRoute<dynamic>(
                                                                builder: (BuildContext context) => AppointmentDetail(animationController: widget.animationController, appointmentId: id.toString()),
                                                              )
                                                          );
                                                        });
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                              margin: EdgeInsets.only(left: 35, right: 15),
                                                              padding: EdgeInsets.only(left: 15, right: 15),
                                                              decoration: BoxDecoration(
                                                                boxShadow: <BoxShadow>[
                                                                  BoxShadow(
                                                                      color: AppTheme.grey.withOpacity(0.1),
                                                                      offset: Offset(0.0, 1.0), //(x,y)
                                                                      blurRadius: 2.0),
                                                                ],
                                                                gradient: LinearGradient(
                                                                  colors: <HexColor>[
                                                                    if(events[0].title.toString()=="Meeting")...{
                                                                      HexColor("#d5b3f1"),
                                                                      HexColor("#e7d6f5"),
                                                                    } else if(events[0].title.toString()=="Guest Visit") ...{
                                                                      HexColor("#9ff57f"),
                                                                      HexColor("#cdf3be"),
                                                                    },
                                                                  ],
                                                                  begin: Alignment.topCenter,
                                                                  end: Alignment.bottomCenter,
                                                                ),
                                                                borderRadius: const BorderRadius.only(
                                                                  bottomRight: Radius.circular(8.0),
                                                                  bottomLeft: Radius.circular(10.0),
                                                                  topLeft: Radius.circular(8.0),
                                                                  topRight: Radius.circular(8.0),
                                                                ),
                                                              ),
                                                              child:
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons.notifications,
                                                                        size: 15,
                                                                        color: Colors.blueGrey,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 4,
                                                                      ),
                                                                      Text(
                                                                        events[0].title.toString(),
                                                                        textAlign: TextAlign.left,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontFamily: AppTheme.fontName,
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: 15,
                                                                          letterSpacing: 0.5,
                                                                          color: AppTheme.lightText.withOpacity(0.8),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 19, top: 3, bottom: 3),
                                                                    child: Container(
                                                                      height: 1,
                                                                      decoration: BoxDecoration(
                                                                        color: AppTheme.grey.withOpacity(0.3),
                                                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 19),
                                                                    child: Text(
                                                                      events[0].description.toString(),
                                                                      textAlign: TextAlign.left,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(
                                                                        fontFamily: AppTheme.fontName,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 15,
                                                                        letterSpacing: 0.5,
                                                                        color: AppTheme.lightText.withOpacity(0.8),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                          ),
                                                          Positioned(
                                                            top: 5,
                                                            right: 20,
                                                            child:
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                  width: 8,
                                                                  height: 8,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white.withOpacity(0.7),
                                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(left: 5),
                                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                  width: 11,
                                                                  height: 11,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white.withOpacity(0.7),
                                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(left: 5),
                                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                  width: 9,
                                                                  height: 9,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white.withOpacity(0.7),
                                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                },
                                                showVerticalLine: true,
                                                showLiveTimeLineInAllDays: true,
                                                minDay: DateTime(1990),
                                                maxDay: DateTime(2050),
                                                initialDay: _now,
                                                heightPerMinute: 1,
                                                eventArranger: SideEventArranger(),
                                                onEventTap: (events, date) => print(events),
                                                onDateLongPress: (date) => print(date),
                                              );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0, right: 0,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.only(topRight:Radius.circular(30.0)),
                                    child: SizedBox(
                                      height: 60,
                                      child: AspectRatio(
                                        aspectRatio: 1.714,
                                        child: Image.asset(
                                            "assets/suma_education/back.png"),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
            ),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return
      Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {
                                  new Future.delayed(new Duration(milliseconds: 300), () {
                                    Navigator.pop(context);
                                  });
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: AppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Calendar Agenda',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuButton<int>(
                              icon: Icon(Icons.more_vert),
                              onSelected: (int size) {
                                print(size);
                                if (size==1){
                                  Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) => MainPage(),
                                      )
                                  );
                                } else if (size==2) {
                                  showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      transitionAnimationController: animationControllerBottomSheet,
                                      builder: (BuildContext context) {
                                        return
                                          SlideInUp(
                                            child:  Container(
                                              height: 190,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20.0),
                                                    bottomLeft: Radius.circular(0.0),
                                                    bottomRight: Radius.circular(0.0),
                                                    topRight: Radius.circular(20.0)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: AppTheme.grey.withOpacity(0.5),
                                                      offset: Offset(0.0, 1.0), //(x,y)
                                                      blurRadius: 3.0),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                    width: 80,
                                                    height: 3,
                                                    margin: EdgeInsets.only(top: 3, bottom: 15),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.withOpacity(0.5),
                                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      SizedBox(width: 35),
                                                      Image.asset('assets/images/whatsapp_connect.png', height: 80, width: 80),
                                                      Padding(
                                                          padding: const EdgeInsets.only( left: 20),
                                                          child:
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Container(
                                                                child: Text('Tanya IT',
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        fontFamily: AppTheme.fontName,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 18,
                                                                        letterSpacing: 0.0,
                                                                        color: AppTheme.grey.withOpacity(0.6)
                                                                    )
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context).size.width*0.6,
                                                                padding: EdgeInsets.only(right: 5),
                                                                child: Text('Untuk menghubungi bagian IT anda akan terhubung melalui WhatsApp',
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontFamily: AppTheme.fontName,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 16,
                                                                        letterSpacing: 0.0,
                                                                        color: AppTheme.grey.withOpacity(0.6)
                                                                    )
                                                                ),
                                                              ),
                                                              SizedBox(width: 35),
                                                            ],
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(left: 20, right: 10),
                                                        width: MediaQuery.of(context).size.width*0.5,
                                                        child: GFButton(
                                                          color: Colors.grey,
                                                          textStyle: TextStyle(fontSize: 15),
                                                          onPressed: (){
                                                            Navigator.of(context, rootNavigator: true).pop('dialog');
                                                          },
                                                          text: "Batal",
                                                          blockButton: true,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(right: 20),
                                                        width: MediaQuery.of(context).size.width*0.5,
                                                        child: GFButton(
                                                          color: Colors.orange,
                                                          textStyle: TextStyle(fontSize: 15),
                                                          onPressed: () async {
                                                            Navigator.of(context, rootNavigator: true).pop('dialog');
                                                            await launch("https://wa.me/6285721603080?text=Hello");
                                                          },
                                                          text: "Hubungkan",
                                                          blockButton: true,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                      }
                                  );
                                } else if (size==3) {
                                  showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      transitionAnimationController: animationControllerBottomSheet,
                                      builder: (BuildContext context) {
                                        return
                                          SlideInUp(
                                            child: Container(
                                              height: 260,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20.0),
                                                    bottomLeft: Radius.circular(0.0),
                                                    bottomRight: Radius.circular(0.0),
                                                    topRight: Radius.circular(20.0)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: AppTheme.grey.withOpacity(0.5),
                                                      offset: Offset(0.0, 1.0), //(x,y)
                                                      blurRadius: 3.0),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                    width: 80,
                                                    height: 3,
                                                    margin: EdgeInsets.only(top: 3, bottom: 15),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.withOpacity(0.5),
                                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(left: 25, right: 25),
                                                        child: Text('Tentang App',
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontFamily: AppTheme.fontName,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 18,
                                                                letterSpacing: 0.0,
                                                                color: AppTheme.grey.withOpacity(0.6)
                                                            )
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Text('Suma & Appointment merupakan aplikasi yang dikembangkan oleh Tim IT PT Gelora Aksara Pratama untuk mendukung proses bisnis perusahaan. \n\nVersi yang saat ini anda gunakan adalah v 1.0.8',
                                                            style: TextStyle(
                                                                fontFamily: AppTheme.fontName,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 16,
                                                                letterSpacing: 0.0,
                                                                color: AppTheme.grey.withOpacity(0.6)
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 20, right: 20),
                                                    width: MediaQuery.of(context).size.width,
                                                    child: GFButton(
                                                      color: Colors.grey,
                                                      textStyle: TextStyle(fontSize: 15),
                                                      onPressed: (){
                                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                                      },
                                                      text: "Tutup",
                                                      blockButton: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                      }
                                  );
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.home_outlined),
                                      SizedBox(
                                        // sized box with width 10
                                        width: 10,
                                      ),
                                      Text("Home")
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.headset_mic_outlined),
                                      SizedBox(
                                        // sized box with width 10
                                        width: 10,
                                      ),
                                      Text("Tanya IT")
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(Icons.phone_android_rounded),
                                      SizedBox(
                                        // sized box with width 10
                                        width: 10,
                                      ),
                                      Text("Tentang App")
                                    ],
                                  ),
                                ),
                              ],
                              offset: Offset(-6,45),
                              color: Colors.white,
                              elevation: 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}