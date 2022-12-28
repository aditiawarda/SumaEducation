import 'package:animate_do/animate_do.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';

import '../../app_theme/app_theme.dart';

class HelloPart extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const HelloPart({Key? key, this.animationController, this.animation})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      FadeInUp(
        delay : Duration(milliseconds: 500),
        child: AnimatedBuilder(
            animation: animationController!,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation!,
                child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 30 * (1.0 - animation!.value), 0.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 0, bottom: 24),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: HexColor("#D7E0F9"),
                                  gradient: LinearGradient(
                                    colors: <HexColor>[
                                      HexColor("#FA7D82"),
                                      HexColor("#FFB295"),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      bottomLeft: Radius.circular(25.0),
                                      bottomRight: Radius.circular(25.0),
                                      topRight: Radius.circular(25.0)
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.4),
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 10.0),
                                  ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 75, bottom: 12, right: 16, top: 12),
                                      child: Text(
                                        'Salam SUMAngat untuk Bapak/Ibu, selamat datang di Portal Proposal Gelora',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          letterSpacing: 0.0,
                                          color: AppTheme.white
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.asset("assets/portal_gelora/hello_suma.png"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      );
  }
}
