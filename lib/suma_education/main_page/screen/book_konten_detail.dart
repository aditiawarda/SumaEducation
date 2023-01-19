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

  @override
  initState() {
    if(i==0){
      Timer(Duration(seconds: 2), () => {
        i = 1,
        setState(() {})
      });
    }
    _getImage();
    super.initState();
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

  Future<String>  _getImage() async{
    String urio = widget.book.cover_picture;

    var ImageLoad = CachedNetworkImage(
      placeholder: (context, url) => const CircularProgressIndicator(),
      imageUrl: widget.book.cover_picture,
      height: MediaQuery.of(context).size.height,
    );

    http.Response response = await http.get(
      Uri.parse(urio),
    );

    String _base64 = base64.encode(response.bodyBytes);

    if (ImageLoad!=null){
      // _getpage(_base64);
      print(_base64);
    }else(
        pick = ''
    );

    return Future.value("Data download successfully");

  }

  void refreshPage(){
  }

  @override
  build(context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      body: FutureBuilder<String>(
            future: _getImage(), // async work
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return Text('Loading....');
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else
                    refreshPage();
                  return PageTurn(
                    key: _controller,
                    backgroundColor: Colors.white,
                    showDragCutoff: false,
                    lastPage: Container(child: Center(child: Text('Last Page!'))),
                    children: <Widget>[
                      for (var i = 0; i < 7; i++)
                        SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      imageUrl: widget.book.cover_picture,
                                      height: MediaQuery.of(context).size.height,
                                      fit:BoxFit.fill
                                  ),
                                )
                              // CachedNetworkImage('https://cdn.eurekabookhouse.co.id/ebh/product/all/tubuh.jpg'),
                            )
                        ),
                    ],
                  );
              }
            },
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.volume_up, color: Colors.white,),
        onPressed: () {
          _controller.currentState!.goToPage(2);
        },
      ),
    );
  }

}
