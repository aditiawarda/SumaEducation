// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/kreasi_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/product_list_data.dart';
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
  List<ProductData> productListData = [];

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _getKreasiContent();
    super.initState();
  }

  Future<String> _getKreasiContent() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/getProduk"),
          body: {
            "request": "request",
          });
      productListData = [];
      var dataProduct = json.decode(response.body);
      print(dataProduct);
      for (var i = 0; i < dataProduct['data'].length; i++) {
        var id           = dataProduct['data'][i]['id'];
        var id_kategori  = dataProduct['data'][i]['id_kategori'];
        var nama         = dataProduct['data'][i]['nama'];
        var gambar       = dataProduct['data'][i]['gambar'];
        var link         = dataProduct['data'][i]['link'];
        productListData.add(ProductData(id, id_kategori, nama, gambar, link));
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
                    delay : Duration(milliseconds: 1000),
                    child : Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(bottom: 30),
                      width: MediaQuery.of(context).size.width,
                      child:
                      Wrap(
                        children: <Widget>[
                          FutureBuilder<String>(
                            future: _getKreasiContent(),
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
                                if(productListData.length==0)
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
                                            crossAxisCount: 1,
                                            childAspectRatio: 1,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                        itemCount: productListData.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          animationController?.forward();
                                          return itemAll(productListData[index], context, animationController!);
                                        });
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

Widget itemAll(ProductData productData, BuildContext context, AnimationController animationController){
  return
    Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
      ),
      child:
      Wrap(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                child:
                Image.asset(
                  'assets/images/no_image_3.png',
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              ClipRRect(
                child:
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: 'https://suma.geloraaksara.co.id/uploads/produk/'+productData.gambar,
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
        ],
      ),
    );
}