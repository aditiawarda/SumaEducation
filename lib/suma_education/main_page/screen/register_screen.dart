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
import 'dart:async';

import 'package:suma_education/suma_education/main_page/screen/login_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/register_success_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key, required this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey5 = GlobalKey<FormState>();
  var txtEditEmail = TextEditingController();
  var txtEditNamaLengkap = TextEditingController();
  var txtEditNoHP = TextEditingController();
  var txtEditPassword = TextEditingController();
  var txtEditRepassword = TextEditingController();
  String gender = "";
  Animation<double>? animation;

  // Initially password is obscure
  bool _isObscure = true;
  bool _isObscure2 = true;
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

  void _toggle_2() {
    setState(() {
      _isObscure2 = !_isObscure2;
    });
  }

  void _load() {
    setState(() {
      loginLoad = !loginLoad;
    });
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
          ] else if (fungsi == 'nama_lengkap') ...[
            Form(
                key: _formKey2,
                child: TextFormField(
                  obscureText: false,
                  controller: txtEditNamaLengkap,
                  textInputAction: TextInputAction.next,
                  //autofocus: true,
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    color: const Color(0xFF151624),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  cursorColor: const Color(0xFF151624),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Nama lengkap wajib di isi ya.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Nama Lengkap',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: const Color(0xFF151624).withOpacity(0.5),
                    ),
                    fillColor: txtEditNamaLengkap.text.isNotEmpty
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
                      Icons.tag_faces,
                      color: const Color(0xFF151624).withOpacity(0.5),
                      size: 17,
                    ),
                  ),
                ),
              ),
          ] else if (fungsi == 'jenis_kelamin') ...[
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: new BorderRadius.all(const Radius.circular(15.0))
                ),
              child: Column(
                children: [
                  RadioListTile(
                    title:
                    Text('Laki-laki',
                        style: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            color: Colors.grey.shade700
                        )
                    ),
                    value: "Laki-laki",
                    groupValue: gender,
                    onChanged: (value){
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Perempuan',
                        style: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            color: Colors.grey.shade700
                        )
                    ),
                    value: "Perempuan",
                    groupValue: gender,
                    onChanged: (value){
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                ],
              )
            )
          ] else if (fungsi == 'no_hp') ...[
            Form(
                key: _formKey3,
                child: TextFormField(
                  obscureText: false,
                  controller: txtEditNoHP,
                  textInputAction: TextInputAction.next,
                  //autofocus: true,
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    color: const Color(0xFF151624),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  cursorColor: const Color(0xFF151624),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Nama HP wajib di isi ya.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Nomor Handphone',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: const Color(0xFF151624).withOpacity(0.5),
                    ),
                    fillColor: txtEditNoHP.text.isNotEmpty
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
                      Icons.phone_android_rounded,
                      color: const Color(0xFF151624).withOpacity(0.5),
                      size: 17,
                    ),
                  ),
                ),
              ),
          ] else if (fungsi == 'password') ...[
            Form(
                key: _formKey4,
                child: TextFormField(
                  controller: txtEditPassword,
                  textInputAction: TextInputAction.next,
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
          ] else if (fungsi == 'repassword') ...[
            Form(
                key: _formKey5,
                child: TextFormField(
                  controller: txtEditRepassword,
                  textInputAction: TextInputAction.done,
                  obscureText: _isObscure2,
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    color: const Color(0xFF151624),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: const Color(0xFF151624),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Re-Password wajib di isi ya.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Re-Password',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: const Color(0xFF151624).withOpacity(0.5),
                    ),
                    fillColor: txtEditRepassword.text.isNotEmpty
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
                      Icons.lock_person,
                      color: const Color(0xFF151624).withOpacity(0.5),
                      size: 16,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _toggle_2();
                      },
                      child: Icon(
                        _isObscure2 ? Icons.visibility : Icons
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
          if(txtEditNamaLengkap.text==""){
            if(txtEditNoHP.text==""){
              if(txtEditPassword.text==""){
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi semua data',
                    );
                  } else {
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
                      text: 'Harap isi email, nama lengkap, gender, no hp dan password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi email, nama lengkap, gender, no hp dan password',
                    );
                  } else {
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
                      text: 'Harap isi email, nama lengkap, no hp dan password',
                    );
                  }
                }
              } else {
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi email, nama lengkap, gender, no hp dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi email, nama lengkap, no hp dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi email, nama lengkap, gender dan no hp',
                    );
                  } else {
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
                      text: 'Harap isi email, nama lengkap dan no hp',
                    );
                  }
                }
              }
            } else {
              if(txtEditPassword.text==""){
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi email, nama lengkap, gender, password dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi email, nama lengkap, password dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi email, nama lengkap, gender dan password',
                    );
                  } else {
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
                      text: 'Harap isi email, nama lengkap dan password',
                    );
                  }
                }
              } else {
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi email, nama lengkap, gender dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi email, nama lengkap dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi email, nama lengkap dan gender',
                    );
                  } else {
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
                      text: 'Harap isi email dan nama lengkap',
                    );
                  }
                }
              }
            }
          } else {
            if(txtEditNoHP.text==""){
              if(txtEditPassword.text==""){
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi email, gender, no hp, password dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi email, no hp, password dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi email, gender, no hp dan password',
                    );
                  } else {
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
                      text: 'Harap isi email, no hp dan password',
                    );
                  }
                }
              } else {
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi email, gender, no hp dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi email, no hp dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi email, gender dan no hp',
                    );
                  } else {
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
                      text: 'Harap isi email dan no hp',
                    );
                  }
                }
              }
            } else {
              if(txtEditPassword.text==""){
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi email, gender, password dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi email, password dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi email, gender dan password',
                    );
                  } else {
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
                  }
                }
              } else {
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi email, gender dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi email dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi email dan gender',
                    );
                  } else {
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
                      text: 'Harap isi email',
                    );
                  }
                }
              }
            }
          }
        }
        else {
          if(txtEditNamaLengkap.text==""){
            if(txtEditNoHP.text==""){
              if(txtEditPassword.text==""){
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi nama lengkap, gender, no hp, password dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi nama lengkap, no hp, password dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi nama lengkap, gender, no hp dan password',
                    );
                  } else {
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
                      text: 'Harap isi nama lengkap, no hp dan password',
                    );
                  }
                }
              } else {
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi nama lengkap, gender, no hp dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi nama lengkap, no hp dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi email, gender, nama lengkap dan no hp',
                    );
                  } else {
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
                      text: 'Harap isi email, nama lengkap dan no hp',
                    );
                  }
                }
              }
            } else {
              if(txtEditPassword.text==""){
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi nama lengkap, gender, password dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi nama lengkap, password dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi nama lengkap, gender dan password',
                    );
                  } else {
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
                      text: 'Harap isi nama lengkap dan password',
                    );
                  }
                }
              } else {
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi nama lengkap, gender dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi nama lengkap dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi nama lengkap dan gender',
                    );
                  } else {
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
                      text: 'Harap isi nama lengkap',
                    );
                  }
                }
              }
            }
          } else {
            if(txtEditNoHP.text==""){
              if(txtEditPassword.text==""){
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi gender, no hp, password dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi no hp, password dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi gender, no hp dan password',
                    );
                  } else {
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
                      text: 'Harap isi no hp dan password',
                    );
                  }
                }
              } else {
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi gender, no hp dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi no hp dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi gender no hp',
                    );
                  } else {
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
                      text: 'Harap isi no hp',
                    );
                  }
                }
              }
            } else {
              if(txtEditPassword.text==""){
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi gender, password dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi password dan re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi gender dan password',
                    );
                  } else {
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
                      text: 'Harap isi password',
                    );
                  }
                }
              } else {
                if(txtEditRepassword.text==""){
                  if(gender==""){
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
                      text: 'Harap isi gender dan re-password',
                    );
                  } else {
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
                      text: 'Harap isi re-password',
                    );
                  }
                }
                else {
                  if(gender==""){
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
                      text: 'Harap isi gender',
                    );
                  } else {
                    if(txtEditPassword.text!=txtEditRepassword.text){
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
                        text: 'Password dan re-password tidak cocok',
                      );
                    } else {
                      _load();
                      regisFunction();
                    }
                  }
                }
              }
            }
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
              'Registrasi',
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


  void regisFunction() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/registrasi_akun"),
          body: {
            "email"         : txtEditEmail.text,
            "username"      : txtEditNamaLengkap.text,
            "no_telp"       : txtEditNoHP.text,
            "jenis_kelamin" : gender,
            "password"      : txtEditPassword.text,
          });

      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        print('Registrasi berhasil');

        new Future.delayed(new Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => RegisterSuccessScreen(animationController: widget.animationController),
              )
          );
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => RegisterSuccessScreen(animationController: widget.animationController)
          //     ),
          //     ModalRoute.withName("/Home")
          // );
          // Navigator.push<dynamic>(
          //     context,
          //     MaterialPageRoute<dynamic>(
          //       builder: (BuildContext context) => RegisterSuccessScreen(animationController: widget.animationController),
          //     )
          // );
        });

      } else {
        _load();
        print('Registrasi gagal');
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

  Widget _formWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email", "email"),
        _entryField("Nama Lengkap", "nama_lengkap"),
        _entryField("Jenis Kelamin", "jenis_kelamin"),
        _entryField("Nomor Handphone", "no_hp"),
        _entryField("Password", "password", isPassword: true),
        _entryField("Re-Password", "repassword", isPassword: true),
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
                                SizedBox(height: 100),
                                FadeInUp(
                                  delay: Duration(milliseconds: 500),
                                  child: Text(
                                    'REGISTRASI AKUN',
                                    style: GoogleFonts.inter(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
                                          _formWidget(),
                                          SizedBox(height: 20),
                                          _submitButton(),
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
                                        'Sudah punya akun?',
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
                                                  builder: (BuildContext context) => LoginScreen(animationController: widget.animationController),
                                                )
                                            );
                                          });
                                        },
                                        child:
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 50),
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
      delay: Duration(milliseconds: 100),
      child: Stack(
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
