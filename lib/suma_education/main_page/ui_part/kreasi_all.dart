import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/model/kreasi_list_data.dart';
import 'package:suma_education/suma_education/main_page/screen/detail_video_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

SharedPreferences? prefs;

class KreasiListAllData extends StatefulWidget {
  const KreasiListAllData(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _KreasiListAllDataState createState() => _KreasiListAllDataState();
}

class _KreasiListAllDataState extends State<KreasiListAllData>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<KreasiData> kreasiListData = [];

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _getKreasiContent();
    super.initState();
  }

  Future<String> _getKreasiContent() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/get_content_kreasi"),
          body: {
            "id_user": "request",
          });
      kreasiListData = [];
      var dataKreasi = json.decode(response.body);
      print(dataKreasi);
      for (var i = 0; i < dataKreasi['data'].length; i++) {
        var id = dataKreasi['data'][i]['id'];
        var judul = dataKreasi['data'][i]['judul'];
        var thumbnail = dataKreasi['data'][i]['thumbnail'];
        var square_thumbnail = dataKreasi['data'][i]['square_thumbnail'];
        var durasi = dataKreasi['data'][i]['durasi'];
        var youtube_id = dataKreasi['data'][i]['youtube_id'];
        var source = dataKreasi['data'][i]['source'];
        var kategori = dataKreasi['data'][i]['kategori'];
        var created_at = dataKreasi['data'][i]['created_at'];
        kreasiListData.add(KreasiData(id, judul, thumbnail, square_thumbnail, durasi, youtube_id, source, kategori, created_at));
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
      Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 5),
        width: MediaQuery.of(context).size.width,
        child:
        Wrap(
            children: <Widget>[
              FutureBuilder<String>(
                future: _getKreasiContent(), // function where you call your api
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
                    if(kreasiListData.length==0)
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
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                          itemCount: kreasiListData.length,
                          itemBuilder: (BuildContext context, int index) {
                            animationController?.forward();
                            return itemVideoAll(kreasiListData[index], context, animationController!);
                          });
                  }
                },
              )
            ]
        ),
      );
  }
}

Widget itemVideoAll(KreasiData kreasiData, BuildContext context, AnimationController animationController){
  return
    FadeInUp(
        delay : Duration(milliseconds: 500),
        child : ZoomTapAnimation(
          onTap: () {
            new Future.delayed(new Duration(milliseconds: 300), () {
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => DetailVideoScreen(animationController: animationController, idContent: kreasiData.id, youtubeId: kreasiData.youtube_id, kategoriKonten: kreasiData.kategori, thumbnail: kreasiData.thumbnail, source: kreasiData.source,),
                  )
              );
            });
          },
          child: Container(
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
            Column(
              children: [
                Wrap(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:
                          Image.asset(
                            'assets/images/no_image_3.png',
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:
                          Image.network(
                            'https://suma.geloraaksara.co.id/uploads/square_thumbnail/'+kreasiData.square_thumbnail,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                            right: 3,
                            bottom: 8,
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
                                  child: Text(kreasiData.durasi.substring(0,5), style: TextStyle(color: Colors.white, fontSize: 12),),
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
          ),
        )
    );
}