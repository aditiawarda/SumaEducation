import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String? judulKonten = "";
String? deskripsiKonten = "";

class VideoDetail extends StatefulWidget {
  const VideoDetail(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.idContent})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String idContent;

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
                        left: 15, right: 15, top: 0, bottom: 0),
                    child:
                    Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15, right: 17, left: 17),
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
                      FutureBuilder<String>(
                        future: _getDetailKonten(), // function where you call your api
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return
                              Column(
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
                                          color: Colors.blueGrey.withOpacity(0.8)
                                      ),
                                    ),
                                  )
                                ],
                              );
                          } else {
                            if (snapshot.hasError)
                              return
                                Column(
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
                                            color: Colors.blueGrey.withOpacity(0.8)
                                        ),
                                      ),
                                    )
                                  ],
                                );
                            else
                              return
                                Column(
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
                                            color: Colors.blueGrey.withOpacity(0.8)
                                        ),
                                      ),
                                    )
                                  ],
                                );
                          }
                        },
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

