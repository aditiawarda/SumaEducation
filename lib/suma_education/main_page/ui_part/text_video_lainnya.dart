import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TextVideoLainnya extends StatefulWidget {
  const TextVideoLainnya(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.kategori})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? kategori;

  @override
  _TextVideoLainnyaState createState() => _TextVideoLainnyaState();
}

class _TextVideoLainnyaState extends State<TextVideoLainnya>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool logoutLoad = false;

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
                  padding: const EdgeInsets.only(left: 25, right: 20, top: 15, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        'VIDEO '+widget.kategori!,
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                      Text(
                        ' LAINNYA',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
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

