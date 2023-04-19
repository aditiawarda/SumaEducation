import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:suma_education/suma_education/main_page/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool logoutLoad = false;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  void _load() {
    setState(() {
      logoutLoad = !logoutLoad;
    });
  }

  _logOut(BuildContext context) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('login', false);

    new Future.delayed(new Duration(milliseconds: 1500), () {
      _load();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(animationController: widget.mainScreenAnimationController),
          )
      );
    });
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
        return
          FadeInUp(
            delay: Duration(milliseconds: 800),
            child: FadeTransition(
              opacity: widget.mainScreenAnimation!,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 18),
                    child:
                    ZoomTapAnimation(
                      child:
                      GestureDetector(
                        onTap: () {
                          CoolAlert.show(
                              context: context,
                              title: 'Perhatian',
                              backgroundColor: Colors.lightBlue.shade50,
                              borderRadius: 25,
                              width: 30,
                              loopAnimation: false,
                              type: CoolAlertType.confirm,
                              text: 'Apakah kamu yakin untuk Logout?',
                              confirmBtnText: 'OK',
                              cancelBtnText: 'Batal',
                              animType: CoolAlertAnimType.scale,
                              confirmBtnColor: Colors.orange.shade300,
                              onConfirmBtnTap: (){
                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                _logOut(context);
                                _load();
                              }
                          );
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppTheme.white,
                              Colors.white
                            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.2),
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 3.0),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 15),
                          child:
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10, right: 9, left: 9),
                            child: Center(
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: logoutLoad ? Container(
                                        height: 13.0,
                                        width: 13.0,
                                        margin: EdgeInsets.only(right: 10),
                                        child: CircularProgressIndicator(
                                          color: Colors.deepOrange.withOpacity(0.8),
                                          strokeWidth: 2.5,
                                        ),
                                      ) : Container(
                                        margin: EdgeInsets.only(right: 6),
                                        child:  Icon(
                                          Icons.logout,
                                          size: 22,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Logout',
                                      style: GoogleFonts.inter(
                                        fontSize: 16.0,
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              ),
            ),
          );
      },
    );
  }
}

