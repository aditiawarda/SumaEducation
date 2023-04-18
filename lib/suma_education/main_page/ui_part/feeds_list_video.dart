// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/model/feeds_video.dart';
import 'package:suma_education/suma_education/main_page/screen/feed_detail_video_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../main.dart';
import '../screen/home_screen.dart';

class FeedsListVideo extends StatefulWidget {
  const FeedsListVideo(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.idRequest})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? idRequest;

  @override
  _FeedsListVideoState createState() => _FeedsListVideoState();
}

class _FeedsListVideoState extends State<FeedsListVideo>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<FeedVideoData> feedsVideo = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _getFeedsVideo();
    getUser();
    super.initState();
  }

  Future<String> _getFeedsVideo() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/get_content_feeds_video"),
          body: {
            "request": "request",
          });
      feedsVideo = [];
      var dataVideo= json.decode(response.body);
      print(dataVideo);
      for (var i = 0; i < dataVideo['data'].length; i++) {
        var id = dataVideo['data'][i]['id'].toString();
        var judul = dataVideo['data'][i]['judul'].toString();
        var durasi = dataVideo['data'][i]['durasi'].toString();
        var thumbnail = dataVideo['data'][i]['thumbnail'].toString();
        var file = dataVideo['data'][i]['file'].toString();

        feedsVideo.add(FeedVideoData(id, judul, durasi, thumbnail, file));
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  Future<String> getUser() async {
    prefs = await _prefs;
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
                Container(
                  height: 180,
                  width: double.infinity,
                  child: Theme(
                    data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange[100])),
                    child:
                    FutureBuilder<String>(
                      future: _getFeedsVideo(), // function where you call your api
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                                            'Konten belum tersedia',
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
                        } else {
                          if (snapshot.hasError)
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
                                              'Konten belum tersedia',
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
                          if (feedsVideo.length==0)
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
                                                'Konten belum tersedia',
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
                              itemCount: feedsVideo.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                final int count = feedsVideo.length;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval((1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn)));
                                animationController?.forward();
                                return itemVideo(feedsVideo[index], context, animationController!, animation, index.toString());
                              },
                            ); // snapshot.data  :- get your object which is pass from your downloadData() function
                        }
                      },
                    ),
                  ),
                ),
              ],
            )

          ),
        );
      },
    );
  }
}

Widget itemVideo(FeedVideoData dataVideo, BuildContext context, AnimationController animationController, Animation<double> animation, String i){
  return
    AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: ZoomTapAnimation(
              onTap: () {
                new Future.delayed(new Duration(milliseconds: 300), () {
                  Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => FeedsDetailVideoScreen(animationController: animationController, idContent: dataVideo.id, thumbnail: dataVideo.thumbnail, source: dataVideo.file),
                      )
                  );
                });
              },
            child: Transform(
              transform: Matrix4.translationValues(100 * (1.0 - animation.value), 0.0, 0.0),
              child: SizedBox(
                width: 230,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32, left: 8, right: 8, bottom: 16),
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.grey.withOpacity(0.2),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 2.0),
                          ],
                          gradient: LinearGradient(
                            colors: <HexColor>[
                                HexColor("#FFFFFF"),
                                HexColor("#FFFFFF"),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        child:
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6.0),
                                  child:
                                  Image.network(
                                      "https://suma.geloraaksara.co.id/uploads/thumbnail/"+dataVideo.thumbnail,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.fitHeight
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 40),
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
                                    child: new Align(
                                        alignment: FractionalOffset.topRight,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5.0),
                                                bottomLeft: Radius.circular(5.0),
                                                bottomRight: Radius.circular(5.0),
                                                topRight: Radius.circular(5.0)),
                                          ),
                                          margin: EdgeInsets.only(top: 5, right: 5),
                                          padding: EdgeInsets.only(left: 3, right: 3, bottom: 2, top: 2),
                                          child: Text(dataVideo.durasi.substring(0,5), style: TextStyle(color: Colors.white, fontSize: 12),),
                                        )
                                    )
                                ),
                                Positioned(
                                    child: new Align(
                                        alignment: FractionalOffset.bottomLeft,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(0.0),
                                                bottomLeft: Radius.circular(5.0),
                                                bottomRight: Radius.circular(5.0),
                                                topRight: Radius.circular(0.0)),
                                          ),
                                          margin: EdgeInsets.only(bottom: 1, right: 1, left: 1),
                                          padding: EdgeInsets.only(left: 5, right: 5, bottom: 2, top: 2),
                                          child: Text(dataVideo.judul,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                        )
                                    )
                                ),
                              ],
                            )
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
        );
      },
    );
}

