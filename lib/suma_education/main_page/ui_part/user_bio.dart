// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/main_page/screen/login_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class UserBio extends StatefulWidget {
  const UserBio(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _UserBioState createState() => _UserBioState();
}

class _UserBioState extends State<UserBio>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String? namaUser = "";
  String? idUser = "";
  String? fotoProfil = "";
  String? emailUser = "";

  late File image;
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

  Future<String> _getUser() async {
    final SharedPreferences prefs = await _prefs;
    namaUser = prefs.getString("data_username")!;
    idUser = prefs.getString("data_id")!;

    try {
      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/profile_picture"),
          body: {
            "id": prefs.getString("data_id")!,
          });
      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        fotoProfil = json["filename"];
        emailUser  = json["email"];
        print(fotoProfil.toString());
      } else {
        print("error");
      }
    } catch (e) {
      print("error");
    }

    return 'true';

  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Future<Future> showImageSource(BuildContext context) async {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) =>
            SlideInUp(
              child: Container(
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
                      margin: EdgeInsets.only(top: 20, bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 15),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child:
                        ZoomTapAnimation(
                          onTap: () async {
                            Navigator.of(context).pop();
                            pickImageCamera();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.blue.shade600,
                            ),
                            child: Text(
                              'Camera',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child:
                        ZoomTapAnimation(
                          onTap: () {
                            Navigator.of(context).pop();
                            pickImageGallery();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.green.shade400,
                            ),
                            child: Text(
                              'Gallery',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child:
                        ZoomTapAnimation(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop('dialog');
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.orange.shade50,
                            ),
                            child: Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            )
    );
  }

  Future pickImageCamera() async {
    try {
      final picture = await ImagePicker().pickImage(source: ImageSource.camera);
      final cropped = await ImageCropper().cropImage(
        sourcePath: picture!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
      );

      if (picture == null) return;

      final imageTemporary = File(cropped!.path);

      setState(() {
        this.image = imageTemporary;
        String fileName = picture.path.split('/').last;
        uploadImg(fileName);
      });

    } on PlatformException catch (e) {
      print(e.toString()+' Gagal, Siahkan coba lagi');
    }
  }

  Future pickImageGallery() async {
    try {
      final picture = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picture == null) return;
      final cropped = await ImageCropper().cropImage(
        sourcePath: picture.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
      );

      final imageTemporary = File(cropped!.path);

      setState(() {
        this.image = imageTemporary;
        String fileName = picture.path.split('/').last;
        uploadImg(fileName);
      });

    } on PlatformException catch (e) {
      print(e.toString()+'Gagal, Siahkan coba lagi');
    }
  }

  void uploadImg(fileName) async {
    final SharedPreferences prefs = await _prefs;
    namaUser = prefs.getString("data_username")!;

    try {
      List<int> imageBytes = image.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api2/uploadProfileImg"),
          body: {
            'image'  : baseimage,
            'name'   : fileName,
            'id_user': idUser,
          });

      var json = jsonDecode(response.body);
      String status  = json["status"];
      String message = json["pesan"];

      if (status == '200') {
        String picture = json["data"]["picture"];
        setState(() {
          CoolAlert.show(
              context: context,
              borderRadius: 25,
              type: CoolAlertType.success,
              backgroundColor: Colors.lightGreen.shade50,
              title: 'Berhasil',
              text: 'Foto profil berhasil diperbaharui',
              width: 30,
              loopAnimation: false,
              confirmBtnText: 'OK',
              animType: CoolAlertAnimType.scale,
              confirmBtnColor: Colors.green.shade300,
              onConfirmBtnTap: (){
                Navigator.of(context, rootNavigator: true).pop('dialog');
              }
          );
        });
      } else {
        CoolAlert.show(
            context: context,
            borderRadius: 25,
            type: CoolAlertType.error,
            backgroundColor: Colors.lightGreen.shade50,
            title: 'Oops',
            text: 'Gagal memperbaharui foto profil',
            width: 30,
            loopAnimation: false,
            confirmBtnText: 'OK',
            animType: CoolAlertAnimType.scale,
            confirmBtnColor: Colors.green.shade300,
            onConfirmBtnTap: (){
              Navigator.of(context, rootNavigator: true).pop('dialog');
            }
        );
      }

    } catch (e) {
      print("Error during converting to Base64");
    }

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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return
          FadeInUp(
            delay: Duration(milliseconds: 500),
            child: FadeTransition(
              opacity: widget.mainScreenAnimation!,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 32, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/bg_header_main.png"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          topRight: Radius.circular(30.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.5),
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 3.0),
                      ],
                    ),
                    child:
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 23),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                        image: DecorationImage(
                                            image: AssetImage('assets/images/default_profile.jpg'),
                                            fit: BoxFit.contain
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      height: 90,
                                      child:
                                      Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.deepOrange.withOpacity(0.8),
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child:
                                    ZoomTapAnimation(
                                      onTap: () async {
                                        final source = await showImageSource(context);
                                        if (source == null) return;
                                      },
                                      child:FutureBuilder<String>(
                                        future: _getUser(),
                                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                                image: DecorationImage(
                                                    image: AssetImage('assets/images/default_profile.jpg'),
                                                    fit: BoxFit.contain
                                                ),
                                              ),
                                            );
                                          } else {
                                            if (snapshot.hasError)
                                              return Container(
                                                width: 90,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                                  image: DecorationImage(
                                                      image: AssetImage('assets/images/default_profile.jpg'),
                                                      fit: BoxFit.contain
                                                  ),
                                                ),
                                              );
                                            else
                                              return
                                                Container(
                                                  width: 90,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle, border: Border.all(color: Colors.white),
                                                    image: DecorationImage(
                                                        image: NetworkImage('https://suma.geloraaksara.co.id/uploads/profile_pic/'+fotoProfil!),
                                                        fit: BoxFit.contain
                                                    ),
                                                  ),
                                                );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        padding: EdgeInsets.only(right: 4, bottom: 2),
                                        alignment: Alignment.bottomRight,
                                        child:
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black.withOpacity(0.5)
                                          ),
                                          child: Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child:
                                FutureBuilder<String>(
                                  future: _getUser(),
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text("Memuat data...",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                          letterSpacing: 0.0,
                                          color: AppTheme.white,
                                        ),
                                      );
                                    } else {
                                      if (snapshot.hasError)
                                        return Text("Memuat data...",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 20,
                                            letterSpacing: 0.0,
                                            color: AppTheme.white,
                                          ),
                                        );
                                      else
                                        return Text(namaUser!,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 20,
                                            letterSpacing: 0.0,
                                            color: AppTheme.white,
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child:
                                FutureBuilder<String>(
                                  future: _getUser(),
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text("Memuat data...",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          letterSpacing: 0.0,
                                          color: AppTheme.white,
                                        ),
                                      );
                                    } else {
                                      if (snapshot.hasError)
                                        return Text("Memuat data...",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            letterSpacing: 0.0,
                                            color: AppTheme.white,
                                          ),
                                        );
                                      else
                                        return Text(emailUser!,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            letterSpacing: 0.0,
                                            color: AppTheme.white,
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child:
                          ZoomTapAnimation(
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
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.5),
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 1.0),
                                ],
                              ),
                              child:
                              Container(
                                child: logoutLoad ? Container(
                                  height: 9.0,
                                  width: 9.0,
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ) : Container(
                                  margin: EdgeInsets.only(left: 3),
                                  child:  Icon(
                                    Icons.logout,
                                    size: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
      },
    );
  }
}