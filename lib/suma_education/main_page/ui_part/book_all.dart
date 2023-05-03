import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
import 'package:suma_education/suma_education/main_page/screen/book_konten_detail.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

SharedPreferences? prefs;

class BookListAllData extends StatefulWidget {
  const BookListAllData(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.animationControllerBottomSheet})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final AnimationController? animationControllerBottomSheet;

  @override
  _BookListAllDataState createState() => _BookListAllDataState();
}

class _BookListAllDataState extends State<BookListAllData>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<BookData> bookListData = [];

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _getBookContent();
    super.initState();
  }

  Future<String> _getBookContent() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/get_content_book"),
          body: {
            "id_user": "request",
          });
      bookListData = [];
      var dataBook = json.decode(response.body);
      print(dataBook);
      for (var i = 0; i < dataBook['data'].length; i++) {
        var id = dataBook['data'][i]['id'];
        var judul = dataBook['data'][i]['judul'];
        var deskripsi = dataBook['data'][i]['deskripsi'];
        var cover = dataBook['data'][i]['cover'];
        var created_at = dataBook['data'][i]['created_at'];
        var jumlah_halaman = dataBook['data'][i]['jumlah_halaman'];
        var voice_cover = dataBook['data'][i]['voice_cover'];
        var backsound = dataBook['data'][i]['backsound'];

        bookListData.add(BookData(id, judul, deskripsi, cover, created_at, jumlah_halaman, voice_cover, backsound));
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
    return
      Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 5),
        width: MediaQuery.of(context).size.width,
        child:
        Wrap(
            children: <Widget>[
              FutureBuilder<String>(
                future: _getBookContent(), // function where you call your api
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
                    if(bookListData.length==0)
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
                                crossAxisCount: 2,
                                childAspectRatio: 0.732,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                            itemCount: bookListData.length,
                            itemBuilder: (BuildContext context, int index) {
                              animationController?.forward();
                              return itemBookAll(bookListData[index], context, animationController!);
                            });
                  }
                },
              ),
            ]
        ),
      );
  }
}

Widget itemBookAll(BookData bookData, BuildContext context, AnimationController animationController){
  return
    ZoomTapAnimation(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => DetailBukuState(
                  book: bookData,
                )
            )
        );
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
        Column(
          children: [
            Wrap(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      Image.asset(
                        'assets/images/no_image_2.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: 'https://suma.geloraaksara.co.id/uploads/cover_book/'+bookData.cover,
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
          ],
        ) ,
      )
    );
}
