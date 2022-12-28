// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:suma_education/main.dart';
import 'package:suma_education/suma_education/main_page/bottom_navigation_view/main_page.dart';
import 'package:suma_education/suma_education/proposal_approver/ui_part/proposal_limit_layout.dart';
import 'package:suma_education/suma_education/proposal_approver/ui_part/proposal_list_all_data.dart';
import 'package:flutter/material.dart';
import 'package:suma_education/suma_education/proposal_approver/ui_part/proposal_note_color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme/app_theme.dart';

class ProposalAllList extends StatefulWidget {
  const ProposalAllList({Key? key, required this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _ProposalAllListState createState() => _ProposalAllListState();
}

class _ProposalAllListState extends State<ProposalAllList>
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
    const int count = 2; //Sesuaikan

    listViews.add(
      ProposalNoteColor(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      ProposalListAllData(
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
    final fullWidth = MediaQuery.of(context).size.width;
    final widthPart = fullWidth * 0.55;
    return Scaffold(
        backgroundColor: AppTheme.background,
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
                header: WaterDropHeader(),
                footer: null,
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child:
                  ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController,
                    padding: EdgeInsets.only(
                      bottom: 100 + MediaQuery.of(context).padding.bottom,
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
    return
      Column(
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
                    color: AppTheme.white.withOpacity(topBarOpacity),
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
                                  'List All Proposal',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
                                  Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) => MainPage(),
                                      )
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
                                                                child: Text('Tanya IT',
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
                                } else if (size==3) {
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
                                                    width: 80,
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
                                                        child: Text('Suma & Appointment merupakan aplikasi yang dikembangkan oleh Tim IT PT Gelora Aksara Pratama untuk mendukung proses bisnis perusahaan. \n\nVersi yang saat ini anda gunakan adalah v 1.0.8',
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
                                      Icon(Icons.home_outlined),
                                      SizedBox(
                                        // sized box with width 10
                                        width: 10,
                                      ),
                                      Text("Home")
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.headset_mic_outlined),
                                      SizedBox(
                                        // sized box with width 10
                                        width: 10,
                                      ),
                                      Text("Tanya IT")
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(Icons.phone_android_rounded),
                                      SizedBox(
                                        // sized box with width 10
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
