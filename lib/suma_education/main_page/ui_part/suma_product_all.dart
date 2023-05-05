// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
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
    _getProduct();
    super.initState();
  }

  Future<String> _getProduct() async {
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
        var kategori     = dataProduct['data'][i]['kategori'];
        productListData.add(ProductData(id, id_kategori, nama, gambar, link, kategori));
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
                future: _getProduct(),
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
                        MasonryGridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productListData.length,
                            padding: EdgeInsets.only(top: 30, bottom: 10),
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            itemBuilder: (context, index) {
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
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              topRight: Radius.circular(15.0)),
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
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                  topRight: Radius.circular(15.0)
                              ),
                              child:
                              Image.asset(
                                'assets/images/no_image_3.png',
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                  topRight: Radius.circular(15.0)
                              ),
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
                      ],
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Text(productData.nama.toString(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.5,
                      color: Colors.white,
                      fontSize: 15
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(1.0),
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                        topRight: Radius.circular(1.0)
                    ),
                  ),
                  child:
                  Column(
                    children: [
                      if(productData.kategori=="1")...{
                        Container(
                          height: 5,
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          color: Colors.orange.shade100,
                        ),
                      } else if(productData.kategori=="2")...{
                        Container(
                          height: 5,
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          color: Colors.deepOrange.shade100,
                        ),
                      } else if(productData.kategori=="3")...{
                        Container(
                          height: 5,
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          color: Colors.green.shade100,
                        ),
                      },
                      Text("Pesan via",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            height: 1.5,
                            color: Colors.orange,
                            fontSize: 13
                        ),
                      ),
                      SizedBox(height: 5),
                      if(productData.kategori=="1")...{
                        Image.asset(
                          'assets/images/tokosuma_logo.png',
                          width: 100,
                          fit: BoxFit.fill,
                        ),
                      } else if(productData.kategori=="2")...{
                        Image.asset(
                          'assets/images/shopee_logo.png',
                          width: 100,
                          fit: BoxFit.fill,
                        ),
                      } else if(productData.kategori=="3")...{
                        Image.asset(
                          'assets/images/tokopedia_logo.png',
                          width: 100,
                          fit: BoxFit.fill,
                        ),
                      },
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                        height: 10,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
}
