// ignore_for_file: unnecessary_statements, deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:suma_education/suma_education/main_page/ui_part/made_with_love.dart';
import 'package:suma_education/suma_education/main_page/ui_part/main_menu.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

SharedPreferences? prefs;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  AnimationController? animationControllerBottomSheet;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

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
    const int count = 9;

    listViews.add(
      MainMenu(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        animationControllerBottomSheet: animationControllerBottomSheet,
      ),
    );

    listViews.add(
      MainMade(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness:
      !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            FadeTransition(
              opacity: widget.animationController!,
              child: Transform(
                  transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.animationController!.value), 0.0),
                  child:
                  Container(
                    margin: const EdgeInsets.only(top: 90.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background_page.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: null /* add child content here */,
                  )
              ),
            ),
            getBackWiget(),
            Column(
              children: [
                SizedBox(
                  height : MediaQuery.of(context).viewPadding.top
                ),
                Expanded(
                  child: getMainListViewUI()
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
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

  Widget getBackWiget() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return
            FadeInDown(
              delay: Duration(milliseconds: 500),
              child:
              Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        image: DecorationImage(
                            image: AssetImage("assets/images/bg_header_main.png"),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.2),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 4.0),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
        }
      },
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return Theme(
            data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange[100])),
            child: SmartRefresher(
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
                                child: null
                              ),
                            ),
                            PopupMenuButton<int>(
                              icon: Icon(Icons.more_vert, color: Colors.white),
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
                                            child:  Container(
                                              height: 190,
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
                                                    margin: EdgeInsets.only(top: 3, bottom: 15),
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
                                                              child: Text('Customer Service',
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
                                                              child: Text('Untuk menghubungi bagian IT anda akan terhubung melalui WhatsApp',
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                  fontFamily: AppTheme.fontName,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 16,
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
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(left: 20, right: 10),
                                                        width: MediaQuery.of(context).size.width*0.5,
                                                        child: GFButton(
                                                          color: Colors.grey,
                                                          textStyle: TextStyle(fontSize: 15),
                                                          onPressed: (){
                                                            Navigator.of(context, rootNavigator: true).pop('dialog');
                                                          },
                                                          text: "Batal",
                                                          blockButton: true,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(right: 20),
                                                        width: MediaQuery.of(context).size.width*0.5,
                                                        child: GFButton(
                                                          color: Colors.orange,
                                                          textStyle: TextStyle(fontSize: 15),
                                                          onPressed: () async {
                                                            Navigator.of(context, rootNavigator: true).pop('dialog');
                                                            await launch("https://wa.me/6285721603080?text=Hello");
                                                          },
                                                          text: "Hubungkan",
                                                          blockButton: true,
                                                        ),
                                                      ),
                                                    ],
                                                  )
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
                                            child:  Container(
                                              height: 260,
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
                                                    width: 70,
                                                    height: 3,
                                                    margin: EdgeInsets.only(top: 3, bottom: 15),
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
                                                        child: Text('Suma App merupakan platform aplikasi pembelajaran yang dibuat special untuk sahabat Suma di seluruh Indonesia. \n\nVersi yang saat ini kamu gunakan adalah v 1.1.8',
                                                          style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 16,
                                                            letterSpacing: 0.0,
                                                            color: AppTheme.grey.withOpacity(0.6)
                                                          )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 20, right: 20),
                                                    width: MediaQuery.of(context).size.width,
                                                    child: GFButton(
                                                      color: Colors.grey,
                                                      textStyle: TextStyle(fontSize: 15),
                                                      onPressed: (){
                                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                                      },
                                                      text: "Tutup",
                                                      blockButton: true,
                                                    ),
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
                            )
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
