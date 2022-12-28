// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/main_page/model/carousel_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MainCarousel extends StatefulWidget {
  const MainCarousel(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _MainCarouselState createState() => _MainCarouselState();
}

class _MainCarouselState extends State<MainCarousel>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  int pageIndex = 0;
  int indexNumber = 0;
  List<CarouselData> listCarousel = [];

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  getIndex() {
    indexNumber = pageIndex;
  }

  Future<String> getCarousel() async {
    try {
      var response = await http.get(Uri.parse("https://tokosuma.co.id/api/get_banner_data"));
      var dataCarousel = json.decode(response.body);

      if(listCarousel.length==0){
        for (var i = 0; i < dataCarousel['data'].length; i++) {
          var IdImage = dataCarousel['data'][i]['id_banner'];
          var Image = dataCarousel['data'][i]['banner'];
          listCarousel.add(CarouselData(IdImage, Image));
        }
      } else {
        listCarousel = listCarousel;
      }

    } catch (e) {
      print(e.toString());
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
            child: Transform(
              transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
              child:
              Column(
                children: [
                  FutureBuilder<String>(
                    future: getCarousel(), // function where you call your api
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return
                          FadeInUp(
                            delay: Duration(milliseconds: 500),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 7, top: 20),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                    height: 150.0,
                                    autoPlay: true,
                                    onPageChanged: (i, _) {
                                      pageIndex = i;
                                    }
                                ),
                                items: listCarousel.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return
                                        itemCorousel(listCarousel[pageIndex], context);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                      } else {
                        if (snapshot.hasError)
                          return FadeInUp(
                            delay: Duration(milliseconds: 500),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 7, top: 20),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                    height: 150.0,
                                    autoPlay: true,
                                    onPageChanged: (i, _) {
                                      pageIndex = i;
                                    }
                                ),
                                items: listCarousel.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return
                                        itemCorousel(listCarousel[pageIndex], context);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        else
                        if(listCarousel.length==0)
                          return
                            FadeIn(
                              delay: Duration(milliseconds: 1000),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(bottom: 7, top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/no_internet.png",
                                        height: 80),
                                    Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Koneksi terputus',
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
                                              'Tidak ada internet',
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
                          return
                            FadeInUp(
                              delay: Duration(milliseconds: 500),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 7, top: 20),
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                      height: 150.0,
                                      autoPlay: true,
                                      onPageChanged: (i, _) {
                                        pageIndex = i;
                                      }
                                  ),
                                  items: listCarousel.map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return
                                          itemCorousel(listCarousel[pageIndex], context);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
      },
    );
  }
}


Widget itemCorousel(CarouselData carouselData, BuildContext context){
  return
    Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topRight: Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: AppTheme.grey.withOpacity(0.3),
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 3.0),
        ],
      ),
      child:
        InkWell(
          onTap: () async {
            await launch("https://tokosuma.co.id/");
          },
          child: Stack(
            children: [
              Center(
                child:
                SizedBox(
                  height: 20,
                  width: 20,
                  child:  CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.blueGrey.shade100,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network('https://tokosuma.co.id/toko-suma/storage/app/public/banner/'+carouselData.Image,
                  fit: BoxFit.fitHeight,
                  height: 140,
                ),
              )
            ],
          ),
        ),
  );
}

