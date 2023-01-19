import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:suma_education/suma_education/main_page/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class InteraktifEquipment extends StatefulWidget {
  const InteraktifEquipment(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.linkDownload})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? linkDownload;

  @override
  _InteraktifEquipmentState createState() => _InteraktifEquipmentState();
}

class _InteraktifEquipmentState extends State<InteraktifEquipment>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool logoutLoad = false;

  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    super.initState();
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Download/Suma";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
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
                        left: 24, right: 24, bottom: 18),
                    child:
                    ZoomTapAnimation(
                      child:
                      GestureDetector(
                        onTap: () async {
                          _permissionReady = await _checkPermission();
                          if (_permissionReady) {
                            await _prepareSaveDir();
                            print(widget.linkDownload!);

                            CoolAlert.show(
                                context: context,
                                borderRadius: 25,
                                type: CoolAlertType.success,
                                backgroundColor: Colors.lightGreen.shade50,
                                title: 'Berhasil',
                                text: "Equipment berhasil didownload",
                                confirmBtnText: 'OK',
                                width: 30,
                                loopAnimation: true,
                                animType: CoolAlertAnimType.scale,
                                confirmBtnColor: Colors.green.shade300,
                                onConfirmBtnTap: (){
                                  setState(() {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  });
                                }
                            );

                            try {
                              await Dio().download(widget.linkDownload!,
                                  _localPath + "/" + "interaktif_1.pdf");
                              print("Download Completed.");
                            } catch (e) {
                              print("Download Failed.\n\n" + e.toString());
                            }
                          }
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.white,
                              Colors.orange.shade50
                            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            border: Border.all(color: Colors.orange.shade200.withOpacity(0.8)),
                            color: Colors.orange,
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
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10, right: 9, left: 9),
                            child: Center(
                                child:
                                Text('Download Equipment', style: TextStyle(color: Colors.orange.withOpacity(0.7), fontSize: 17)),
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

