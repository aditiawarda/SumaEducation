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
import 'package:suma_education/suma_education/main_page/model/tutorial_list_data.dart';
import 'package:suma_education/suma_education/main_page/screen/detail_video_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

SharedPreferences? prefs;

class TutorialAllListData extends StatefulWidget {
  const TutorialAllListData(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _TutorialAllListDataState createState() => _TutorialAllListDataState();
}

class _TutorialAllListDataState extends State<TutorialAllListData>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TutorialData> tutorialListData = [];

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _getTutorialContent();
    super.initState();
  }

  Future<String> _getTutorialContent() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/get_content_tutorial"),
          body: {
            "request": "request",
          });
      tutorialListData = [];
      var dataTutorial = json.decode(response.body);
      print(dataTutorial);
      for (var i = 0; i < dataTutorial['data'].length; i++) {
        var id = dataTutorial['data'][i]['id'];
        var judul = dataTutorial['data'][i]['judul'];
        var thumbnail = dataTutorial['data'][i]['thumbnail'];
        var square_thumbnail = dataTutorial['data'][i]['square_thumbnail'];
        var durasi = dataTutorial['data'][i]['durasi'];
        var youtube_id = dataTutorial['data'][i]['youtube_id'];
        var source = dataTutorial['data'][i]['source'];
        var kategori = dataTutorial['data'][i]['kategori'];
        var created_at = dataTutorial['data'][i]['created_at'];

        tutorialListData.add(TutorialData(id, judul, thumbnail, square_thumbnail, durasi, youtube_id, source, kategori, created_at));
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
    return
      Transform.translate(
          offset: const Offset(0, -20,),
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 5),
            width: MediaQuery.of(context).size.width,
            child:
            Wrap(
              children: <Widget>[
                FutureBuilder<String>(
                  future: _getTutorialContent(), // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return
                        Container(
                            height: MediaQuery.of(context).size.height*0.6,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              margin: EdgeInsets.only(
                                  right: 10),
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                                strokeWidth: 3,
                              ),
                            )
                        );
                    } else {
                      if (snapshot.hasError)
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
                      if(tutorialListData.length==0)
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
                              itemCount: tutorialListData.length,
                              itemBuilder: (BuildContext context, int index) {
                                animationController?.forward();
                                return itemVideoAll(tutorialListData[index], context, animationController!);
                              });
                    }
                  },
                )
              ],
            ),
          )
      );
  }
}

Widget itemVideoAll(TutorialData tutorialData, BuildContext context, AnimationController animationController){
  return
    FadeInUp(
        delay : Duration(milliseconds: 500),
        child : ZoomTapAnimation(
          onTap: () {
            new Future.delayed(new Duration(milliseconds: 300), () {
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => DetailVideoScreen(animationController: animationController, idContent: tutorialData.id, youtubeId: tutorialData.youtube_id, kategoriKonten: tutorialData.kategori, thumbnail: tutorialData.thumbnail, source: tutorialData.source,),
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
                                'https://suma.geloraaksara.co.id/uploads/square_thumbnail/'+tutorialData.square_thumbnail,
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
                                      child: Text(tutorialData.durasi.substring(0,5), style: TextStyle(color: Colors.white, fontSize: 12),),
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
        )
    );
}
