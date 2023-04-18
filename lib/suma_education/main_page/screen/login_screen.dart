// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/main_page/bottom_navigation_view/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/screen/forgot_password.dart';
import 'dart:async';

import 'package:suma_education/suma_education/main_page/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen>
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

  void _load() {
    setState(() {
      loginLoad = !loginLoad;
    });
  }

  Widget _logoApp() {
    return Container(
      child: Image.asset('assets/images/sl_logo_app.png',
        width: 170,
        height: 170,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _entryField(String title, String fungsi, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
         if (fungsi == 'email') ...[
            Form(
                key: _formKey,
                child: TextFormField(
                  obscureText: false,
                  controller: txtEditEmail,
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    color: const Color(0xFF151624),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: const Color(0xFF151624),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Email wajib di isi ya.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: const Color(0xFF151624).withOpacity(0.5),
                    ),
                    fillColor: txtEditEmail.text.isNotEmpty
                        ? Colors.transparent
                        : const Color.fromRGBO(248, 247, 251, 1),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade100
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.orange.shade600,
                        )),
                    prefixIcon: Icon(
                      Icons.person,
                      color: const Color(0xFF151624).withOpacity(0.5),
                      size: 17,
                    ),
                  ),
                ),
              ),
          ] else if (fungsi == 'password') ...[
            Form(
                key: _formKey2,
                child: TextFormField(
                  controller: txtEditPassword,
                  obscureText: _isObscure,
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    color: const Color(0xFF151624),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: const Color(0xFF151624),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Password wajib di isi ya.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: const Color(0xFF151624).withOpacity(0.5),
                    ),
                    fillColor: txtEditPassword.text.isNotEmpty
                        ? Colors.transparent
                        : const Color.fromRGBO(248, 247, 251, 1),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade100
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.orange.shade600,
                        )),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: const Color(0xFF151624).withOpacity(0.5),
                      size: 16,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _toggle();
                      },
                      child: Icon(
                        _isObscure ? Icons.visibility : Icons
                            .visibility_off, color: const Color(0xFF151624).withOpacity(0.5),),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _submitButton() {
    return
    InkWell(
      onTap: (){
        if(txtEditEmail.text==""){
          if(txtEditPassword.text==""){
            CoolAlert.show(
              context: context,
              borderRadius: 25,
              width: 30,
              loopAnimation: false,
              type: CoolAlertType.error,
              animType: CoolAlertAnimType.scale,
              backgroundColor: Colors.red.shade100,
              confirmBtnColor: Colors.orange.shade300,
              title: 'Oops...',
              text: 'Harap isi email dan password',
            );
          } else {
            CoolAlert.show(
              context: context,
              borderRadius: 25,
              type: CoolAlertType.error,
              animType: CoolAlertAnimType.scale,
              backgroundColor: Colors.red.shade100,
              confirmBtnColor: Colors.orange.shade300,
              title: 'Oops...',
              text: 'Harap isi email',
              width: 30,
              loopAnimation: false,
            );
          }
        } else {
          if (txtEditPassword.text == "") {
            CoolAlert.show(
              context: context,
              borderRadius: 25,
              type: CoolAlertType.error,
              animType: CoolAlertAnimType.scale,
              backgroundColor: Colors.red.shade100,
              confirmBtnColor: Colors.orange.shade300,
              title: 'Oops...',
              text: 'Harap isi password',
              width: 30,
              loopAnimation: false,
            );
          } else {
            _load();
            loginFunction();
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.orange.shade600,
        ),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: loginLoad ?  SizedBox(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
                height: 13.0,
                width: 13.0,
              ) : null,
            ),
            Text(
              'Login',
              style: GoogleFonts.inter(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
    );
  }

  void loginFunction() async {
    final SharedPreferences prefs = await _prefs;
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/login_akun"),
          body: {
            "email"    : txtEditEmail.text,
            "password" : txtEditPassword.text,
          });

      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        print('Login berhasil');
        var id            = json["data"]["id"];
        var username      = json["data"]["username"];
        var email         = json["data"]["email"];
        var jenis_kelamin = json["data"]["jenis_kelamin"];
        var no_telp       = json["data"]["no_telp"];

        await prefs.setBool('login', true);
        await prefs.setString('data_id', id);
        await prefs.setString('data_username', username);
        await prefs.setString('data_email', email);
        await prefs.setString('data_jenis_kelamin', jenis_kelamin);
        await prefs.setString('data_no_telp', no_telp);

        new Future.delayed(new Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MainPage(),
              )
          );
        });

      } else {
        _load();
        print('Login gagal');
        var message = json["message"];

        CoolAlert.show(
          context: context,
          borderRadius: 25,
          type: CoolAlertType.error,
          backgroundColor: Colors.red.shade100,
          confirmBtnColor: Colors.orange.shade300,
          title: 'Oops...',
          text: message,
          width: 30,
          animType: CoolAlertAnimType.scale,
          loopAnimation: false,
        );

      }

    } catch (e) {
      _load();

      CoolAlert.show(
        context: context,
        borderRadius: 25,
        type: CoolAlertType.error,
        backgroundColor: Colors.red.shade100,
        confirmBtnColor: Colors.orange.shade300,
        title: 'Oops...',
        text: 'Tidak terhubung ke server',
        width: 30,
        animType: CoolAlertAnimType.scale,
        loopAnimation: false,
      );

      print("Error");
    }

  }

  Widget _idUsernamePasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email", "email"),
        _entryField("Password", "password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body:
      Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background_main.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null /* add child content here */,
            ),
            getBackWiget(),
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
                                SizedBox(height: 120),
                                FadeInUp(
                                  delay: Duration(milliseconds: 500),
                                  child: _logoApp(),
                                ),
                                SizedBox(height: 20),
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
                                          _idUsernamePasswordWidget(),
                                          SizedBox(height: 20),
                                          _submitButton(),
                                          SizedBox(height: 20),
                                          Container(
                                            margin: EdgeInsets.only(right: 10, top: 10, bottom: 8),
                                            width: double.infinity,
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) => ForgotPasswordScreen(animationController: widget.animationController)));
                                            },
                                            child: Text(
                                              'Lupa password?',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                                SizedBox(height: 30),
                                FadeInUp(
                                  delay: Duration(milliseconds: 500),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Belum punya akun?',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: (){
                                          new Future.delayed(new Duration(milliseconds: 300), () {
                                            Navigator.push<dynamic>(
                                                context,
                                                MaterialPageRoute<dynamic>(
                                                  builder: (BuildContext context) => RegisterScreen(animationController: widget.animationController),
                                                )
                                            );
                                          });
                                        },
                                        child:
                                          Text(
                                            'Registrasi',
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                      )
                                    ],
                                  ),
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
