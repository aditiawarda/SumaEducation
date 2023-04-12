// ignore_for_file: deprecated_member_use

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
import 'package:suma_education/suma_education/main_page/model/product_list_data.dart';
import 'package:suma_education/suma_education/main_page/screen/detail_video_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

SharedPreferences? prefs;

class ProductAllData extends StatefulWidget {
  const ProductAllData(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _ProductAllDataState createState() => _ProductAllDataState();
}

class _ProductAllDataState extends State<ProductAllData>
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
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 13),
                      itemCount: productListData.length,
                      itemBuilder: (BuildContext context, int index) {
                        final int count = productListData.length;
                        final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                        animationController?.forward();
                        var tinggi = MediaQuery.of(context).size.height;
                        var lebar = MediaQuery.of(context).size.width;
                        return itemProductAll(productListData[index], context, lebar, tinggi, animationController!);
                      });
                } else {
                  if (snapshot.hasError)
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 13),
                        itemCount: productListData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = productListData.length;
                          final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                          animationController?.forward();
                          var tinggi = MediaQuery.of(context).size.height;
                          var lebar = MediaQuery.of(context).size.width;
                          return itemProductAll(productListData[index], context, lebar, tinggi, animationController!);
                        });
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
                          padding: EdgeInsets.only(bottom: 150),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 13),
                          itemCount: productListData.length,
                          itemBuilder: (BuildContext context, int index) {
                            final int count = productListData.length;
                            final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                            animationController?.forward();
                            var tinggi = MediaQuery.of(context).size.height;
                            var lebar = MediaQuery.of(context).size.width;
                            return itemProductAll(productListData[index], context, lebar, tinggi, animationController!);
                          });
                }
              },
            )
          ],
        ),
    );
  }
}

Widget itemProductAll(ProductData productData, BuildContext context,var lebar,var tinggi, AnimationController animationController){
  return
    FadeInUp(
        delay: Duration(milliseconds: 500),
        child: ZoomTapAnimation(
            child: GestureDetector(
                onTap: () async {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  await launch(productData.link);
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
                        height: 215,
                        margin: EdgeInsets.only(left: 5,right: 5),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 8, right: 8, top: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        width: double.infinity,
                        child:
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child:
                              Image.network(
                                  "https://suma.geloraaksara.co.id/uploads/produk/"+productData.gambar,
                                  width: double.infinity,
                                  height: 165,
                                  fit:BoxFit.fill
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(productData.nama,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.roboto(fontSize: 13)
                            ),
                          ],
                        )
                      ),
                    ],
                  )
                )
            )
        )
    );
}
