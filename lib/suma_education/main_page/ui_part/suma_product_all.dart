// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class ProductAllData extends StatefulWidget {
  const ProductAllData(
      {Key? key})
      : super(key: key);

  @override
  _ProductAllDataState createState() => _ProductAllDataState();
}

class _ProductAllDataState extends State<ProductAllData>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<ProductData> productListData = [];

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
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
    return FadeInUp(
        delay : Duration(milliseconds: 1000),
        child : Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
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
                            padding: EdgeInsets.only(top: 30),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
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
    );
  }
}

Widget itemAll(ProductData productData, BuildContext context, AnimationController animationController){
  return
    ZoomTapAnimation(
      onTap: () {
        new Future.delayed(new Duration(milliseconds: 300), () async {
          await launch(productData.link);
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
                        fit: BoxFit.fill,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: 'https://suma.geloraaksara.co.id/uploads/produk/'+productData.gambar,
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
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      Image.asset(
                        'assets/images/no_image_blank.png',
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      height: 33,
                      width: double.infinity,
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade600,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                      ),
                    ),
                    Positioned(
                        left: 3,
                        bottom: 8,
                        child: new Align(
                            alignment: FractionalOffset.bottomLeft,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7.0),
                                      bottomLeft: Radius.circular(7.0),
                                      bottomRight: Radius.circular(7.0),
                                      topRight: Radius.circular(7.0)),
                                ),
                                margin: EdgeInsets.only(left: 5),
                                padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                child:
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 1),
                                      margin: EdgeInsets.only(right: 10),
                                      alignment: Alignment.center,
                                      child: Icon(FontAwesomeIcons.cartArrowDown,color: Colors.yellow, size: 12),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(productData.nama.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            )
                        )
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
}
