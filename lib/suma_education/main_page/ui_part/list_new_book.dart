import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
import 'package:suma_education/suma_education/main_page/screen/book_content_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/book_konten_detail.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ListNewBook extends StatefulWidget {
  const ListNewBook(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _ListNewBookState createState() => _ListNewBookState();
}

class _ListNewBookState extends State<ListNewBook>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<BookData> newBookData = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<String> getNewBook() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/get_content_book_new"),
          body: {
            "id_user": "request",
          });
      newBookData = [];
      var dataBookNew = json.decode(response.body);
      print(dataBookNew);
      for (var i = 0; i < dataBookNew['data'].length; i++) {
        var id = dataBookNew['data'][i]['id'];
        var judul = dataBookNew['data'][i]['judul'];
        var deskripsi = dataBookNew['data'][i]['deskripsi'];
        var cover = dataBookNew['data'][i]['cover'];
        var created_at = dataBookNew['data'][i]['created_at'];
        newBookData.add(BookData(id, judul, deskripsi, cover, created_at));
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
        return
          FadeInUp(
              delay : Duration(milliseconds: 500),
              child :  FadeTransition(
                opacity: widget.mainScreenAnimation!,
                child: Transform(
                  transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                  child:
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 10),
                    child: Container(
                        padding: EdgeInsets.only(top: 25, bottom: 25, left: 20, right: 20),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'READING',
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                                Text(
                                  'STORY',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Cerita terbaru dari Suma dan Sahabat',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'RobotoMono',
                                  color: Colors.black87.withOpacity(0.5),
                                ),
                              ),
                            ),
                            Container(
                              child: Wrap(
                                children: <Widget>[
                                  FutureBuilder<String>(
                                    future: getNewBook(), // function where you call your api
                                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return SizedBox(child: null);
                                      } else {
                                        if (snapshot.hasError)
                                          return GridView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.7427,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 20),
                                              itemCount: newBookData.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                animationController?.forward();
                                                return itemBuku(newBookData[index], context, animationController!);
                                              });
                                        else
                                        if(newBookData.length==0)
                                          return
                                            FadeInUp(
                                              delay: Duration(milliseconds: 500),
                                              child: Container(
                                                margin: EdgeInsets.only(top: 130),
                                                padding: EdgeInsets.only(bottom: 100),
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
                                                          'Data tidak tersedia',
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
                                                          'Data peserta tidak tersedia',
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
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.7427,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 20),
                                              itemCount: newBookData.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                animationController?.forward();
                                                return itemBuku(newBookData[index], context, animationController!);
                                              });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 30, bottom: 10),
                              child:
                              ZoomTapAnimation(
                                  child: GestureDetector(
                                      onTap: () {
                                        new Future.delayed(new Duration(milliseconds: 300), () {
                                          Navigator.push<dynamic>(
                                              context,
                                              MaterialPageRoute<dynamic>(
                                                builder: (BuildContext context) => BookContentScreen(animationController: animationController),
                                              )
                                          );
                                        });
                                      },
                                      child:
                                      Text(
                                        "Lihat Selengkapnya",
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          letterSpacing: 0.5,
                                          color: AppTheme.grey.withOpacity(0.7),
                                        ),
                                      )
                                  )
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                ),
              )
          );
      },
    );
  }
}

Widget itemBuku(BookData book, BuildContext context, AnimationController animationController) {
  return
    AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return
        FadeInUp(
            delay : Duration(milliseconds: 500),
            child : ZoomTapAnimation(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => DetailBukuState(book: book)
                      )
                  );
                },
                // you can add more gestures...
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
                                      'https://suma.geloraaksara.co.id/uploads/cover_book/'+book.cover,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ) ,
                    )
                ),
              ),
            )
        );
      }
    );
}

// Widget itemParticipant(BookData participantData, BuildContext context, AnimationController animationController, Animation<double> animation){
//   return
//     AnimatedBuilder(
//       animation: animationController,
//       builder: (BuildContext context, Widget? child) {
//         return FadeInUp(
//           delay: Duration(milliseconds: 600),
//           child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: <BoxShadow>[
//                   BoxShadow(
//                       color: AppTheme.grey.withOpacity(0.4),
//                       offset: Offset(1.0, 1.1),
//                       blurRadius: 3.0),
//                 ],
//                 gradient: LinearGradient(
//                   colors: <HexColor>[
//                     HexColor("#ffffff"),
//                     HexColor("#ffffff"),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(10.0),
//                   bottomLeft: Radius.circular(10.0),
//                   topLeft: Radius.circular(10.0),
//                   topRight: Radius.circular(10.0),
//                 ),
//               ),
//               child:
//                   Stack(
//                     children: [
//                       Positioned(
//                         bottom: 0, right: 0,
//                         child: ClipRRect(
//                           borderRadius:
//                           BorderRadius.all(Radius.circular(10.0)),
//                           child: SizedBox(
//                             height: 50,
//                             child: AspectRatio(
//                               aspectRatio: 1.714,
//                               child: Image.asset(
//                                   "assets/portal_app/participant.png"),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       Row(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.only(top: 10, bottom: 10),
//                             width: 10,
//                             height: 39,
//                             decoration: BoxDecoration(
//                               color: Colors.purple.shade900.withOpacity(0.6),
//                               borderRadius: BorderRadius.only(topRight: Radius.circular(4.0), bottomRight: Radius.circular(4.0)),
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.only(left: 20, right: 20),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(participantData.judul,
//                                   textAlign: TextAlign.left,
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                     fontFamily: AppTheme.fontName,
//                                     fontSize: 15,
//                                     letterSpacing: 0.5,
//                                     color: AppTheme.lightText,
//                                   ),
//                                 ),
//                                 Text(participantData.id,
//                                   textAlign: TextAlign.left,
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                     fontFamily: AppTheme.fontName,
//                                     fontSize: 13,
//                                     letterSpacing: 0.5,
//                                     color: AppTheme.lightText,
//                                   ),
//                                 ),
//                                 Text(participantData.id,
//                                   textAlign: TextAlign.left,
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                     fontFamily: AppTheme.fontName,
//                                     fontSize: 13,
//                                     letterSpacing: 0.5,
//                                     color: AppTheme.lightText,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   )
//
//           ),
//         );
//       },
//     );
// }

