// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file_plus/open_file_plus.dart';
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
  var _openResult = 'Unknown';

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

  _openFile(String filename) async {
    final filePath = '/storage/emulated/0/Download/Suma/'+filename;
    final result = await OpenFile.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
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
                child:
                Container(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                    margin: EdgeInsets.only(top: 10),
                    child: ZoomTapAnimation(
                      onTap: () async {
                        _permissionReady = await _checkPermission();
                        if (_permissionReady) {
                          await _prepareSaveDir();
                          print(widget.linkDownload!);

                          Random random = new Random();
                          int randomNumber = random.nextInt(100);

                          var now = new DateTime.now();
                          var formatter = new DateFormat('yyyy-MM-dd');
                          String formattedDate = formatter.format(now);
                          String filename = "interaktif_template_"+formattedDate+"_"+randomNumber.toString()+".pdf";

                          CoolAlert.show(
                              context: context,
                              borderRadius: 25,
                              type: CoolAlertType.loading,
                              backgroundColor: Colors.lightGreen.shade50,
                              title: 'Downloading',
                              autoCloseDuration: Duration(milliseconds: 1990),
                              width: 30,
                              loopAnimation: true,
                              animType: CoolAlertAnimType.scale,
                          );

                          new Future.delayed(new Duration(milliseconds: 2000), () {
                            CoolAlert.show(
                                context: context,
                                borderRadius: 25,
                                type: CoolAlertType.success,
                                backgroundColor: Colors.lightGreen.shade50,
                                title: 'Berhasil',
                                text: "Template berhasil didownload, kamu bisa cek filenya di folder download pada perangkatmu",
                                width: 30,
                                loopAnimation: false,
                                confirmBtnText: 'Buka Template',
                                cancelBtnText: 'Tutup',
                                animType: CoolAlertAnimType.scale,
                                confirmBtnColor: Colors.green.shade300,
                                onCancelBtnTap: (){
                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                },
                                onConfirmBtnTap: (){
                                  _openFile(filename);
                                }
                            );
                          });

                          try {
                            await Dio().download(widget.linkDownload!,
                                _localPath + "/" + filename);
                            print("Download Completed.");
                          } catch (e) {
                            print("Download Failed.\n\n" + e.toString());
                          }
                        }
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.grey.withOpacity(0.2),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 1.0),
                          ],
                        ),
                        margin: EdgeInsets.only(bottom: 0),
                        child:
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, right: 9, left: 9),
                          child: Center(
                            child:
                            Text('Download Template', style: TextStyle(color: Colors.white, fontSize: 17)),
                          ),
                        ),
                      ),
                    )
                )
              ),
            ),
          );
      },
    );
  }


}

