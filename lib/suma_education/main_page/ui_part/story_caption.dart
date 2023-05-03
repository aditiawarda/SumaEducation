// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/main_page/screen/feed_screen.dart';

class StoryCaption extends StatefulWidget {
  final File image;
  final AnimationController? animationController;
  StoryCaption({Key? key, required this.image, required this.animationController}) : super(key: key);

  @override
  State<StoryCaption> createState() => _StoryCaptionState();
}

class _StoryCaptionState extends State<StoryCaption> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var text_keterangan = TextEditingController();
  double percent = 0.0;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.animationController?.forward();
    return
      Container(
        color: AppTheme.background,
        child: Scaffold(
            body: Stack (
              children: <Widget> [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: Image.file(widget.image,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child:
                      Stack(
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            width: MediaQuery.of(context).size.width,
                            child:
                            Container(
                              height: 50,
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(40.0),
                                    topRight: const Radius.circular(40.0),
                                    bottomLeft: const Radius.circular(40.0),
                                    bottomRight: const Radius.circular(40.0),
                                  )
                              ),
                              child: TextField(
                                  autofocus: false,
                                  obscureText: false,
                                  maxLines: 5,
                                  controller: text_keterangan,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 26),
                                    hintText: 'Tambah keterangan...',
                                  )
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            width: MediaQuery.of(context).size.width,
                            child: InkWell(
                                onTap: (){
                                  String fileName = widget.image.path.split('/').last;
                                  uploadImg(fileName);
                                },
                                child:
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.orange,
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.solidArrowAltCircleRight,
                                    color: Colors.white,
                                  ),
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                )
              ],
            )
        )
      );
  }

  void uploadImg(fileName) async {
    final SharedPreferences prefs = await _prefs;
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    try {
      List<int> imageBytes = widget.image.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      String keterangan = text_keterangan.text;
      print(baseimage);

      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/upload_event_content"),
          body: {
            "id_user": prefs.getString("data_id"),
            "category_content": "1",
            "file": baseimage,
            "name": fileName,
            "deskripsi": keterangan,
            "time": currentDate,
          });

      var json = jsonDecode(response.body);
      String status = json["status"];
      String message = json["message"];

      if (status == "Success") {
        Navigator.pop(context);
        // setState((){});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    } catch (e) {
      print("Error during converting to Base64");
    }
  }

}