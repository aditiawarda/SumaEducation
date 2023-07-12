// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ripple_animation/ripple_animation.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/main_page/bottom_navigation_view/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/screen/login_screen.dart';
import 'dart:async';

import 'package:suma_education/suma_education/main_page/screen/register_screen.dart';

class RegisterSuccessScreen extends StatefulWidget {
  const RegisterSuccessScreen({Key? key, required this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterSuccessScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  var txtEditEmail = TextEditingController();
  var txtEditPassword = TextEditingController();
  Animation<double>? animation;

  // Initially password is obscure
  bool _isObscure = true;
  bool loginLoad = false;
  bool enabledButton = true;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  initState() {
    super.initState();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController!,
        curve:
        Interval((1 / 5) * 1, 1.0, curve: Curves.fastOutSlowIn)));
  }

  void _toggle() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }


  Widget _successlogo() {
    return Container(
      child: Image.asset('assets/images/success_ic.gif',
        width: 95,
        height: 95,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _loginButton() {
    return
    InkWell(
      onTap: (){
        new Future.delayed(new Duration(milliseconds: 300), () {
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => LoginScreen(animationController: widget.animationController),
              )
          );
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.orange.shade600,
        ),
        child:
        Text(
          'Login Sekarang',
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body:
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background_main.png"),
                fit: BoxFit.none)),
        height: height,
        child: Stack(
          children: <Widget>[
            getBackWiget(),
            Positioned(
              child: new Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child:
                    FadeInUp(
                      delay: Duration(milliseconds: 500),
                      child: Text('Suma App v 1.1.4', style: TextStyle(color: Colors.blueGrey.withOpacity(0.7), fontSize: 14),),
                    ),
                  )
              )
            ),
            Container(
              child: SingleChildScrollView(
                child:
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 170),
                                FadeInUp(
                                  delay: Duration(milliseconds: 500),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: RippleAnimation(
                                            repeat: true,
                                            color: Colors.green,
                                            minRadius: 80,
                                            ripplesCount: 3, child: null,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(0.5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle
                                          ),
                                          child: _successlogo()
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40),
                                FadeInUp(
                                  delay: Duration(milliseconds: 500),
                                  child: Container(
                                      padding: EdgeInsets.only(top: 19, bottom: 28, left: 27, right: 27),
                                      decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.0),
                                            bottomLeft: Radius.circular(30.0),
                                            bottomRight: Radius.circular(30.0),
                                            topRight: Radius.circular(30.0)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: AppTheme.grey.withOpacity(0.2),
                                              offset: Offset(0.0, 1.0), //(x,y)
                                              blurRadius: 2.0),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 15),
                                            width: MediaQuery.of(context).size.width,
                                            child: Text('Yeay selamat registrasi akun kamu berhasil, kamu bisa login dengan akun mu sekarang.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontName,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18,
                                                    height: 1.3,
                                                    letterSpacing: 0.0,
                                                    color: AppTheme.grey.withOpacity(0.6)
                                                )
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          _loginButton(),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                    ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget getBackWiget() {
    return FadeInUp(
      delay: Duration(milliseconds: 500),
      child:
      Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 380),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: AppTheme.grey.withOpacity(0.2),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 4.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
