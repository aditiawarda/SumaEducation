// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
    _getBookPage();

    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    openPlayer();

    super.initState();
  }

  void openPlayer() async {
    await _assetsAudioPlayer.open(
      Audio("assets/sounds/sound_book_1.mp3"),
      autoStart: true,
      showNotification: false,
    );
  }

  void _voiceOverSwitch() {
    setState(() {
      _voiceOver = !_voiceOver;
      _assetsAudioPlayer.playOrPause();
    });
  }

  Future _speak(String text) async {
    await flutterTts.setLanguage("ID");
    await flutterTts.setPitch(1.19);
    await flutterTts.speak(text);
  }

  late Uint8List bytes;
  final _controller = GlobalKey<PageTurnState>();
  late Stream<FileResponse> fileStream;

  void _downloadFile() {
    setState(() {
      fileStream = DefaultCacheManager().getFileStream('https://cdn.eurekabookhouse.co.id/ebh/product/all/tubuh.jpg', withProgress: true);
    });
  }

  void _getImageConv () async{
    print (bytes);
  }

  var pick;

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
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return WillPopScope(
      onWillPop: () async {
        new Future.delayed(new Duration(milliseconds: 300), () {
          Navigator.pop(context);
        });
        _assetsAudioPlayer.stop();
        return false;
      },
      child: Scaffold(
        body:
        Stack(
          children: [
            Container(
              child: FutureBuilder<String>(
                future: _getBookPage(), // async work
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return Text('Loading....');
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else
                        _getBookPage();
                      return PageTurn(
                        key: _controller,
                        backgroundColor: Colors.white,
                        showDragCutoff: false,
                        lastPage: Container(child: null),
                        children: <Widget>[
                          for (var i = 0; i < bookPage.length+1; i++)
                            if(i==0)...{
                              SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                      child: ClipRRect(
                                        child: CachedNetworkImage(
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            imageUrl: "https://suma.geloraaksara.co.id/uploads/cover_book/"+widget.book.cover,
                                            height: MediaQuery.of(context).size.height,
                                            fit:BoxFit.fitWidth
                                        ),
                                      )
                                  )
                              ),
                            } else if(i>0)...{
                              SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                      child: ClipRRect(
                                        child: CachedNetworkImage(
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            imageUrl: "https://suma.geloraaksara.co.id/uploads/book_page/"+bookPage[i-1].image,
                                            height: MediaQuery.of(context).size.height,
                                            fit:BoxFit.fitWidth
                                        ),
                                      )
                                  )
                              ),
                            }
                        ],
                      );
                  }
                },
              ),
            ),
            Container(
              height: 33,
              color: Colors.orange,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          child: Icon(
              _voiceOver ? Icons.volume_up : Icons
                  .volume_off, color: Colors.white),
          onPressed: () {
            _voiceOverSwitch();
          },
        ),
      )
    );

  }

}
