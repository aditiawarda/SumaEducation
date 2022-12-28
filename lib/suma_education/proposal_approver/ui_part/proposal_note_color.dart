import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:suma_education/main.dart';
import '../../app_theme/app_theme.dart';
import 'package:http/http.dart' as http;

class ProposalNoteColor extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ProposalNoteColor({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    final widthPart = fullWidth * 0.55;
    return
    AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return
          FadeInUp(
            delay : Duration(milliseconds: 500),
            child : FadeTransition(
              opacity: animation!,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - animation!.value), 0.0),
                child:
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 25, left: 20, right: 5),
                      margin: EdgeInsets.only(left: 23, right: 23, bottom: 15, top: 30),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topRight: Radius.circular(50.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.3),
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 3.0),
                        ],
                      ),
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 0,
                              top: 25,
                              right: 25,
                              bottom: 13,
                            ),
                            child: Text(
                              "Warna status proposal :",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                letterSpacing: 0.0,
                                color: AppTheme.grey.withOpacity(0.5),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            child:
                            Column(
                              children: [
                                Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 13,
                                        width: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: HexColor("#24a831"),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2.0),
                                              bottomLeft: Radius.circular(2.0),
                                              bottomRight: Radius.circular(2.0),
                                              topRight: Radius.circular(7.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: AppTheme.grey.withOpacity(0.1),
                                                offset: Offset(1.1, 1.1),
                                                blurRadius: 4.0),
                                          ],
                                        ),
                                        child: null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child:
                                        SizedBox(
                                          width: widthPart,
                                          child: Text('Diterima',
                                              style: TextStyle(fontFamily: AppTheme.fontName, fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 0.0, color: AppTheme.grey.withOpacity(0.6)
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 13,
                                        width: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: HexColor("#FA7D82"),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2.0),
                                              bottomLeft: Radius.circular(2.0),
                                              bottomRight: Radius.circular(2.0),
                                              topRight: Radius.circular(7.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: AppTheme.grey.withOpacity(0.1),
                                                offset: Offset(1.1, 1.1),
                                                blurRadius: 4.0),
                                          ],
                                        ),
                                        child: null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2,
                                        ),
                                        child:
                                        SizedBox(
                                          child: Text('Menunggu verifikasi Ibu Deborah Hutauruk',
                                              style: TextStyle(fontFamily: AppTheme.fontName, fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 0.0, color: AppTheme.grey.withOpacity(0.6)
                                              )
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 13,
                                        width: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: HexColor("#bc83ef"),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2.0),
                                              bottomLeft: Radius.circular(2.0),
                                              bottomRight: Radius.circular(2.0),
                                              topRight: Radius.circular(7.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: AppTheme.grey.withOpacity(0.1),
                                                offset: Offset(1.1, 1.1),
                                                blurRadius: 4.0),
                                          ],
                                        ),
                                        child: null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2,
                                        ),
                                        child:
                                        SizedBox(
                                          child: Text('Menunggu verifikasi Ibu Theresia Tunjung',
                                              style: TextStyle(fontFamily: AppTheme.fontName, fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 0.0, color: AppTheme.grey.withOpacity(0.6)
                                              )
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 13,
                                        width: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: HexColor("#187cb4"),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2.0),
                                              bottomLeft: Radius.circular(2.0),
                                              bottomRight: Radius.circular(2.0),
                                              topRight: Radius.circular(7.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: AppTheme.grey.withOpacity(0.1),
                                                offset: Offset(1.1, 1.1),
                                                blurRadius: 4.0),
                                          ],
                                        ),
                                        child: null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2,
                                        ),
                                        child:
                                        SizedBox(
                                          child: Text('Menunggu verifikasi Bapak Asrel Marpaung',
                                              style: TextStyle(fontFamily: AppTheme.fontName, fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 0.0, color: AppTheme.grey.withOpacity(0.6)
                                              )
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 13,
                                        width: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: HexColor("#c5a427"),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2.0),
                                              bottomLeft: Radius.circular(2.0),
                                              bottomRight: Radius.circular(2.0),
                                              topRight: Radius.circular(7.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: AppTheme.grey.withOpacity(0.1),
                                                offset: Offset(1.1, 1.1),
                                                blurRadius: 4.0),
                                          ],
                                        ),
                                        child: null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2,
                                        ),
                                        child:
                                        SizedBox(
                                          child: Text('Revisi',
                                              style: TextStyle(fontFamily: AppTheme.fontName, fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 0.0, color: AppTheme.grey.withOpacity(0.6)
                                              )
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 13,
                                        width: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: HexColor("#827a78"),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2.0),
                                              bottomLeft: Radius.circular(2.0),
                                              bottomRight: Radius.circular(2.0),
                                              topRight: Radius.circular(7.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: AppTheme.grey.withOpacity(0.1),
                                                offset: Offset(1.1, 1.1),
                                                blurRadius: 4.0),
                                          ],
                                        ),
                                        child: null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2,
                                        ),
                                        child:
                                        SizedBox(
                                          child: Text('Ditolak',
                                              style: TextStyle(fontFamily: AppTheme.fontName, fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 0.0, color: AppTheme.grey.withOpacity(0.6)
                                              )
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(left: 23, right: 23, bottom: 15, top: 30),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(50.0)),
                          child: SizedBox(
                            height: 74,
                            child: AspectRatio(
                              aspectRatio: 1.714,
                              child: Image.asset(
                                  "assets/suma_education/back.png"),
                            ),
                          ),
                        ),
                    ),
                  ],
                )
              ),
            ),
          );
      },
    );
  }
}
