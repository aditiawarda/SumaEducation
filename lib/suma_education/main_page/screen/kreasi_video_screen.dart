// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:suma_education/suma_education/main_page/ui_part/book_all.dart';
import 'package:suma_education/suma_education/main_page/ui_part/kreasi_all.dart';
import 'package:suma_education/suma_education/main_page/ui_part/logout_button.dart';
import 'package:suma_education/suma_education/main_page/ui_part/space_bar.dart';
import 'package:suma_education/suma_education/main_page/ui_part/user_bio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../app_theme/app_theme.dart';

class KreasiScreen extends StatefulWidget {
  const KreasiScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _KreasiScreenState createState() => _KreasiScreenState();
}

class _KreasiScreenState extends State<KreasiScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  AnimationController? animationControllerBottomSheet;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
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
    const int count = 5;

    // listViews.add(
    //   SpaceBar(
    //     mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController!,
    //         curve:
    //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //     mainScreenAnimationController: widget.animationController!,
    //   ),
    // );

    listViews.add(
      KreasiListAllData(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void _onRefresh() async{
    setState(() {
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
                SizedBox(
                  height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top,
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
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
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
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {
                                  new Future.delayed(new Duration(milliseconds: 300), () {
                                    Navigator.pop(context);
                                  });
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: AppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Video Kreasi',
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
                                                        child: Text('Suma App merupakan platform aplikasi pembelajaran yang dibuat special untuk sahabat Suma di seluruh Indonesia. \n\nVersi yang saat ini kamu gunakan adalah v 1.1.2',
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
                      )
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
}
