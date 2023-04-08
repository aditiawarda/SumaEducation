import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:suma_education/suma_education/main_page/screen/login_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key, required this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

String email_global = "";

class _ForgotPageState extends State<ForgotPasswordScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  TextEditingController _Email = TextEditingController();

  TextEditingController _password = TextEditingController();
  TextEditingController _password2 = TextEditingController();

  TextEditingController _code1 = TextEditingController();
  TextEditingController _code2 = TextEditingController();
  TextEditingController _code3 = TextEditingController();
  TextEditingController _code4 = TextEditingController();

  bool _enabledButton = true;
  bool _isObscure = true;
  bool _isObscure2 = true;
  int secondsRemaining = 180;
  bool enableResend = false;
  late Timer timer;
  Timer? _timer;

  initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });

    timer = Timer.periodic(
      Duration(seconds: 1),
      (_) {
        if (secondsRemaining != 0) {
          setState(() {
            secondsRemaining--;
            // print(secondsRemaining);
          });
        } else {
          setState(() {
            enableResend = true;
          });
        }
      },
    );
  }

  dispose() {
    timer.cancel();
    super.dispose();
  }

  void UpdateStatusOTP() async {
    var response = await http.post(
        Uri.parse("https://suma.geloraaksara.co.id/api2/UpdateStatusOTP"),
        body: {
          'email': email_global,
        });

    var json = jsonDecode(response.body);
    print(json);
  }

  void ResendCode() async {
    EasyLoading.show(status: 'Tunggu sebentar...');
    var response = await http.post(
        Uri.parse("https://suma.geloraaksara.co.id/api2/ForgotPassword"),
        body: {
          'email': _Email.text,
          'waktu': DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
        });

    var json = jsonDecode(response.body);
    String status = json["status"];
    String message = json["pesan"];
    print(json);

    if (status == '200') {
      EasyLoading.showSuccess(message);
      setState(() {
        secondsRemaining = 180;
        enableResend = false;
      });
      EasyLoading.dismiss();
    } else {
      EasyLoading.showError(message);
      EasyLoading.dismiss();
    }
  }

  void SendEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _enabledButton = false;
    });
    EasyLoading.show(status: 'Tunggu sebentar...');

    var response = await http.post(
        Uri.parse("https://suma.geloraaksara.co.id/api2/ForgotPassword"),
        body: {
          'email': _Email.text,
          'waktu': DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
        });

    var json = jsonDecode(response.body);
    String status = json["status"];
    String message = json["pesan"];
    print(json);

    if (status == '200') {
      EasyLoading.showSuccess(message);
      setState(() {
        secondsRemaining = 180;
        enableResend = false;
      });
      email_global = json["email"];
      showModalBottomOTP(context);
      EasyLoading.dismiss();
    } else {
      setState(() {
        _enabledButton = true;
      });
      EasyLoading.showError(message);
      EasyLoading.dismiss();
    }
  }

  showAlertDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kamu Yakin?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Jika Kamu meninggalkan halaman ini, Kamu harus kirim ulang kode OTP.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
                _code1.text = "";
                _code2.text = "";
                _code3.text = "";
                _code4.text = "";
                _password.text = "";
                _password2.text = "";
                _isObscure = true;
                _isObscure2 = true;
              },
            ),
          ],
        );
      },
    );
  }

  void VerifOTP() async {
    if (!_formKey2.currentState!.validate()) {
      return;
    }
    EasyLoading.show(status: 'Tunggu sebentar...');
    var response = await http.post(
        Uri.parse("https://suma.geloraaksara.co.id/api2/VerifOTP_ForgotPass"),
        body: {
          'email': email_global,
          'code1': _code1.text,
          'code2': _code2.text,
          'code3': _code3.text,
          'code4': _code4.text,
        });

    var json = jsonDecode(response.body);
    String status = json["status"];
    String message = json["pesan"];
    print(json);
    if (status == '200') {
      EasyLoading.showSuccess(message);
      Navigator.pop(context);
      ShowModalCreateNewPass(context);
      EasyLoading.dismiss();
    } else {
      EasyLoading.showError(message);
      EasyLoading.dismiss();
    }
  }

  void CreateNEWPassword() async {
    if (!_formKey3.currentState!.validate()) {
      return;
    }
    EasyLoading.show(status: 'Tunggu sebentar...');
    var response = await http.post(
        Uri.parse("https://suma.geloraaksara.co.id/api2/CreateNewPassword"),
        body: {
          'email': email_global,
          'password': _password.text,
        });
    var json = jsonDecode(response.body);
    String status = json["status"];
    String message = json["pesan"];
    print(json);
    if (status == '200') {
      EasyLoading.showSuccess(message);
      Navigator.of(context).pushNamedAndRemoveUntil;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(animationController: widget.animationController)),
      );
      EasyLoading.dismiss();
    } else {
      EasyLoading.showError(message);
      EasyLoading.dismiss();
    }
  }

  ShowModalCreateNewPass(BuildContext context) {
    return showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) => WillPopScope(
        onWillPop: () async {
          final shouldPop = await showAlertDialog(context);

          return shouldPop;
        },
        child: Wrap(
          children: [
            Center(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "Buat Password Baru",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Pastikan Password baru Kamu unik ya.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 0)),
                        builder: (context, snapshot) {
                          return TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Password wajib di isi ya.';
                              }
                              return null;
                            },
                            controller: _password,
                            obscureText: _isObscure,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.green,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.green,
                                ),
                              ),
                              hintText: 'Masukan Password baru Kamu',
                              suffixIcon: IconButton(
                                color: Colors.black,
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(
                                    () {
                                      _isObscure = !_isObscure;
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 0)),
                        builder: (context, snapshot) {
                          return TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Konfirmasi Password wajib di isi ya.';
                              }
                              if (_password.text != _password2.text) {
                                return "Password Tidak Sesuai";
                              }
                              return null;
                            },
                            controller: _password2,
                            obscureText: _isObscure2,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.green,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.green,
                                ),
                              ),
                              hintText: 'Konfirmasi ulang password kamu',
                              suffixIcon: IconButton(
                                color: Colors.black,
                                icon: Icon(_isObscure2
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(
                                    () {
                                      _isObscure2 = !_isObscure2;
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      width: 200,
                      height: 100,
                      child: InkWell(
                        onTap: () {
                          CreateNEWPassword();
                        },
                        child: Card(
                          elevation: 15,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFFFA7D09),
                                  Color(0xFFFF4301),
                                ],
                              ),
                            ),
                            child: Text(
                              "SIMPAN",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, top: 30),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showModalBottomOTP(BuildContext context) {
    return showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) => WillPopScope(
        onWillPop: () async {
          final shouldPop = await showAlertDialog(context);

          return shouldPop;
        },
        child: Wrap(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "Masukan 4 Digit Kode OTP",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Masukan 4 Digit Kode OTP yang sudah kamu terima di Email Kamu.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (enableResend == true) {
                              ResendCode();
                              Future.delayed(Duration(seconds: 180), () {
                                UpdateStatusOTP();
                              });
                            } else {
                              return;
                            }
                          },
                          child: Text(
                            "Kirim ulang kode",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        StreamBuilder(
                            stream: Stream.periodic(const Duration(seconds: 1)),
                            builder: (context, snapshot) {
                              // return Countdown(
                              //   animation: StepTween(
                              //     begin: levelClock * 60, // convert to seconds here
                              //     end: 0,
                              //   ).animate(_controller),
                              // );
                              return Visibility(
                                visible: secondsRemaining == 0 ? false : true,
                                child: Text(
                                  'setelah $secondsRemaining detik',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Form(
                      key: _formKey2,
                      child: Row(
                        children: [
                          Spacer(
                            flex: 3,
                          ),
                          SizedBox(
                            height: 68,
                            width: 64,
                            child: TextFormField(
                              controller: _code1,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Isi ya.';
                                }
                                return null;
                              },
                              cursorColor: Colors.green,
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                // hintText: "0",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // borderSide: BorderSide(color: Colors.orange)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.green,
                                    )),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          SizedBox(
                            height: 68,
                            width: 64,
                            child: TextFormField(
                              controller: _code2,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Isi ya.';
                                }
                                return null;
                              },
                              cursorColor: Colors.green,
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                // hintText: "0",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // borderSide: BorderSide(color: Colors.orange)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.green,
                                    )),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          SizedBox(
                            height: 68,
                            width: 64,
                            child: TextFormField(
                              controller: _code3,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Isi ya.';
                                }
                                return null;
                              },
                              cursorColor: Colors.green,
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                // hintText: "0",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // borderSide: BorderSide(color: Colors.orange)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.green,
                                    )),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          SizedBox(
                            height: 68,
                            width: 64,
                            child: TextFormField(
                              controller: _code4,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Isi ya.';
                                }
                                return null;
                              },
                              cursorColor: Colors.green,
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                // hintText: "0",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // borderSide: BorderSide(color: Colors.orange)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.green,
                                    )),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          ),
                          Spacer(
                            flex: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    width: 200,
                    height: 100,
                    child: InkWell(
                      onTap: () {
                        // Navigator.pop(context);
                        VerifOTP();
                      },
                      child: Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color(0xFFFA7D09),
                                Color(0xFFFF4301),
                              ],
                            ),
                          ),
                          child: Text(
                            "VERIFY",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, top: 30),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFFFF7A00),
                Color(0xFFFFA931),
              ],
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background_before_login.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: null /* add child content here */,
              ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    alignment: Alignment.center,
                    child: Text(
                      "Lupa Password?",
                      style: TextStyle(
                        fontSize: 20, color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: Image(
                      width: 180,
                      height: 70,
                      image: AssetImage("assets/images/ic_forgot.png"),
                        fit: BoxFit.fill,
                    ),
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Container(
                      // color: Colors.red,
                        width: 300,
                        height: 260,
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 50),
                              child: Card(
                                elevation: 30,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.white,
                                child: Stack(
                                  children: [
                                    SingleChildScrollView(
                                      physics: NeverScrollableScrollPhysics(),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                                            alignment: Alignment.center,
                                            child: TextFormField(
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return 'Email wajib di isi ya.';
                                                }
                                                if (!EmailValidator.validate(value)) {
                                                  return 'Masukan Email yang Valid ya.';
                                                }
                                                return null;
                                              },
                                              controller: _Email,
                                              keyboardType: TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                hintText: 'Masukan Email Kamu',
                                                labelText: 'Email',
                                                prefixIcon: Align(
                                                  widthFactor: 1.0,
                                                  heightFactor: 1.0,
                                                  child: Icon(
                                                    Icons.email,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: Text(
                                              '*Masukkan email yang terdaftar',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height / 10,
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                alignment: Alignment.center,
                                width: 200,
                                height: 60,
                                child:
                                ZoomTapAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        new Future.delayed(new Duration(milliseconds: 300), () {
                                          if (_enabledButton == true) {
                                            SendEmail();
                                            Future.delayed(Duration(seconds: 60), () {
                                              UpdateStatusOTP();
                                            });
                                          } else {
                                            return;
                                          }
                                        });
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15.0),
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Color(0xFFFA7D09),
                                                Color(0xFFFF4301),
                                              ],
                                            ),
                                          ),
                                          child: Text(
                                            "SEND",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                ),

                              ),
                            )
                          ],
                        )
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Visibility(
      visible: "$timerText" == '0:00' ? false : true,
      child: Text(
        "Setelah" + " " + "$timerText",
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
