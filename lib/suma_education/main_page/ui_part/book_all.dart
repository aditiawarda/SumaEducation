import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ripple_animation/ripple_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
import 'package:suma_education/suma_education/main_page/screen/book_konten_detail.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../main.dart';

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
    return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(left: 20, right: 20, top: 15),
        width: MediaQuery.of(context).size.width,
        child:
        Wrap(
          children: <Widget>[
            FutureBuilder<String>(
              future: _getBookContent(), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.60,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 5),
                      itemCount: bookListData.length,
                      itemBuilder: (BuildContext context, int index) {
                        final int count = bookListData.length;
                        final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                        animationController?.forward();
                        var tinggi = MediaQuery.of(context).size.height;
                        var lebar = MediaQuery.of(context).size.width;
                        return itemBookAll(bookListData[index], context, lebar, tinggi, widget.animationControllerBottomSheet!);
                      });
                } else {
                  if (snapshot.hasError)
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.60,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5),
                        itemCount: bookListData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = bookListData.length;
                          final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                          animationController?.forward();
                          var tinggi = MediaQuery.of(context).size.height;
                          var lebar = MediaQuery.of(context).size.width;
                          return itemBookAll(bookListData[index], context, lebar, tinggi, widget.animationControllerBottomSheet!);
                        });
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
                          padding: EdgeInsets.only(bottom: 150),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.60,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5),
                          itemCount: bookListData.length,
                          itemBuilder: (BuildContext context, int index) {
                            final int count = bookListData.length;
                            final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                            animationController?.forward();
                            var tinggi = MediaQuery.of(context).size.height;
                            var lebar = MediaQuery.of(context).size.width;
                            return itemBookAll(bookListData[index], context, lebar, tinggi, widget.animationControllerBottomSheet!);
                          });
                }
              },
            )
          ],
        ),
    );
  }
}

Widget itemBookAll(BookData bookData, BuildContext context,var lebar,var tinggi, AnimationController animationController){
  var tinggifix = tinggi/7;
  var lebarfix = lebar/4;
  return
    FadeInUp(
        delay : Duration(milliseconds: 500),
        child: ZoomTapAnimation(
            child: GestureDetector(
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
                  alignment: Alignment.center,
                  width:  lebar/4,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child:
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
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
                        width: lebarfix,
                        margin: EdgeInsets.only(top: 40, left: 5,right: 5),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        width: lebarfix,
                        padding: EdgeInsets.only(left: 18, right: 7, top: 10, bottom: 10),
                        child:
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child:
                              Image.network(
                                  "https://suma.geloraaksara.co.id/uploads/cover_book/"+bookData.cover,
                                  width: lebarfix,
                                  height: tinggifix,
                                  fit:BoxFit.fill
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(bookData.judul,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
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
