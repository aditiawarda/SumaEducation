// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
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
import 'package:suma_education/suma_education/main_page/ui_part/main_menu.dart';


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

  @override
  initState() {
    if(i==0){
      Timer(Duration(seconds: 2), () => {
        i = 1,
        setState(() {})
      });
    }
    _getBookPage();
    super.initState();
  }

  void _voiceOverSwitch() {
    setState(() {
      _voiceOver = !_voiceOver;
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
        var id_book = dataBookPage['data'][i]['id_book'];
        var page_number = dataBookPage['data'][i]['page_number'];
        var image = dataBookPage['data'][i]['image'];
        var created_at = dataBookPage['data'][i]['created_at'];
        bookPage.add(BookPage(id, id_book, page_number, image, created_at));
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  Future<String>  _getImage() async{
    String urio = "https://suma.geloraaksara.co.id/uploads/cover_book/"+widget.book.cover;

    var ImageLoad = CachedNetworkImage(
      placeholder: (context, url) => const CircularProgressIndicator(),
      imageUrl: "https://suma.geloraaksara.co.id/uploads/cover_book/"+widget.book.cover,
      height: MediaQuery.of(context).size.height,
    );

    http.Response response = await http.get(
      Uri.parse(urio),
    );

    String _base64 = base64.encode(response.bodyBytes);

    if (ImageLoad!=null){
      print(_base64);
    } else (
        pick = ''
    );

    return Future.value("Data download successfully");

  }

  void refreshPage(){
  }

  @override
  build(context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
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
                        for (var i = 0; i < bookPage.length; i++)
                          // if(i==0)...{
                          //   SizedBox(
                          //       height: MediaQuery.of(context).size.height,
                          //       width: MediaQuery.of(context).size.width,
                          //       child: Container(
                          //           child: ClipRRect(
                          //             child: CachedNetworkImage(
                          //                 placeholder: (context, url) => const CircularProgressIndicator(),
                          //                 imageUrl: "https://suma.geloraaksara.co.id/uploads/cover_book/"+widget.book.cover,
                          //                 height: MediaQuery.of(context).size.height,
                          //                 fit:BoxFit.fitWidth
                          //             ),
                          //           )
                          //       )
                          //   ),
                          // } else if(i>0)...{
                            SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                    child: ClipRRect(
                                      child: CachedNetworkImage(
                                          placeholder: (context, url) => const CircularProgressIndicator(),
                                          imageUrl: "https://suma.geloraaksara.co.id/uploads/book_page/"+bookPage[i].image,
                                          height: MediaQuery.of(context).size.height,
                                          fit:BoxFit.fitWidth
                                      ),
                                    )
                                )
                            ),
                          // }
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
    );
  }

}
