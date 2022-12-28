import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:suma_education/main.dart';
import '../../app_theme/app_theme.dart';
import 'package:http/http.dart' as http;

class MainCompanyProfile extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const MainCompanyProfile({Key? key, this.animationController, this.animation})
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
                      padding: EdgeInsets.only(bottom: 25, left: 20, right: 20),
                      margin: EdgeInsets.only(left: 23, right: 23, bottom: 15, top: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
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
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 25,
                              right: 10,
                              bottom: 13,
                            ),
                            child: Text(
                              "Awal Dari Ide Kecil Kami",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                height: 1.5,
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                letterSpacing: 0.0,
                                color: AppTheme.grey.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 8,
                              right: 10,
                              bottom: 13,
                            ),
                            child: Text(
                              "Gelora Aksara Pratama memulai awalnya sebagai sebuah perusahaan cetak sederhana dengan hanya bermodalkan dua mesin cetak bekas yang dioperasikan oleh 20 karyawan di sebuah pabrik kecil.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                height: 1.5,
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                letterSpacing: 0.0,
                                color: AppTheme.grey.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 8,
                              right: 10,
                              bottom: 13,
                            ),
                            child: Text(
                              "Visi Gelora Aksara Pratama adalah untuk menjadi sebuah perusahaan cetak berteknologi tinggi yang dikenal luas terbukti memiliki produksi tepat waktu dan layanan yang memuaskan bagi setiap klien kami.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                height: 1.5,
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                letterSpacing: 0.0,
                                color: AppTheme.grey.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 8,
                              right: 10,
                              bottom: 13,
                            ),
                            child: Text(
                              "Selama dua dekade perjalanan Gelora Aksara Pratama, kami telah menjadi acuan industri melalui usaha keras kami untuk terus berkembang dan memperbaiki diri. Gelora Aksara Pratama kini mempekerjakan 500 tenaga ahli dan memiliki mesin cetak berkualitas internasional. Kami mendukung klien kami mewujudkan ide mereka menjadi sebuah terobosan dengan menerapkan kreatifitas, teknologi terdepan, keahlian teknis, serta manajemen waktu kami.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                height: 1.5,
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                letterSpacing: 0.0,
                                color: AppTheme.grey.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   alignment: Alignment.topRight,
                    //   margin: EdgeInsets.only(left: 23, right: 23, bottom: 15, top: 30),
                    //     child: ClipRRect(
                    //       borderRadius:
                    //       BorderRadius.only(
                    //           topLeft: Radius.circular(10.0),
                    //           bottomLeft: Radius.circular(10.0),
                    //           bottomRight: Radius.circular(10.0),
                    //           topRight: Radius.circular(50.0)),
                    //       child: SizedBox(
                    //         height: 74,
                    //         child: AspectRatio(
                    //           aspectRatio: 1.714,
                    //           child: Image.asset(
                    //               "assets/portal_app/back.png"),
                    //         ),
                    //       ),
                    //     ),
                    // ),
                  ],
                )
              ),
            ),
          );
      },
    );
  }
}
