import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/main_page/model/story_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/screen/story_view_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class StoryFeed extends StatefulWidget {
  const StoryFeed(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _StoryFeedState createState() => _StoryFeedState();
}

class _StoryFeedState extends State<StoryFeed>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<StoryData> stories = [];
  late File image;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Future<String> _getDataStory() async {
    final SharedPreferences prefs = await _prefs;
    try {
      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/get_event_story"),
          body: {
            "id_user": prefs.getString("data_id"),
          });
        stories = [];
        var dataStory = json.decode(response.body);
        print(dataStory);
        for (var i = 0; i < dataStory['data'].length; i++) {
          var id = dataStory['data'][i]['id'];
          var id_user = dataStory['data'][i]['id_user'];
          var username = dataStory['data'][i]['username'];
          var deskripsi = dataStory['data'][i]['deskripsi'];
          var avatar = dataStory['data'][i]['picture'];
          var content = dataStory['data'][i]['filename'];
          var time = dataStory['data'][i]['created_at'];
          var status_view = dataStory['data'][i]['status_view'];
          stories.add(StoryData(id, id_user, username, deskripsi, avatar, content, time, status_view));
        }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  Future<Future> showImageSource(BuildContext context) async {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) =>
            SlideInUp(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topRight: Radius.circular(20.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.5),
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 3.0),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 3,
                      margin: EdgeInsets.only(top: 20, bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 15),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child:
                        ZoomTapAnimation(
                          onTap: () async {
                            Navigator.of(context).pop();
                            pickImageCamera();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.blue.shade600,
                            ),
                            child: Text(
                              'Camera',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child:
                        ZoomTapAnimation(
                          onTap: () {
                            Navigator.of(context).pop();
                            pickImageGallery();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.green.shade400,
                            ),
                            child: Text(
                              'Gallery',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child:
                        ZoomTapAnimation(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop('dialog');
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.orange.shade50,
                            ),
                            child: Text(
                              'Batal',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            )
    );
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      final cropped = await ImageCropper().cropImage(
        sourcePath: image!.path,
        aspectRatio: CropAspectRatio(ratioX: 9, ratioY: 16),
        compressQuality: 100,
        maxWidth: 900,
        maxHeight: 1600,
        compressFormat: ImageCompressFormat.jpg,
      );
      if (image == null) return;

      final imageTemporary = File(cropped!.path);
      setState(() {
        this.image = imageTemporary;
        String fileName = image.path.split('/').last;
        print('file : '+fileName);
        uploadImg(fileName);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => StoryCaption(image: this.image)),
        // );
      });
    } on PlatformException catch (e) {
      print('Gagal, Siahkan coba lagi');
    }
  }

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 9, ratioY: 16),
        compressQuality: 100,
        maxWidth: 900,
        maxHeight: 1600,
        compressFormat: ImageCompressFormat.jpg,
      );

      final imageTemporary = File(cropped!.path);
      setState(() {
        this.image = imageTemporary;
        String fileName = image.path.split('/').last;
        uploadImg(fileName);
      });
    } on PlatformException catch (e) {
      print('Gagal, Siahkan coba lagi');
    }
  }

  void uploadImg(fileName) async {
    final SharedPreferences prefs = await _prefs;
    try {
      List<int> imageBytes = image.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      print(baseimage);

      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/upload_event_content"),
          body: {
            "id_user": prefs.getString("data_id"),
            "category_content": "2",
            "file": baseimage,
            "name": fileName,
          });

      var json = jsonDecode(response.body);
      String status = json["status"];
      String message = json["message"];

      if (status == "Success") {
        stories = [];
        setState(() {
          _getDataStory();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    } catch (e) {
      print("Error during converting to Base64");
      new Future.delayed(new Duration(milliseconds: 2000), () {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return
            FadeTransition(
              opacity: widget.mainScreenAnimation!,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                child:
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: double.infinity,
                  height: 105,
                  child:
                    Stack(
                      children: [
                        Container(
                          height: 105,
                          width: double.infinity,
                          child: FutureBuilder<String>(
                            future: _getDataStory(), // function where you call your api
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return
                                  FadeInRight(
                                    delay: Duration(milliseconds: 300),
                                    child: Container(
                                      height: 105,
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
                                    ),
                                  );
                              } else {
                                if (snapshot.hasError)
                                  return
                                    FadeInRight(
                                      delay: Duration(milliseconds: 300),
                                      child: Container(
                                        height: 105,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/empty_data.png",
                                                height: 80),
                                            Container(
                                                margin: EdgeInsets.only(left: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Oops...',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15,
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
                                                        fontSize: 11,
                                                        letterSpacing: 0.5,
                                                        color: Colors.blueGrey.shade200,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                else
                                if (stories.length==0)
                                  return
                                    FadeInRight(
                                      delay: Duration(milliseconds: 300),
                                      child: Container(
                                        height: 105,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/empty_data.png",
                                                height: 80),
                                            Container(
                                                margin: EdgeInsets.only(left: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Oops...',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15,
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
                                                        fontSize: 11,
                                                        letterSpacing: 0.5,
                                                        color: Colors.blueGrey.shade200,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                else
                                  return ListView.builder(
                                      padding: EdgeInsets.only(left: 70, right: 15),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: stories.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return
                                          storyButton(stories[index], context);
                                      });
                              }
                            },
                          ),
                        ),
                        SlideInLeft(
                          delay: Duration(milliseconds: 800),
                          child: Container(
                              width: 70,
                              height: double.infinity,
                              color: Colors.transparent,
                              padding: EdgeInsets.only(right: 7),
                              child:
                              Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 12, bottom: 24),
                                  padding: EdgeInsets.only(right: 7),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xffd35712),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(57),
                                      topRight: Radius.circular(57),
                                    ),
                                  ),
                                  child:
                                  ZoomTapAnimation(
                                    child: GestureDetector(
                                        onTap: () async {
                                          final source = await showImageSource(context);
                                          if (source == null) return;
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 3),
                                              child: Icon(
                                                Icons.add_a_photo,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 3,),
                                            Text("STORIES",
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.white)
                                            )
                                          ],
                                        )
                                    ),
                                  )
                              )
                          ),
                        )
                      ],
                    ),
                ),
              ),
            );
      },
    );
  }
}

Widget storyButton(StoryData story, BuildContext context) {
  String fullName = story.userName;
  var names = fullName.split(' ');
  String firstName = names[0];
  return
    FadeInRight(
        delay : Duration(milliseconds: 300),
        child : Column(
          children: [
            ZoomTapAnimation(
              child: GestureDetector(
                onTap: () {
                  new Future.delayed(new Duration(milliseconds: 500), () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => StoryView(
                              story: story,
                            )
                        )
                    );
                  });
                },
                // you can add more gestures...
                child: Column(
                  children:<Widget> [
                    if(story.statusView=="Yet")...[
                      Container(
                        height: 105,
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 6, top: 10),
                                padding: EdgeInsets.all(2),
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange,
                                ),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: new BoxDecoration(
                                      border: Border.all(
                                          width: 3, color: Colors.white
                                      ),
                                      shape: BoxShape.circle,
                                      color: Colors.orange,
                                      image: new DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: new NetworkImage(story.storyUrl)
                                      )
                                  ),
                                )
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(firstName, style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        height: 105,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 6, top: 10),
                                padding: EdgeInsets.all(1.5),
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: new BoxDecoration(
                                      border: Border.all(
                                          width: 3, color: Colors.white
                                      ),
                                      shape: BoxShape.circle,
                                      color: Colors.orange,
                                      image: new DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: new NetworkImage(story.storyUrl)
                                      )
                                  ),
                                )
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              child:Text(firstName, style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            )
          ],
        )
    );
}

