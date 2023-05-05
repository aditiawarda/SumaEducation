import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/model/kreasi_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/postingan_data.dart';
import 'package:suma_education/suma_education/main_page/screen/detail_posting_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/detail_video_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

SharedPreferences? prefs;

class YourPost extends StatefulWidget {
  const YourPost(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _YourPostState createState() => _YourPostState();
}

class _YourPostState extends State<YourPost>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<PostinganData> postinganData = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _getPostingan();
    super.initState();
  }

  Future<String> _getPostingan() async {
    final SharedPreferences prefs = await _prefs;
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/get_postingan"),
          body: {
            "id_user": prefs.getString("data_id"),
          });
      postinganData = [];
      var dataPostingan = json.decode(response.body);
      print(dataPostingan);
      for (var i = 0; i < dataPostingan['data'].length; i++) {
        var id = dataPostingan['data'][i]['id'];
        var deskripsi = dataPostingan['data'][i]['deskripsi'];
        var filename = dataPostingan['data'][i]['filename'];
        var created_at = dataPostingan['data'][i]['created_at'];
        postinganData.add(PostinganData(id, deskripsi, filename, created_at));
      }
      print("tessssssssssssss");
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
        padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
        width: MediaQuery.of(context).size.width,
        child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  child: Container(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    margin: EdgeInsets.only(bottom: 5, top: 10),
                    child:  Text(
                      'POSTINGAN',
                      style: TextStyle(
                        color: Colors.blueGrey,
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
                Wrap(
                    children: <Widget>[
                      FutureBuilder<String>(
                        future: _getPostingan(), // function where you call your api
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
                                    padding: EdgeInsets.all(3.0),
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
                            if(postinganData.length==0)
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
                                  padding: EdgeInsets.only(top: 12),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                                  itemCount: postinganData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    animationController?.forward();
                                    return itemAll(postinganData[index], context, animationController!);
                                  });
                          }
                        },
                      )
                    ]
                ),
              ],
            )
      );
  }
}

Widget itemAll(PostinganData postinganData, BuildContext context, AnimationController animationController){
  return
    FadeInUp(
        delay : Duration(milliseconds: 500),
        child : ZoomTapAnimation(
          onTap: () {
            new Future.delayed(new Duration(milliseconds: 300), () {
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => DetailPostingScreen(animationController: animationController, image: 'https://suma.geloraaksara.co.id/uploads/feed_content/event/'+postinganData.filename.toString(), deskripsi: postinganData.deskripsi.toString(), id: postinganData.id.toString(),),
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
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: 'https://suma.geloraaksara.co.id/uploads/feed_content/event/'+postinganData.filename.toString(),
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
                  ],
                ),
              ],
            ),
          ),
        )
    );
}