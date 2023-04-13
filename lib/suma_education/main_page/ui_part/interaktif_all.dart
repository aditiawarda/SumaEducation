import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/interaktif_list_data.dart';
import 'package:suma_education/suma_education/main_page/screen/detail_video_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

SharedPreferences? prefs;

class InteraktifAllListData extends StatefulWidget {
  const InteraktifAllListData(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _InteraktifAllListDataState createState() => _InteraktifAllListDataState();
}

class _InteraktifAllListDataState extends State<InteraktifAllListData>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<InteraktifData> interaktifListData = [];

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _getInteraktifContent();
    super.initState();
  }

  Future<String> _getInteraktifContent() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/get_content_interaktif"),
          body: {
            "request": "request",
          });
      interaktifListData = [];
      var dataInteraktif = json.decode(response.body);
      print(dataInteraktif);
      for (var i = 0; i < dataInteraktif['data'].length; i++) {
        var id = dataInteraktif['data'][i]['id'];
        var judul = dataInteraktif['data'][i]['judul'];
        var thumbnail = dataInteraktif['data'][i]['thumbnail'];
        var durasi = dataInteraktif['data'][i]['durasi'];
        var youtube_id = dataInteraktif['data'][i]['youtube_id'];
        var kategori = dataInteraktif['data'][i]['kategori'];
        var created_at = dataInteraktif['data'][i]['created_at'];

        interaktifListData.add(InteraktifData(id, judul, thumbnail, durasi, youtube_id, kategori, created_at));
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
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
        width: MediaQuery.of(context).size.width,
        child:
        Wrap(
          children: <Widget>[
            FutureBuilder<String>(
              future: _getInteraktifContent(), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                        itemCount: interaktifListData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = interaktifListData.length;
                          final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                          animationController?.forward();
                          return itemVideoAll(interaktifListData[index], context, animationController!);
                        });
                    // GridView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //       childAspectRatio: 1.1,
                    //       crossAxisSpacing: 5,
                    //       mainAxisSpacing: 13),
                    //   itemCount: interaktifListData.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     final int count = interaktifListData.length;
                    //     final Animation<double> animation =
                    //     Tween<double>(begin: 0.0, end: 1.0).animate(
                    //         CurvedAnimation(
                    //             parent: animationController!,
                    //             curve: Interval((1 / count) * index, 1.0,
                    //                 curve: Curves.fastOutSlowIn)));
                    //     animationController?.forward();
                    //     var tinggi = MediaQuery.of(context).size.height;
                    //     var lebar = MediaQuery.of(context).size.width;
                    //     return itemAll(interaktifListData[index], context, lebar, tinggi, animationController!);
                    //   });
                } else {
                  if (snapshot.hasError)
                    return
                      GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5),
                          itemCount: interaktifListData.length,
                          itemBuilder: (BuildContext context, int index) {
                            final int count = interaktifListData.length;
                            final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                            animationController?.forward();
                            return itemVideoAll(interaktifListData[index], context, animationController!);
                          });
                  else
                    if(interaktifListData.length==0)
                      return
                      FadeInUp(
                        delay: Duration(milliseconds: 500),
                        child: Container(
                          margin: EdgeInsets.only(top: 130, bottom: 100),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Image.asset("assets/images/empty_data.png", height: 100),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Oops...',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                      color: Colors.blueGrey.shade200,
                                    ),
                                  ),
                                  Text(
                                    'Konten belum tersedia',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      letterSpacing: 0.5,
                                      color: Colors.blueGrey.shade200,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    else
                      return
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5),
                            itemCount: interaktifListData.length,
                            itemBuilder: (BuildContext context, int index) {
                              final int count = interaktifListData.length;
                              final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                              animationController?.forward();
                              return itemVideoAll(interaktifListData[index], context, animationController!);
                            });
                }
              },
            )
          ],
        ),
    );
  }
}

Widget itemVideoAll(InteraktifData interaktifListData, BuildContext context, AnimationController animationController){
  return
    FadeInUp(
        delay : Duration(milliseconds: 500),
        child : ZoomTapAnimation(
          child: GestureDetector(
            onTap: () {
              new Future.delayed(new Duration(milliseconds: 300), () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => DetailVideoScreen(animationController: animationController, idContent: interaktifListData.id, youtubeId: interaktifListData.youtube_id, kategoriKonten: interaktifListData.kategori),
                    )
                );
              });
            },
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                Container(
                  decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(9)),
                  child:
                  Column(
                    children: [
                      Wrap(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child:
                                Image.asset(
                                  'assets/images/no_image_3.png',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child:
                                Image.network(
                                  'https://suma.geloraaksara.co.id/uploads/thumbnail/'+interaktifListData.thumbnail,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  right: 5,
                                  top: 10,
                                  child: new Align(
                                      alignment: FractionalOffset.bottomRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5.0),
                                              bottomLeft: Radius.circular(5.0),
                                              bottomRight: Radius.circular(5.0),
                                              topRight: Radius.circular(5.0)),
                                        ),
                                        margin: EdgeInsets.only(right: 5),
                                        padding: EdgeInsets.only(left: 3, right: 3, bottom: 2, top: 2),
                                        child: Text(interaktifListData.durasi.substring(0,5), style: TextStyle(color: Colors.white, fontSize: 12),),
                                      )
                                  )
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.5)
                                  ),
                                  child: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ) ,
                )
            ),
          ),
        )
    );
}

// Widget itemAll(InteraktifData interaktifListData, BuildContext context,var lebar,var tinggi, AnimationController animationController){
//   return
//     FadeInUp(
//         delay : Duration(milliseconds: 500),
//         child: ZoomTapAnimation(
//             child: GestureDetector(
//                 onTap: () {
//                   new Future.delayed(new Duration(milliseconds: 300), () {
//                     Navigator.push<dynamic>(
//                         context,
//                         MaterialPageRoute<dynamic>(
//                           builder: (BuildContext context) => DetailVideoScreen(animationController: animationController, idContent: interaktifListData.id, youtubeId: interaktifListData.youtube_id, kategoriKonten: interaktifListData.kategori),
//                         )
//                     );
//                   });
//                 },
//                 child: Container(
//                   alignment: Alignment.center,
//                   width: lebar/4,
//                   child:
//                   Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(7.0),
//                               bottomLeft: Radius.circular(7.0),
//                               bottomRight: Radius.circular(7.0),
//                               topRight: Radius.circular(7.0)),
//                           boxShadow: <BoxShadow>[
//                             BoxShadow(
//                                 color: AppTheme.grey.withOpacity(0.2),
//                                 offset: Offset(0.0, 1.0), //(x,y)
//                                 blurRadius: 2.0),
//                           ],
//                         ),
//                         alignment: Alignment.center,
//                         width: double.infinity,
//                         height: 120,
//                         margin: EdgeInsets.only(top: 20, left: 5,right: 5, bottom: 0),
//                       ),
//                       Container(
//                         alignment: Alignment.center,
//                         padding: EdgeInsets.only(left: 15, right: 15),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                         ),
//                         width: double.infinity,
//                         child:
//                         Column(
//                           children: [
//                             Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(5.0),
//                                   child:
//                                   Image.asset(
//                                       'assets/images/no_image.png',
//                                       width: double.infinity,
//                                       height: 110,
//                                       fit:BoxFit.fill
//                                   ),
//                                 ),
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(5.0),
//                                   child:
//                                   Image.network(
//                                       "https://suma.geloraaksara.co.id/uploads/thumbnail/"+interaktifListData.thumbnail,
//                                       width: double.infinity,
//                                       height: 110,
//                                       fit:BoxFit.fill
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 7),
//                             Text(interaktifListData.judul,
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               style: GoogleFonts.roboto(fontSize: 13)
//                             ),
//                           ],
//                         )
//
//                       ),
//                       Container(
//                         height: 10,
//                         margin: EdgeInsets.all(100.0),
//                         decoration: BoxDecoration(
//                             color: Colors.orange,
//                             shape: BoxShape.circle
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         margin: EdgeInsets.only(top: 32),
//                         child: Container(
//                           width: 38,
//                           height: 38,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.black.withOpacity(0.5)
//                           ),
//                           child: Icon(
//                             Icons.play_arrow,
//                             color: Colors.white
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                           right: 0,
//                           top: 4,
//                           child: new Align(
//                               alignment: FractionalOffset.bottomRight,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.6),
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(5.0),
//                                       bottomLeft: Radius.circular(5.0),
//                                       bottomRight: Radius.circular(5.0),
//                                       topRight: Radius.circular(5.0)),
//                                 ),
//                                 margin: EdgeInsets.only(bottom: 38, right: 20),
//                                 padding: EdgeInsets.only(left: 3, right: 3, bottom: 2, top: 2),
//                                 child: Text(
//                                   interaktifListData.durasi.substring(0,5),
//                                   textAlign: TextAlign.center,
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: TextStyle(color: Colors.white, fontSize: 12),),
//                               )
//                           )
//                       ),
//                     ],
//                   )
//                 )
//             )
//         )
//     );
// }
