import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/appointment_approver/screen/appointment_approver_screen.dart';
import 'package:suma_education/suma_education/main_page/model/menu_data.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_approver_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

List<MenuData> listMenu = [];
SharedPreferences? prefs;
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class MainMenu extends StatelessWidget {
  final AnimationController? animationController;
  final AnimationController? animationControllerBottomSheet;
  final Animation<double>? animation;

  const MainMenu(
      {Key? key, this.animationController, this.animation, required this.animationControllerBottomSheet})
      : super(key: key);

  Future<String> _getMainMenu() async {
    prefs = await _prefs;
    try {
      var response = await http.post(Uri.parse("https://geloraaksara.co.id/absen-online/api/get_menu"),
          body: {
            "request": "request",
          });
      listMenu = [];
      var dataMainMenu = json.decode(response.body);
      print(dataMainMenu);
      for (var i = 0; i < dataMainMenu['data'].length; i++) {
        var IdMenu = dataMainMenu['data'][i]['id_menu'];
        var NamaMenu = dataMainMenu['data'][i]['nama_menu'];
        var IconMenu = dataMainMenu['data'][i]['ic_image'];
        var Status = dataMainMenu['data'][i]['status'];

        listMenu.add(MenuData(IdMenu, NamaMenu, IconMenu, Status));
      }
    } catch (e) {
      print(e.toString());
    }
    return 'true';
  }

  @override
  Widget build(BuildContext context) {
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
                      left: 24, right: 24, top: 16, bottom: 18),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                        margin: EdgeInsets.only(bottom: 15),
                        child:
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10, right: 9, left: 9),
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
                            Positioned(
                              top: 0, right: 0,
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                child: SizedBox(
                                  height: 45,
                                  child: AspectRatio(
                                    aspectRatio: 1.714,
                                    child: Image.asset(
                                        "assets/suma_education/back.png"),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                      Container(
                        height: 180,
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
                        child:
                        FutureBuilder<String>(
                          future: _getMainMenu(), // function where you call your api
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _listMenu();
                            } else {
                              if (snapshot.hasError)
                                return _listMenu();
                              else
                                if(listMenu.length==0)
                                  return
                                    FadeIn(
                                      delay: Duration(milliseconds: 1000),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/no_internet.png",
                                                height: 80),
                                            Container(
                                                margin: EdgeInsets.only(left: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Koneksi terputus',
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
                                                      'Tidak ada internet',
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
                                  return
                                    _listMenu();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          );
      },
    );
  }

  Widget _listMenu(){
    return
      GridView.builder(
        padding: EdgeInsets.only(top: 30, bottom: 25),
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.7 / 3,
          ),
          itemCount: listMenu.length,
          itemBuilder: (BuildContext context, int index) {
            return itemMenu(listMenu[index], context);
          }
      );
  }

  Widget itemMenu(MenuData menu, BuildContext context){
    return
      FadeInUp(
          delay: Duration(milliseconds: 1000),
          child: ZoomTapAnimation(
              child: GestureDetector(
                onTap: () {
                  new Future.delayed(new Duration(milliseconds: 300), () {
                    openMenu(context, animationController!, menu.IdMenu, animationControllerBottomSheet!);
                    print(menu.IdMenu);
                  });
                },
                child:
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width/4,
                    alignment: Alignment.center,
                    child:
                    Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
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
                          child:  Image.network(
                            'https://geloraaksara.co.id/absen-online/upload/portal_gelora_assest/'+menu.IconMenu,
                            height: 35,
                            width: 35,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                            menu.NamaMenu,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14
                            )
                        )
                      ],
                    )
                ),
              )
          )
      );
  }

}

void openMenu(BuildContext context, AnimationController animationController, String idMenu, AnimationController animationControllerBottomSheet) {
  if(idMenu=='1'){ // Proposal
    if(prefs!.getString("data_NIK").toString()=='2151010115' || prefs!.getString("data_NIK").toString()=='1504060711' || prefs!.getString("data_NIK").toString()=='P2182' || prefs!.getString("data_NIK").toString()=='M0015'){
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ProposalApproverScreen(animationController: animationController),
          )
      );
    } else {
      showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          transitionAnimationController: animationControllerBottomSheet,
          builder: (BuildContext context) {
            return
              SlideInUp(
                child: Container(
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
                      Row(
                        children: <Widget>[
                          SizedBox(width: 35),
                          Image.asset('assets/images/not_access.png', height: 80, width: 80),
                          Padding(
                              padding: const EdgeInsets.only( left: 20),
                              child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text('Mohon maaf,',
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
                                    child: Text('Anda tidak dapat mengakses menu ini, hubungi IT jika terjadi kekeliruan',
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
  } else if(idMenu=='5'){ // Appointment
    if(prefs!.getString("data_NIK").toString()=='2151010115'){

      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => AppointmentApproverScreen(animationController: animationController),
          )
      );

    } else {
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
                      Row(
                        children: <Widget>[
                          SizedBox(width: 35),
                          Image.asset('assets/images/not_access.png', height: 80, width: 80),
                          Padding(
                              padding: const EdgeInsets.only( left: 20),
                              child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text('Mohon maaf,',
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
                                    child: Text('Anda tidak dapat mengakses menu ini, hubungi IT jika terjadi kekeliruan',
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
