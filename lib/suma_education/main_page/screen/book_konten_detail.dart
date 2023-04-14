// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:page_turn/page_turn.dart';
import 'package:suma_education/suma_education/main_page/model/book_list_data.dart';
import 'package:suma_education/suma_education/main_page/model/book_page.dart';

int i = 0;
String imageURL = 'https://cdn.eurekabookhouse.co.id/ebh/product/all/tubuh.jpg';

class DetailBukuState extends StatefulWidget {
  final BookData book;
  DetailBukuState({Key? key, required this.book}) : super(key: key);

  @override
  State<DetailBukuState> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<DetailBukuState> {

  final FlutterTts flutterTts = FlutterTts();
  bool _voiceOver = true;
  List<BookPage> bookPage = [];
  late AssetsAudioPlayer _assetsAudioPlayer;

  @override
  initState() {
    if(i==0){
      Timer(Duration(seconds: 2), () => {
        i = 1,
        setState(() {})
      });
    }
    // _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    // openPlayer();

    super.initState();
  }

  void openPlayer() async {
    await _assetsAudioPlayer.open(
      Audio("assets/sounds/sound_book_1.mp3"),
      autoStart: true,
      showNotification: false,
    );
  }

  late Uint8List bytes;
  final _controller = GlobalKey<PageTurnState>();

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
        var createdAt = dataBookPage['data'][i]['created_at'];
        bookPage.add(BookPage(id, idBook, pageNumber, image, createdAt));
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  @override
  build(context) {
    return Scaffold(
      body:
      Stack(
        children: [
          Container(
            child: FutureBuilder<String>(
              future: _getBookPage(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return
                    Container(
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
                    );
                } else {
                  if (snapshot.hasError)
                    return
                      Container(
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
                      );
                  else
                  if(bookPage.length==0)
                    return
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child:
                        CachedNetworkImage(
                          width: double.infinity,
                          fit: BoxFit.fill,
                          imageUrl: "https://suma.geloraaksara.co.id/uploads/cover_book/"+widget.book.cover,
                          placeholder: (context, url) => new Container(
                            margin: EdgeInsets.only(right: 10),
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                              strokeWidth: 2.5,
                            ),
                            height: 30.0,
                            width: 30.0,
                          ),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                        ),
                      );
                  else
                    return
                      PageView(
                        children: <Widget>[
                            for (var i = 0; i < bookPage.length+1; i++)
                              if(i==0)...{
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  CachedNetworkImage(
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                    imageUrl: "https://suma.geloraaksara.co.id/uploads/cover_book/"+widget.book.cover,
                                    placeholder: (context, url) => Container(
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
                                    errorWidget: (context, url, error) => new Icon(Icons.error),
                                  ),
                                ),
                              } else if(i>0)...{
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  CachedNetworkImage(
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                    imageUrl: "https://suma.geloraaksara.co.id/uploads/book_page/"+bookPage[i-1].image,
                                    placeholder: (context, url) => Container(
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
                                    errorWidget: (context, url, error) => new Icon(Icons.error),
                                  ),
                                ),
                              }
                          ],
                      );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

}
