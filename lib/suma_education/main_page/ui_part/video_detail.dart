import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String? judulKonten = "";
String? deskripsiKonten = "";
String? durasiKonten = "";
String? viewerKonten = "";

class VideoDetail extends StatefulWidget {
  const VideoDetail(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.idContent, required this.paddingBottom})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String idContent;
  final double paddingBottom;

  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool logoutLoad = false;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _getDetailKonten();
    super.initState();
  }

  Future<String> _getDetailKonten() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/get_detail_content"),
          body: {
            "id" : widget.idContent,
          });
      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        print('Success');
        judulKonten     = json["data"]["judul"].toString();
        deskripsiKonten = json["data"]["deskripsi"].toString();
        durasiKonten = json["data"]["durasi"].toString();
        viewerKonten = json["data"]["viewer"].toString();
      } else {
        print('Gagal');
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15),
              child:
              Container(
                margin: EdgeInsets.only(bottom: widget.paddingBottom),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.2),
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0),
                  ],
                ),
                child:
                    Stack(
                      children: [
                        FutureBuilder<String>(
                          future: _getDetailKonten(), // function where you call your api
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          height: 33,
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade400,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft: Radius.circular(10.0),
                                                bottomRight: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0)),
                                          ),
                                        ),
                                        Positioned(
                                            right: 3,
                                            bottom: 8,
                                            child: new Align(
                                                alignment: FractionalOffset.bottomRight,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(7.0),
                                                          bottomLeft: Radius.circular(7.0),
                                                          bottomRight: Radius.circular(7.0),
                                                          topRight: Radius.circular(7.0)),
                                                    ),
                                                    margin: EdgeInsets.only(right: 5),
                                                    padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                                    child:
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(bottom: 1.5),
                                                          margin: EdgeInsets.only(right: 5),
                                                          alignment: Alignment.center,
                                                          child: Icon(FontAwesomeIcons.clock,color: Colors.white, size: 11),
                                                        ),
                                                        Text("00:00", style: TextStyle(color: Colors.white, fontSize: 12),),
                                                      ],
                                                    )
                                                )
                                            )
                                        ),
                                        Positioned(
                                            left: 3,
                                            bottom: 8,
                                            child: new Align(
                                                alignment: FractionalOffset.bottomLeft,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(7.0),
                                                          bottomLeft: Radius.circular(7.0),
                                                          bottomRight: Radius.circular(7.0),
                                                          topRight: Radius.circular(7.0)),
                                                    ),
                                                    margin: EdgeInsets.only(left: 5),
                                                    padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                                    child:
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(bottom: 1),
                                                          margin: EdgeInsets.only(right: 5),
                                                          alignment: Alignment.center,
                                                          child: Icon(FontAwesomeIcons.eye,color: Colors.white, size: 12),
                                                        ),
                                                        Text("0x ditonton", style: TextStyle(color: Colors.white, fontSize: 12),),
                                                      ],
                                                    )
                                                )
                                            )
                                        ),
                                      ],
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: 10, bottom: 45, left: 15, right: 15),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Memuat data...",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.roboto(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 1, right: 1, top: 8, bottom: 6),
                                              child: Container(
                                                height: 2,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.background.withOpacity(0.5),
                                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5, right: 5),
                                              child: Text("Memuat data...",
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 14,
                                                    height: 1.5,
                                                    color: Colors.blueGrey.withOpacity(0.8)
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  ],
                                );
                            } else {
                              if (snapshot.hasError)
                                return
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Container(
                                            height: 33,
                                            alignment: Alignment.bottomCenter,
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey.shade400,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10.0),
                                                  bottomLeft: Radius.circular(10.0),
                                                  bottomRight: Radius.circular(10.0),
                                                  topRight: Radius.circular(10.0)),
                                            ),
                                          ),
                                          Positioned(
                                              right: 3,
                                              bottom: 8,
                                              child: new Align(
                                                  alignment: FractionalOffset.bottomRight,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(7.0),
                                                            bottomLeft: Radius.circular(7.0),
                                                            bottomRight: Radius.circular(7.0),
                                                            topRight: Radius.circular(7.0)),
                                                      ),
                                                      margin: EdgeInsets.only(right: 5),
                                                      padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                                      child:
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(bottom: 1.5),
                                                            margin: EdgeInsets.only(right: 5),
                                                            alignment: Alignment.center,
                                                            child: Icon(FontAwesomeIcons.clock,color: Colors.white, size: 11),
                                                          ),
                                                          Text("00:00", style: TextStyle(color: Colors.white, fontSize: 12),),
                                                        ],
                                                      )
                                                  )
                                              )
                                          ),
                                          Positioned(
                                              left: 3,
                                              bottom: 8,
                                              child: new Align(
                                                  alignment: FractionalOffset.bottomLeft,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(7.0),
                                                            bottomLeft: Radius.circular(7.0),
                                                            bottomRight: Radius.circular(7.0),
                                                            topRight: Radius.circular(7.0)),
                                                      ),
                                                      margin: EdgeInsets.only(left: 5),
                                                      padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                                      child:
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(bottom: 1),
                                                            margin: EdgeInsets.only(right: 5),
                                                            alignment: Alignment.center,
                                                            child: Icon(FontAwesomeIcons.eye,color: Colors.white, size: 12),
                                                          ),
                                                          Text("0x ditonton", style: TextStyle(color: Colors.white, fontSize: 12),),
                                                        ],
                                                      )
                                                  )
                                              )
                                          ),
                                        ],
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 10, bottom: 45, left: 15, right: 15),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Memuat data...",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.roboto(
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 1, right: 1, top: 8, bottom: 6),
                                                child: Container(
                                                  height: 2,
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.background.withOpacity(0.5),
                                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 5, right: 5),
                                                child: Text("Memuat data...",
                                                  maxLines: 5,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      height: 1.5,
                                                      color: Colors.blueGrey.withOpacity(0.8)
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                    ],
                                  );
                              else
                                return
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Container(
                                            height: 33,
                                            alignment: Alignment.bottomCenter,
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey.shade400,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10.0),
                                                  bottomLeft: Radius.circular(10.0),
                                                  bottomRight: Radius.circular(10.0),
                                                  topRight: Radius.circular(10.0)),
                                            ),
                                          ),
                                          Positioned(
                                              right: 3,
                                              bottom: 8,
                                              child: new Align(
                                                  alignment: FractionalOffset.bottomRight,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(7.0),
                                                            bottomLeft: Radius.circular(7.0),
                                                            bottomRight: Radius.circular(7.0),
                                                            topRight: Radius.circular(7.0)),
                                                      ),
                                                      margin: EdgeInsets.only(right: 5),
                                                      padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                                      child:
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(bottom: 1.5),
                                                            margin: EdgeInsets.only(right: 5),
                                                            alignment: Alignment.center,
                                                            child: Icon(FontAwesomeIcons.clock,color: Colors.white, size: 11),
                                                          ),
                                                          Text(durasiKonten!.toString().substring(0, 5), style: TextStyle(color: Colors.white, fontSize: 12),),
                                                        ],
                                                      )
                                                  )
                                              )
                                          ),
                                          Positioned(
                                              left: 3,
                                              bottom: 8,
                                              child: new Align(
                                                  alignment: FractionalOffset.bottomLeft,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(7.0),
                                                            bottomLeft: Radius.circular(7.0),
                                                            bottomRight: Radius.circular(7.0),
                                                            topRight: Radius.circular(7.0)),
                                                      ),
                                                      margin: EdgeInsets.only(left: 5),
                                                      padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                                      child:
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(bottom: 1),
                                                            margin: EdgeInsets.only(right: 5),
                                                            alignment: Alignment.center,
                                                            child: Icon(FontAwesomeIcons.eye,color: Colors.white, size: 12),
                                                          ),
                                                          Text(viewerKonten!.toString()+"x ditonton", style: TextStyle(color: Colors.white, fontSize: 12),),
                                                        ],
                                                      )
                                                  )
                                              )
                                          ),
                                        ],
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 10, bottom: 45, left: 15, right: 15),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(judulKonten!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.roboto(
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 1, right: 1, top: 8, bottom: 6),
                                                child: Container(
                                                  height: 2,
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.background.withOpacity(0.5),
                                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 5, right: 5),
                                                child: Text(deskripsiKonten!,
                                                  maxLines: 5,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      height: 1.5,
                                                      color: Colors.blueGrey.withOpacity(0.8)
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                    ],
                                  );
                            }
                          },
                        ),
                        Positioned(
                          bottom: 12, left: 20,
                          child: Text("Copyright © 2023 Suma",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey.shade200
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 11, right: 10,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10, right: 33,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 11, right: 59,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.3),
                              shape: BoxShape.circle,
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

