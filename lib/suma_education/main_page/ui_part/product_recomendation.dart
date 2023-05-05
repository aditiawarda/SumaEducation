// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/main_page/model/product_list_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ProductRecomendation extends StatefulWidget {
  const ProductRecomendation(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _ProductRecomendationState createState() => _ProductRecomendationState();
}

class _ProductRecomendationState extends State<ProductRecomendation>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<ProductData> productData = [];

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _getProduct();
    super.initState();
  }

  Future<String> _getProduct() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/getProduk"),
          body: {
            "request": "request",
          });
      productData = [];
      var dataProduct = json.decode(response.body);
      print(dataProduct);
      for (var i = 0; i < dataProduct['data'].length; i++) {
        var id           = dataProduct['data'][i]['id'];
        var id_kategori  = dataProduct['data'][i]['id_kategori'];
        var nama         = dataProduct['data'][i]['nama'];
        var gambar       = dataProduct['data'][i]['gambar'];
        var link         = dataProduct['data'][i]['link'];
        var kategori     = dataProduct['data'][i]['kategori'];
        productData.add(ProductData(id, id_kategori, nama, gambar, link, kategori));
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
                      margin: EdgeInsets.only(bottom: 15),
                      child:  Text(
                        'PRODUK SUMA',
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
                Container(
                  height: 238,
                  margin: EdgeInsets.only(bottom: 20),
                  child:
                  FutureBuilder<String>(
                    future: _getProduct(), // function where you call your api
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return
                          FadeInRight(
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
                          return
                            FadeInRight(
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
                        if (productData.length==0)
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
                                              'Produk tidak tersedia',
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
                            itemCount: productData.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              animationController?.forward();
                              return itemAll(productData[index], context, animationController!);
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

Widget itemAll(ProductData productData, BuildContext context, AnimationController animationController){
  return
  FadeInRight(
      delay: Duration(milliseconds: 800),
      child: ZoomTapAnimation(
        onTap: () {
          new Future.delayed(new Duration(milliseconds: 300), () async {
            await launch(productData.link);
          });
        },
        child: Container(
          width: 135,
          margin: EdgeInsets.only(right: 10),
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
                        width: 85,
                        fit: BoxFit.fill,
                      ),
                    } else if(productData.kategori=="2")...{
                      Image.asset(
                        'assets/images/shopee_logo.png',
                        width: 85,
                        fit: BoxFit.fill,
                      ),
                    } else if(productData.kategori=="3")...{
                      Image.asset(
                        'assets/images/tokopedia_logo.png',
                        width: 85,
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
      )
  );
}

