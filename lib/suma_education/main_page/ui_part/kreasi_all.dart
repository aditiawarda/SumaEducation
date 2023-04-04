import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
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
        var durasi = dataKreasi['data'][i]['durasi'];
        var youtube_id = dataKreasi['data'][i]['youtube_id'];
        var kategori = dataKreasi['data'][i]['kategori'];
        var created_at = dataKreasi['data'][i]['created_at'];
        kreasiListData.add(KreasiData(id, judul, thumbnail, durasi, youtube_id, kategori, created_at));
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
        padding: EdgeInsets.only(left: 20, right: 20, top: 25),
        width: MediaQuery.of(context).size.width,
        child:
        Wrap(
          children: <Widget>[
            FutureBuilder<String>(
              future: _getKreasiContent(), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 13),
                      itemCount: kreasiListData.length,
                      itemBuilder: (BuildContext context, int index) {
                        final int count = kreasiListData.length;
                        final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                        animationController?.forward();
                        var tinggi = MediaQuery.of(context).size.height;
                        var lebar = MediaQuery.of(context).size.width;
                        return itemAll(kreasiListData[index], context, lebar, tinggi, animationController!);
                      });
                } else {
                  if (snapshot.hasError)
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 13),
                        itemCount: kreasiListData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = kreasiListData.length;
                          final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                          animationController?.forward();
                          var tinggi = MediaQuery.of(context).size.height;
                          var lebar = MediaQuery.of(context).size.width;
                          return itemAll(kreasiListData[index], context, lebar, tinggi, animationController!);
                        });
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
                      return
                        GridView.builder(
                          padding: EdgeInsets.only(bottom: 150),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.1,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 13),
                          itemCount: kreasiListData.length,
                          itemBuilder: (BuildContext context, int index) {
                            final int count = kreasiListData.length;
                            final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                            animationController?.forward();
                            var tinggi = MediaQuery.of(context).size.height;
                            var lebar = MediaQuery.of(context).size.width;
                            return itemAll(kreasiListData[index], context, lebar, tinggi, animationController!);
                          });
                }
              },
            )
          ],
        ),
    );
  }
}

Widget itemAll(KreasiData kreasiData, BuildContext context,var lebar,var tinggi, AnimationController animationController){
  return
    FadeInUp(
        delay : Duration(milliseconds: 500),
        child: ZoomTapAnimation(
            child: GestureDetector(
                onTap: () {
                  new Future.delayed(new Duration(milliseconds: 300), () {
                    Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => DetailVideoScreen(animationController: animationController, idContent: kreasiData.id, youtubeId: kreasiData.youtube_id, kategoriKonten: kreasiData.kategori),
                        )
                    );
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  width: lebar/4,
                  child:
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7.0),
                              bottomLeft: Radius.circular(7.0),
                              bottomRight: Radius.circular(7.0),
                              topRight: Radius.circular(7.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.grey.withOpacity(0.2),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 2.0),
                          ],
                        ),
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 120,
                        margin: EdgeInsets.only(top: 20, left: 5,right: 5, bottom: 0),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        width: double.infinity,
                        child:
                        Column(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child:
                                  Image.asset(
                                      'assets/images/no_image.png',
                                      width: double.infinity,
                                      height: 110,
                                      fit:BoxFit.fill
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child:
                                  Image.network(
                                      "https://suma.geloraaksara.co.id/uploads/thumbnail/"+kreasiData.thumbnail,
                                      width: double.infinity,
                                      height: 110,
                                      fit:BoxFit.fill
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 7),
                            Text(kreasiData.judul,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.roboto(fontSize: 13)
                            ),
                          ],
                        )
                      ),
                      Container(
                        height: 10,
                        margin: EdgeInsets.all(100.0),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 32),
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
                      Positioned(
                          right: 0,
                          top: 4,
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
                                margin: EdgeInsets.only(bottom: 38, right: 20),
                                padding: EdgeInsets.only(left: 3, right: 3, bottom: 2, top: 2),
                                child: Text(kreasiData.durasi.substring(0,5), style: TextStyle(color: Colors.white, fontSize: 12),),
                              )
                          )
                      ),
                    ],
                  )
                )
            )
        )
    );
}
