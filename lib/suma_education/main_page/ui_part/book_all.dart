import 'dart:convert';

import 'package:animate_do/animate_do.dart';
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

        bookListData.add(BookData(id, judul, deskripsi, cover, created_at));
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
      AnimatedBuilder(
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
                    delay : Duration(milliseconds: 500),
                    child : Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 30),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child:
                      Wrap(
                        children:[
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
                                            childAspectRatio: 0.741,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5),
                                        itemCount: bookListData.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          animationController?.forward();
                                          return itemBookAll(bookListData[index], context, animationController!);
                                        });
                              }
                            },
                          ),
                        ],
                      ),
                    )
                )
              ),
            );
        },
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
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child:
          Container(
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(9)),
            child:
            Column(
              children: [
                Wrap(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child:
                          Image.asset(
                            'assets/images/no_image_2.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child:
                          Image.network(
                            'https://suma.geloraaksara.co.id/uploads/cover_book/'+bookData.cover,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Container(
                //   padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 12),
                //   child: Text(bookData.judul,
                //       style:
                //       GoogleFonts.roboto(
                //           color: Colors.blueGrey,
                //           fontSize: 14.0,
                //           height: 1.5
                //       ),
                //       textAlign: TextAlign.center,
                //   ),
                // )
              ],
            ) ,
          )
      ),
    );
}
