// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/model/story_data.dart';
import 'package:suma_education/suma_education/main_page/screen/login_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/story_view_screen.dart';
import 'package:suma_education/suma_education/main_page/ui_part/feeds_list_video.dart';
import 'package:suma_education/suma_education/main_page/ui_part/logout_button.dart';
import 'package:suma_education/suma_education/main_page/ui_part/story_caption.dart';
import 'package:suma_education/suma_education/main_page/ui_part/story_feed.dart';
import 'package:suma_education/suma_education/main_page/ui_part/timeline_feed.dart';
import 'package:suma_education/suma_education/main_page/ui_part/user_bio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../app_theme/app_theme.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  AnimationController? animationControllerBottomSheet;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  List<StoryData> stories = [];
  late File image;
  String? kategoriPosting = "";
  String boolLogin = "";

  @override
  void initState() {
    _getDataStory();
    animationControllerBottomSheet = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {

    listViews.add(
      TimelineFeed(),
    );

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void _onRefresh() async{
    setState(() {
      _getDataStory();
      listViews.clear();
      addAllListData();
    });
    await Future.delayed(Duration(milliseconds: 1500));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  Future<String> getUser() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getBool('login') == true){
      boolLogin = "true";
    } else {
      boolLogin = "false";
    }
    return 'true';
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
                            if(kategoriPosting=='1'){
                              pickImageCameraTimeline();
                            } else if(kategoriPosting=='2'){
                              pickImageCameraStory();
                            }
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
                            if(kategoriPosting=='1'){
                              pickImageGalleryTimeline();
                            } else if(kategoriPosting=='2'){
                              pickImageGalleryStory();
                            }
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

  Future pickImageCameraStory() async {
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

  Future pickImageCameraTimeline() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      final cropped = await ImageCropper().cropImage(
        sourcePath: image!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 500,
        maxHeight: 500,
        compressFormat: ImageCompressFormat.jpg,
      );
      if (image == null) return;

      final imageTemporary = File(cropped!.path);
      setState(() {
        this.image = imageTemporary;
        String fileName = image.path.split('/').last;
        print('file : '+fileName);
        //uploadImg(fileName);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoryCaption(image: this.image, animationController: widget.animationController)),
        );
      });
    } on PlatformException catch (e) {
      print('Gagal, Siahkan coba lagi');
    }
  }

  Future pickImageGalleryStory() async {
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

  Future pickImageGalleryTimeline() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 500,
        maxHeight: 500,
        compressFormat: ImageCompressFormat.jpg,
      );

      final imageTemporary = File(cropped!.path);
      setState(() {
        this.image = imageTemporary;
        String fileName = image.path.split('/').last;
        //uploadImg(fileName);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoryCaption(image: this.image, animationController: widget.animationController)),
        );
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
            "category_content": kategoriPosting.toString(),
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
        setState(() {
          _onRefresh();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                FutureBuilder<String>(
                  future: getUser(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return
                    Stack(
                      children: [
                        if(boolLogin=="true")...{
                          SizedBox(
                            height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + 105,
                          ),
                        } else ...{
                          SizedBox(
                            height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top,
                          ),
                        }
                      ],
                    );
                  }
                ),
                Expanded(
                  child: getMainListViewUI()
                )
              ],
            ),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
        floatingActionButton:
        FadeInRight(
          delay: Duration(milliseconds: 300),
          child:
          FutureBuilder<String>(
              future: getUser(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return
                  Stack(
                    children: [
                      if(boolLogin=="true")...{
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child: FloatingActionButton(
                            elevation: 2,
                            onPressed: () async {
                              kategoriPosting = "1";
                              final source = await showImageSource(context);
                              if (source == null) return;
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 2),
                              child: Icon(Icons.post_add, color: Colors.white, size: 27,),
                            ),
                            backgroundColor: Color(0xffd35712),
                          ),
                        ),
                      }
                    ],
                  );
              }
          ),
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return
            Theme(
              data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange[100])),
              child:
              SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                footer: null,
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    bottom: 62 + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: listViews.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    widget.animationController?.forward();
                    return listViews[index];
                  },
                ),
              ),
            );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Feeds',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuButton<int>(
                              icon: Icon(Icons.more_vert),
                              onSelected: (int size) {
                                print(size);
                                if (size==1){
                                  showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      transitionAnimationController: animationControllerBottomSheet,
                                      builder: (BuildContext context) {
                                        return
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
                                                  Row(
                                                    children: <Widget>[
                                                      SizedBox(width: 35),
                                                      Image.asset('assets/images/whatsapp_connect.png', height: 80, width: 80),
                                                      Padding(
                                                          padding: const EdgeInsets.only( left: 20),
                                                          child:
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Container(
                                                                child: Text("Customer Service",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        fontFamily: AppTheme.fontName,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 18,
                                                                        letterSpacing: 0.0,
                                                                        color: AppTheme.grey.withOpacity(0.6)
                                                                    )
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context).size.width*0.6,
                                                                padding: EdgeInsets.only(right: 5),
                                                                child: Text('Kamu akan terhubung melalui WhatsApp Customer Service',
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 3,
                                                                    style: TextStyle(
                                                                        fontFamily: AppTheme.fontName,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 16,
                                                                        height: 1.5,
                                                                        letterSpacing: 0.0,
                                                                        color: AppTheme.grey.withOpacity(0.6)
                                                                    )
                                                                ),
                                                              ),
                                                              SizedBox(width: 35),
                                                            ],
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(top: 15),
                                                      alignment: Alignment.center,
                                                      width: MediaQuery.of(context).size.width,
                                                      height: 40,
                                                      child:
                                                      ZoomTapAnimation(
                                                        onTap: () async {
                                                          Navigator.of(context, rootNavigator: true).pop('dialog');
                                                          await launch("https://wa.me/6285721603080?text=Hello");
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: 20, right: 20),
                                                          alignment: Alignment.center,
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            color: Colors.orange.shade600,
                                                          ),
                                                          child: Text(
                                                            'Hubungkan',
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
                                          );
                                      }
                                  );
                                } else if (size==2) {
                                  showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      transitionAnimationController: animationControllerBottomSheet,
                                      builder: (BuildContext context) {
                                        return
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
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(left: 25, right: 25),
                                                        child: Text('Tentang App',
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontFamily: AppTheme.fontName,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 18,
                                                                letterSpacing: 0.0,
                                                                color: AppTheme.grey.withOpacity(0.6)
                                                            )
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Text('Suma App merupakan platform aplikasi pembelajaran yang dibuat special untuk sahabat Suma di seluruh Indonesia. \n\nVersi yang saat ini kamu gunakan adalah v 1.1.4',
                                                            style: TextStyle(
                                                                fontFamily: AppTheme.fontName,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 16,
                                                                height: 1.5,
                                                                letterSpacing: 0.0,
                                                                color: AppTheme.grey.withOpacity(0.6)
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(top: 5, bottom: 20),
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
                                                            color: Colors.orange.shade600,
                                                          ),
                                                          child: Text(
                                                            'Tutup',
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
                                                ],
                                              ),
                                            ),
                                          );
                                      }
                                  );
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.headset_mic_outlined),
                                      SizedBox(
                                        // sized box with width 10
                                        width: 10,
                                      ),
                                      Text("Customer Service")
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.phone_android_rounded),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Tentang App")
                                    ],
                                  ),
                                ),
                              ],
                              offset: Offset(-6,45),
                              color: Colors.white,
                              elevation: 5,
                            ),
                          ],
                        ),
                      ),
                      if(boolLogin=="true")...{
                        Container(
                          color: Colors.white,
                          width: double.infinity,
                          height: 105,
                          child:
                          Stack(
                            children: [
                              Container(
                                  height: 105,
                                  width: double.infinity,
                                  child:
                                  Stack(
                                    children: [
                                      if(stories.length==0)...{
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
                                                    height: 55),
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
                                        )
                                      } else ...{
                                        ListView.builder(
                                            padding: EdgeInsets.only(left: 70, right: 15),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: stories.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return
                                                storyButton(stories[index], context);
                                            })
                                      }
                                    ],
                                  )

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
                                                kategoriPosting = "2";
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
                      }
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
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

}
