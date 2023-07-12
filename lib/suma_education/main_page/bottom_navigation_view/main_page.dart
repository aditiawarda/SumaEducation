import 'dart:async';

import 'package:suma_education/suma_education/main_page/bottom_navigation_view/bottom_bar_view.dart';
import 'package:suma_education/suma_education/main_page/model/tabIcon_data.dart';
import 'package:suma_education/suma_education/main_page/screen/feed_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/home_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/login_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/product_screen.dart';
import 'package:suma_education/suma_education/main_page/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_theme/app_theme.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String boolLogin = "";

  Widget tabBody = Container(
    color: AppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = HomeScreen(animationController: animationController);

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
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

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        FutureBuilder<String>(
          future: getUser(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return
              BottomBarView(
                tabIconsList: tabIconsList,
                addClick: () {},
                changeIndex: (int index) {
                  if (index == 0) {
                    animationController?.reverse().then<dynamic>((data) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        tabBody =
                            HomeScreen(animationController: animationController);
                      });
                    });
                  } else if (index == 1) {
                    animationController?.reverse().then<dynamic>((data) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        tabBody =
                            FeedScreen(animationController: animationController);
                      });
                    });
                  } else if (index == 2) {
                    animationController?.reverse().then<dynamic>((data) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        tabBody = ProductScreen(animationController: animationController);
                      });
                    });
                  } else if (index == 3) {
                    animationController?.reverse().then<dynamic>((data) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        if(boolLogin=="true"){
                          tabBody = ProfileScreen(animationController: animationController);
                        } else {
                          tabBody = LoginScreen(animationController: animationController);
                        }
                      });
                    });
                  }
                },
              );
          },
        ),
      ],
    );
  }
}
