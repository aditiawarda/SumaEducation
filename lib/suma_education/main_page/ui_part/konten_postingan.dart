// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KontenPostingan extends StatefulWidget {
  const KontenPostingan(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.image, required this.deskripsi, required this.id})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? image;
  final String? deskripsi;
  final String? id;

  @override
  _KontenPostinganState createState() => _KontenPostinganState();

}

class _KontenPostinganState extends State<KontenPostingan>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  removeTimeline(String idContent, BuildContext context) async {
    try {
      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/remove_timeline"),
          body: {
            "id_content": idContent,
          });

      var json = jsonDecode(response.body);
      String status = json["status"];
      String message = json["message"];

      if (status == "Success") {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }

    } catch (e) {
      print("Error");
    }
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
                  child:
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.grey.withOpacity(0.5),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 3.0),
                          ],
                        ),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                  Image.asset(
                                    'assets/images/no_image_3.png',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                  Image.network(
                                    widget.image!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            if(widget.deskripsi!!=""&&widget.deskripsi!!="null")...{
                              Container(
                                  margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                                  child: Text(widget.deskripsi!,
                                    style: TextStyle(
                                        height: 1.4,
                                        fontSize: 15
                                    ),
                                  )
                              )
                            }
                          ],
                        ),
                      ),
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
                              text: 'Apakah kamu yakin menghapus postingan ini?',
                              confirmBtnText: 'OK',
                              cancelBtnText: 'Batal',
                              animType: CoolAlertAnimType.scale,
                              confirmBtnColor: Colors.orange.shade300,
                              onConfirmBtnTap: (){
                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                removeTimeline(widget.id.toString(), context);
                              }
                          );
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.deepOrange.shade300,
                              Colors.deepOrange.shade300
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
                          margin: EdgeInsets.only(bottom: 15, top: 15),
                          child:
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10, right: 9, left: 9),
                            child: Center(
                                child:
                                Text(
                                  'Hapus Postingan',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
      },
    );
  }
}

