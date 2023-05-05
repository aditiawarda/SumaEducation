// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/main_page/model/history_watching_data.dart';
import 'package:suma_education/suma_education/main_page/model/product_list_data.dart';
import 'package:suma_education/suma_education/main_page/screen/detail_video_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class WatchingHistory extends StatefulWidget {
  const WatchingHistory(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _WatchingHistoryState createState() => _WatchingHistoryState();
}

class _WatchingHistoryState extends State<WatchingHistory>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<HistoryWatchingData> historyWatching = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _getProduct();
    super.initState();
  }

  Future<String> _getProduct() async {
    final SharedPreferences prefs = await _prefs;
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/getHistoryWatching"),
          body: {
            "id_user": prefs.getString("data_id"),
          });
      historyWatching = [];
      var dataProduct = json.decode(response.body);
      print(dataProduct);
      for (var i = 0; i < dataProduct['data'].length; i++) {
        var id           = dataProduct['data'][i]['id'];
        var thumbnail    = dataProduct['data'][i]['thumbnail'];
        var durasi       = dataProduct['data'][i]['durasi'];
        var youtube_id   = dataProduct['data'][i]['youtube_id'];
        var source       = dataProduct['data'][i]['source'];
        var kategori     = dataProduct['data'][i]['kategori'];
        var template     = dataProduct['data'][i]['template'];
        historyWatching.add(HistoryWatchingData(id, thumbnail, durasi, youtube_id, source, kategori, template));
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
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
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  child: Container(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      margin: EdgeInsets.only(bottom: 10, top: 15),
                      child:  Text(
                        'HISTORY OF WATCHING',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 5.0,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 10.0,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  child:
                  FutureBuilder<String>(
                    future: _getProduct(), // function where you call your api
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return FadeInRight(
                          delay: Duration(milliseconds: 300),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: Container(
                                alignment: Alignment.center,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child:
                                Container(
                                  height: 30.0,
                                  width: 30.0,
                                  margin: EdgeInsets.only(right: 10),
                                  child: CircularProgressIndicator(
                                    color: Colors.orange,
                                    strokeWidth: 2.5,
                                  ),
                                )
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.hasError)
                          return FadeInRight(
                            delay: Duration(milliseconds: 300),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child:
                                  Container(
                                    height: 30.0,
                                    width: 30.0,
                                    margin: EdgeInsets.only(right: 10),
                                    child: CircularProgressIndicator(
                                      color: Colors.orange,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                              ),
                            ),
                          );
                        else
                        if (historyWatching.length==0)
                          return
                            FadeInUp(
                              delay: Duration(milliseconds: 300),
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/empty_data.png",
                                        height: 80),
                                    Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Oops...',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                letterSpacing: 0.5,
                                                color: Colors.blueGrey.shade200,
                                              ),
                                            ),
                                            Text(
                                              'Data tidak tersedia',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11,
                                                letterSpacing: 0.5,
                                                color: Colors.blueGrey.shade200,
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
                            );
                        else
                          return ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 5, right: 16, left: 16),
                            itemCount: historyWatching.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              animationController?.forward();
                              return itemAll(historyWatching[index], context, animationController!);
                            },
                          );
                      }
                    },
                  )
                )
              ],
            )

          ),
        );
      },
    );
  }
}

Widget itemAll(HistoryWatchingData historyWatching, BuildContext context, AnimationController animationController){
  return
  FadeInRight(
      delay: Duration(milliseconds: 800),
      child: ZoomTapAnimation(
        onTap: () {
          new Future.delayed(new Duration(milliseconds: 300), () {
            if(historyWatching.kategori=="2"){
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => DetailVideoScreen(animationController: animationController, idContent: historyWatching.id, youtubeId: historyWatching.youtube_id, kategoriKonten: historyWatching.kategori, thumbnail: historyWatching.thumbnail, source: historyWatching.source, template: historyWatching.template,),
                  )
              );
            } else {
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => DetailVideoScreen(animationController: animationController, idContent: historyWatching.id, youtubeId: historyWatching.youtube_id, kategoriKonten: historyWatching.kategori, thumbnail: historyWatching.thumbnail, source: historyWatching.source,),
                  )
              );
            }
          });
        },
        child: Container(
          width: 160,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.orange,
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
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child:
                            Image.asset(
                              'assets/images/no_image.png',
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                            ),
                            child:
                            CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: "https://suma.geloraaksara.co.id/uploads/thumbnail/"+historyWatching.thumbnail.toString(),
                              placeholder: (context, url) => Container(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  padding: EdgeInsets.all(3.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.orange,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => new Icon(Icons.error),
                            ),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child:
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.blueGrey.shade600, width: 4),
                                    color: Colors.orange.withOpacity(0.8)
                                ),
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      color: Colors.orange.withOpacity(0.8)
                                  ),
                                  child: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 15,
                                  ),
                                ),
                              )
                          ),
                          Positioned(
                              right: 1,
                              top: 5,
                              child: new Align(
                                  alignment: FractionalOffset.bottomRight,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(7.0),
                                            bottomLeft: Radius.circular(7.0),
                                            bottomRight: Radius.circular(7.0),
                                            topRight: Radius.circular(7.0)),
                                      ),
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.only(left: 4, right: 4, bottom: 1, top: 2),
                                      child:
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(bottom: 1),
                                            margin: EdgeInsets.only(right: 2),
                                            alignment: Alignment.center,
                                            child: Icon(FontAwesomeIcons.clock,color: Colors.white, size: 8),
                                          ),
                                          Text(historyWatching.durasi.toString().substring(0,5), style: TextStyle(color: Colors.white, fontSize: 10),),
                                        ],
                                      )
                                  )
                              )
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      )
  );
}

