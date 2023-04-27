import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/screen/interaktif_video_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/kreasi_video_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/tutorial_video_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MoreVideo extends StatefulWidget {
  const MoreVideo(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.idCategory})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String idCategory;

  @override
  _MoreVideoState createState() => _MoreVideoState();
}

class _MoreVideoState extends State<MoreVideo>
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

  @override
  Widget build(BuildContext context) {
    animationController?.forward();
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return
          FadeInUp(
            delay: Duration(milliseconds: 800),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20,),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'VIDEO SERUPA',
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20,),
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child:
                  ZoomTapAnimation(
                    onTap: () {
                      new Future.delayed(new Duration(milliseconds: 300), () {
                        if(widget.idCategory=='1'){
                          Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => KreasiScreen(animationController: animationController),
                              )
                          );
                        } else if(widget.idCategory=='2'){
                          Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => InteraktifScreen(animationController: animationController),
                              )
                          );
                        } else if(widget.idCategory=='3'){
                          Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => TutorialScreen(animationController: animationController),
                              )
                          );
                        }
                      });
                    },
                    child: Text(
                      'Selengkapnya',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.normal,
                          fontSize: 16
                      ),
                    ),
                  ),
                )
              ],
            )
          );
      },
    );
  }
}

