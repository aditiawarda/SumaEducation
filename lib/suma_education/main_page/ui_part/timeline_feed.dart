// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/kreasi_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/product_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/timeline_data.dart';
import 'package:suma_education/suma_education/main_page/screen/detail_video_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

SharedPreferences? prefs;

class TimelineFeed extends StatefulWidget {
  const TimelineFeed(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _TimelineFeedState createState() => _TimelineFeedState();
}

class _TimelineFeedState extends State<TimelineFeed>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TimelineData> timelineData = [];

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<String> _getDataTimeline() async {
    try {
      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/get_timeline_content"),
          body: {
            "request": "request",
          });
      timelineData = [];
      var dataStory = json.decode(response.body);
      print(dataStory);
      for (var i = 0; i < dataStory['data'].length; i++) {
        var id = dataStory['data'][i]['id'];
        var id_user = dataStory['data'][i]['id_user'];
        var username = dataStory['data'][i]['username'];
        var avatar = dataStory['data'][i]['avatar'];
        var content = dataStory['data'][i]['content'];
        var deskripsi = dataStory['data'][i]['deskripsi'];
        var kategori = dataStory['data'][i]['kategori'];
        var created_at = dataStory['data'][i]['created_at'];
        timelineData.add(TimelineData(id, id_user, username, avatar, content, deskripsi, kategori, created_at));
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
          FadeTransition(
            opacity: widget.mainScreenAnimation!,
            child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                child:
                FadeInUp(
                    delay: Duration(milliseconds: 1000),
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(bottom: 30),
                      width: MediaQuery.of(context).size.width,
                      child:
                      Wrap(
                        children: <Widget>[
                          FutureBuilder<String>(
                            future: _getDataTimeline(),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                                if(timelineData.length==0)
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
                                    MasonryGridView.count(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: timelineData.length,
                                        padding: EdgeInsets.only(bottom: 20, top: 25),
                                        crossAxisCount: 1,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 18,
                                        itemBuilder: (context, index) {
                                          animationController?.forward();
                                          return
                                            itemAll(timelineData[index], context, animationController!);
                                        });

                                    // GridView.builder(
                                    //     shrinkWrap: true,
                                    //     padding: EdgeInsets.only(bottom: 20, top: 25),
                                    //     physics: const NeverScrollableScrollPhysics(),
                                    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    //         crossAxisCount: 1,
                                    //         childAspectRatio: 0.83,
                                    //         crossAxisSpacing: 10,
                                    //         mainAxisSpacing: 18),
                                    //     itemCount: productListData.length,
                                    //     itemBuilder: (BuildContext context, int index) {
                                    //       animationController?.forward();
                                    //       return itemAll(productListData[index], context, animationController!);
                                    //     });
                              }
                            },
                          )
                        ],
                      ),
                    )
                ),
            ),
          );
      },
    );
  }
}

Widget itemAll(TimelineData timelineData, BuildContext context, AnimationController animationController){
  return
    Container(
      margin: EdgeInsets.only(left: 10, right: 10),
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
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child:
                Image.asset(
                  'assets/images/no_image_3.png',
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child:
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: timelineData.content.toString(),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      margin: EdgeInsets.only(right: 10),
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(timelineData.username.toString(),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 8,),
                Text(timelineData.deskripsi.toString(),
                  style: TextStyle(
                      height: 1.4,
                      fontSize: 13
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

}
