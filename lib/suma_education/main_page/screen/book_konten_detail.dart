// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/book_page.dart';

class DetailBukuState extends StatefulWidget {
  final BookData book;
  DetailBukuState({Key? key, required this.book}) : super(key: key);

  @override
  State<DetailBukuState> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<DetailBukuState> {

  final FlutterTts flutterTts = FlutterTts();
  List<BookPage> bookPage = [];
  final player = AudioPlayer();
  final backsound = AudioPlayer();
  late int selectedPage;
  late final PageController _pageController;

  bool end = false;

  @override
  initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    setState(() {
      if(widget.book.voice_cover!=null){
        player.setUrl('https://suma.geloraaksara.co.id/uploads/voice_over/cover/'+widget.book.voice_cover);
        player.setVolume(1.0);
        player.play();
      }

      if(widget.book.backsound!=null){
        backsound.setUrl('https://suma.geloraaksara.co.id/uploads/voice_over/backsound/'+widget.book.backsound);
        backsound.setVolume(0.5);
        backsound.setLoopMode(LoopMode.one);
        backsound.play();
      }
    });

    // Timer.periodic(Duration(seconds: 2), (Timer timer) {
    //   if (selectedPage == int.parse(widget.book.jumlah_halaman)) {
    //     end = true;
    //   } else if (selectedPage == 0) {
    //     end = false;
    //   }
    //
    //   if (end == false) {
    //     selectedPage++;
    //   } else {
    //     selectedPage--;
    //   }
    //
    //   _pageController.animateToPage(
    //     selectedPage,
    //     duration: Duration(milliseconds: 1000),
    //     curve: Curves.easeIn,
    //   );
    //
    // });

    super.initState();
  }

  Future<String> _getBookPage() async {
    try {
      var response = await http.post(Uri.parse("https://suma.geloraaksara.co.id/api/get_book_page"),
          body: {
            "id_book": widget.book.id,
          });
      bookPage = [];
      var dataBookPage = json.decode(response.body);
      print(dataBookPage);
      for (var i = 0; i < dataBookPage['data'].length; i++) {
        var id = dataBookPage['data'][i]['id'];
        var idBook = dataBookPage['data'][i]['id_book'];
        var pageNumber = dataBookPage['data'][i]['page_number'];
        var image = dataBookPage['data'][i]['image'];
        var voice_over = dataBookPage['data'][i]['voice_over'];
        var createdAt = dataBookPage['data'][i]['created_at'];
        bookPage.add(BookPage(id, idBook, pageNumber, image, voice_over, createdAt));
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  @override
  void dispose() {
    player.stop();
    backsound.stop();
    player.dispose();
    backsound.dispose();
    super.dispose();
  }

  @override
  build(context) {
    final pageCount = int.parse(widget.book.jumlah_halaman);
    return
      WillPopScope(
          onWillPop: () async {
            player.stop();
            backsound.stop();
            return true;
          },
          child: Scaffold(
            body:
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        selectedPage = page;
                        if(page==0){ // Cover
                          player.setUrl('https://suma.geloraaksara.co.id/uploads/voice_over/cover/'+bookPage[page].voice_over);
                          player.play();
                        } else {
                          if(page-1<0){
                            player.stop();
                          } else {
                            if(bookPage[page].voice_over!=null) {
                              if(page!=0){  // Halaman 1 - Selesai
                                player.setUrl('https://suma.geloraaksara.co.id/uploads/voice_over/page/'+bookPage[page].voice_over);
                                player.play();
                              }
                            } else {
                              player.stop();
                            }
                          }
                        }
                      });
                    },
                    children: List.generate(pageCount, (index) {
                      return
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              FutureBuilder<String>(
                                  future: _getBookPage(),
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return
                                      Container(
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
                                      );
                                    } else {
                                      if (snapshot.hasError)
                                        return
                                          Container(
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
                                          );
                                      else
                                      if(index==0)
                                        return
                                          Container(
                                            height: MediaQuery.of(context).size.height,
                                            width: MediaQuery.of(context).size.width,
                                            child:
                                            CachedNetworkImage(
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                              imageUrl: "https://suma.geloraaksara.co.id/uploads/cover_book/"+widget.book.cover,
                                              placeholder: (context, url) => Container(
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    child: Container(
                                                        alignment: Alignment.center,
                                                        height: MediaQuery.of(context).size.height,
                                                        width: MediaQuery.of(context).size.width,
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
                                              errorWidget: (context, url, error) => new Icon(Icons.error),
                                            ),
                                          );
                                      else
                                        return
                                          Container(
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
                                              CachedNetworkImage(
                                                height: double.infinity,
                                                width: double.infinity,
                                                fit: BoxFit.contain,
                                                imageUrl: "https://suma.geloraaksara.co.id/uploads/book_page/" +
                                                    bookPage[index].image,
                                                placeholder: (context, url) =>
                                                Container(
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      height: MediaQuery.of(context).size.height,
                                                      width: MediaQuery.of(context).size.width,
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
                                                errorWidget: (context, url,
                                                    error) => new Icon(Icons.error),
                                              )
                                          );
                                    }
                                  }
                              ),
                            ],
                          ),
                        );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: PageViewDotIndicator(
                    currentItem: selectedPage,
                    count: pageCount,
                    unselectedColor: Colors.black26.withOpacity(0.2),
                    selectedColor: Colors.orange,
                    duration: Duration(milliseconds: 200),
                    boxShape: BoxShape.circle,
                    size: Size.fromRadius(10),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          )
      );
  }

}
