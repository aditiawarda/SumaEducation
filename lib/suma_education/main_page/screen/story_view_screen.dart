import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/main_page/model/story_data.dart';
import 'package:suma_education/suma_education/main_page/model/story_viewer_data.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class StoryView extends StatefulWidget {
  final StoryData story;
  StoryView({Key? key, required this.story}) : super(key: key);

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> with TickerProviderStateMixin {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  double percent = 0.0;
  late Timer _timer;
  var tinggifix;
  var lebarfix;
  String viewer = "";

  String? idUser;
  String myReaction = "";
  List<StoryData> stories = [];
  List<StoryViewerData> viewer_stories = [];
  AnimationController? animationControllerBottomSheet;

  void startTimer(){
    _timer = Timer.periodic(Duration(microseconds: 10 * 1000), (timer) {
      setState((){
        percent += 0.001;
        if(percent > 1){
          _timer.cancel();
          Navigator.pop(context);
        }
      });
    });
  }

  void asViewer() async {
    final SharedPreferences prefs = await _prefs;
    idUser = prefs.getString("data_id")!;
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    try {
      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/view_stories"),
          body: {
            "id_content": widget.story.id,
            "id_user": idUser,
            "time": currentDate,
          });

      var json = jsonDecode(response.body);
      String status = json["status"];

      if (status == "Success") {
        setState(() {
          countViewer();
          getDataViewer();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error"),
      ));
    }
  }

  void countViewer() async {
    try {
      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/count_stories_viewer"),
          body: {
            "id_content": widget.story.id,
          });

      var json = jsonDecode(response.body);
      viewer = json["viewer"].toString();

    } catch (e) {
      print("Error");
    }
  }

  void _onVerticalSwipe(SwipeDirection direction) {
    setState(() {
      if (direction == SwipeDirection.up) {
        _timer.cancel();
        if(idUser == widget.story.idUser) {
          _viewerStories();
        } else {
          _reactionStories();
        }
      } else {
        startTimer();
      }
    });
  }

  void getDataViewer() async {
    try {
      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/viewer_of_stories"),
          body: {
            "id_content": widget.story.id,
          });

      setState(() {
        var dataViewer = json.decode(response.body);
        print(dataViewer);
        for (var i = 0; i < dataViewer['data'].length; i++) {
          var id_user = dataViewer['data'][i]['id_user'];
          var username = dataViewer['data'][i]['username'];
          var avatar = dataViewer['data'][i]['picture'];
          var time = dataViewer['data'][i]['timestamp_view'];
          var reaction = dataViewer['data'][i]['reaction'];
          viewer_stories.add(StoryViewerData(id_user, username, avatar, time, reaction));
        }
      });

    } catch (e) {
      print("Error");
    }
  }

  void checkReaction() async {
    try {
      final SharedPreferences prefs = await _prefs;
      String id_user = prefs.getString("id")!;

      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/check_reaction"),
          body: {
            "id_content": widget.story.id,
            "id_user": id_user,
          });

      var json = jsonDecode(response.body);
      myReaction = json['reaction'];
      print(myReaction);

    } catch (e) {
      print('Error');
    }
  }

  void givingReaction(String reaction) async {
    try {
      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/giving_reaction"),
          body: {
            "id_content": widget.story.id,
            "id_user": idUser,
            "reaction": reaction,
          });

      var json = jsonDecode(response.body);
      String status = json["status"];
      String message = json["message"];

      if (status == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
        setState(() {
          checkReaction();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }

    } catch (e) {
      print("Error");
    }
  }

  void removeStories() async {
    try {
      var response = await http.post(
          Uri.parse("https://suma.geloraaksara.co.id/api/remove_stories"),
          body: {
            "id_content": widget.story.id,
          });

      var json = jsonDecode(response.body);
      String status = json["status"];
      String message = json["message"];

      if (status == "Success") {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }

    } catch (e) {
      print("Error");
    }
  }

  @override
  void initState(){
    animationControllerBottomSheet = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _getuser();
    startTimer();
    asViewer();
    countViewer();
    getDataViewer();
    checkReaction();
    super.initState();
  }

  Future<String> _getuser() async{
    final SharedPreferences prefs = await _prefs;
    idUser = prefs.getString("data_id")!;
    return Future.value("Data download successfully");
  }

  Future _viewerStories(){
    return
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
                      listViewer(tinggifix)
                    ],
                  ),
                ),
              );
          }
      ).whenComplete(() {
        startTimer();
      });
  }

  Future _reactionStories(){
    return
      showBarModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.width/4,
              width: double.infinity,
              child:
              Container(
                child:
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 90,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/5,
                          child:
                          ZoomTapAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  new Future.delayed(new Duration(milliseconds: 300), () {
                                    givingReaction("1");
                                    Navigator.pop(context);
                                  });
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:<Widget> [
                                      if(myReaction=="1")...[
                                        CircleAvatar(
                                          radius: 28.0,
                                          backgroundColor: Colors.orange,
                                          child:  CircleAvatar(
                                            radius: 25.0,
                                            backgroundColor: Colors.white,
                                            child:CircleAvatar(
                                              child:  Tab(icon: Image.asset("assets/images/love2.png", scale: 12)),
                                            ),
                                          ),
                                        )
                                      ] else ...[
                                        Container(
                                          width: double.infinity,
                                          child:
                                          Tab(icon: Image.asset("assets/images/love2.png")),
                                        )
                                      ]
                                    ]
                                  )
                              )
                          )
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width/5,
                          child: ZoomTapAnimation(
                            child: GestureDetector(
                              onTap: () {
                                new Future.delayed(new Duration(milliseconds: 300), () {
                                  givingReaction("2");
                                  Navigator.pop(context);
                                });
                              },
                              child:  Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:<Widget> [
                                    if(myReaction=="2")...[
                                      CircleAvatar(
                                        radius: 28.0,
                                        backgroundColor: Colors.orange,
                                        child:  CircleAvatar(
                                          radius: 25.0,
                                          backgroundColor: Colors.white,
                                          child:CircleAvatar(
                                            child:  Tab(icon: Image.asset("assets/images/haha2.png", scale: 12)),
                                          ),
                                        ),
                                      )
                                    ] else ...[
                                      Container(
                                        width: double.infinity,
                                        child:
                                        Tab(icon: Image.asset("assets/images/haha2.png")),
                                      )
                                    ]
                                  ],
                                )
                              ),
                            )
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width/5,
                          child: ZoomTapAnimation(
                            child: GestureDetector(
                              onTap: () {
                                new Future.delayed(new Duration(milliseconds: 300), () {
                                  givingReaction("3");
                                  Navigator.pop(context);
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:<Widget> [
                                  if(myReaction=="3")...[
                                    CircleAvatar(
                                      radius: 28.0,
                                      backgroundColor: Colors.orange,
                                      child:  CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Colors.white,
                                        child:CircleAvatar(
                                          child:  Tab(icon: Image.asset("assets/images/wow2.png", scale: 12)),
                                        ),
                                      ),
                                    )
                                  ] else ...[
                                    Container(
                                      width: double.infinity,
                                      child:
                                      Tab(icon: Image.asset("assets/images/wow2.png")),
                                    )
                                  ]
                                ]
                              )
                            )
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width/5,
                          child: ZoomTapAnimation(
                            child: GestureDetector(
                              onTap: () {
                                new Future.delayed(new Duration(milliseconds: 300), () {
                                  givingReaction("4");
                                  Navigator.pop(context);
                                });
                              },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:<Widget> [
                                      if(myReaction=="4")...[
                                        CircleAvatar(
                                          radius: 28.0,
                                          backgroundColor: Colors.orange,
                                          child:  CircleAvatar(
                                            radius: 25.0,
                                            backgroundColor: Colors.white,
                                            child:CircleAvatar(
                                              child:  Tab(icon: Image.asset("assets/images/sad2.png", scale: 12)),
                                            ),
                                          ),
                                        )
                                      ] else ...[
                                        Container(
                                          width: double.infinity,
                                          child:
                                          Tab(icon: Image.asset("assets/images/sad2.png")),
                                        )
                                      ]
                                    ]
                                )
                            )
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width/5,
                          child: ZoomTapAnimation(
                            child: GestureDetector(
                              onTap: () {
                                new Future.delayed(new Duration(milliseconds: 300), () {
                                  givingReaction("5");
                                  Navigator.pop(context);
                                });
                              },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:<Widget> [
                                      if(myReaction=="5")...[
                                        CircleAvatar(
                                          radius: 28.0,
                                          backgroundColor: Colors.orange,
                                          child:  CircleAvatar(
                                            radius: 25.0,
                                            backgroundColor: Colors.white,
                                            child:CircleAvatar(
                                              child:  Tab(icon: Image.asset("assets/images/angry2.png", scale: 12)),
                                            ),
                                          ),
                                        )
                                      ] else ...[
                                        Container(
                                          width: double.infinity,
                                          child:
                                          Tab(icon: Image.asset("assets/images/angry2.png")),
                                        )
                                      ]
                                    ]
                                )
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                )
              )
            ),
          ),
        ),
      ).whenComplete(() {
        startTimer();
      });
  }

  Widget listViewer(var tinggi){
    return Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemCount: viewer_stories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                        itemListViewer(viewer_stories[index], context);
                    }
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
            )
          ],
        )
    );
  }

  Widget itemListViewer(StoryViewerData viewer_stories, BuildContext context){
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd').format(now);
    return Container(
      width: lebarfix,
      height: tinggifix/10,
      child: Stack(
       children: [
         Row(
           children: [
             CircleAvatar(
               radius: 22.0,
               backgroundColor: Colors.white,
               child:CircleAvatar(
                 backgroundColor: Colors.orange,
                 backgroundImage:NetworkImage(viewer_stories.avatarUrl),
                 radius: 21.0,
               ),
             ),
             SizedBox(width: 8),
             Container(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(viewer_stories.userName,
                     maxLines: 5,
                     style: GoogleFonts.roboto(
                         fontSize: 15,
                         fontWeight: FontWeight.bold
                     ),
                   ),

                   if(viewer_stories.time.substring(0,10)==currentDate)...{
                     Text('Hari ini '+viewer_stories.time.substring(11,16),
                       style: TextStyle(
                           fontSize: 14, color: Colors.black
                       ),
                     ),
                   } else ...{
                     Text('Kemarin '+viewer_stories.time.substring(11,16),
                       style: TextStyle(
                           fontSize: 14, color: Colors.black
                       ),
                     ),
                   },

                 ],
               ),
             )
           ],
         ),
         Align(
           alignment: Alignment.centerRight,
           child: Container(
              margin: EdgeInsets.only(right: 5),
              child: Column(
                children:<Widget> [
                  if(viewer_stories.reaction=="1")...[
                    Tab(icon: Image.asset("assets/images/love2.png", scale: 13.5))
                  ] else if(viewer_stories.reaction=="2")...[
                    Tab(icon: Image.asset("assets/images/haha2.png", scale: 13.5))
                  ] else if(viewer_stories.reaction=="3")...[
                    Tab(icon: Image.asset("assets/images/wow2.png", scale: 13.5))
                  ] else if(viewer_stories.reaction=="4")...[
                    Tab(icon: Image.asset("assets/images/sad2.png", scale: 13.5))
                  ] else if(viewer_stories.reaction=="5")...[
                    Tab(icon: Image.asset("assets/images/angry2.png", scale: 13.5))
                  ]
                ],
              )
            )
         )
       ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd').format(now);
    print(currentDate);

    var size = MediaQuery.of(context).size;
    tinggifix = size.height/1.5;
    lebarfix = size.width;
    return Scaffold(
      body: Stack (
        children: <Widget> [
          if (idUser == widget.story.idUser) ...[
            GestureDetector(
              onTapDown: (details) => _timer.cancel(),
              onTapUp: (details) =>  startTimer(),
              child:
              SimpleGestureDetector(
                onVerticalSwipe: _onVerticalSwipe,
                swipeConfig: SimpleSwipeConfig(
                  verticalThreshold: 40.0,
                  horizontalThreshold: 40.0,
                  swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
                ),
                child:  Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(widget.story.storyUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ] else ...[
            GestureDetector(
              onTapDown: (details) => _timer.cancel(),
              onTapUp: (details) =>  startTimer(),
              child:
              SimpleGestureDetector(
                onVerticalSwipe: _onVerticalSwipe,
                swipeConfig: SimpleSwipeConfig(
                  verticalThreshold: 40.0,
                  horizontalThreshold: 40.0,
                  swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
                ),
                child:  Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(widget.story.storyUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 12),
                  height: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: percent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.withOpacity(0.8)),
                      backgroundColor: Color(0xffD6D6D6).withOpacity(0.5),
                    ),
                  ),
                ),
                SizedBox(height: 1.0),
                Stack(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.orange,
                              backgroundImage: NetworkImage(widget.story.avatarUrl),
                              radius: 19.0,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.story.userName,
                                style: TextStyle(
                                  color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.7),
                                      offset: const Offset(0.3, 0.3),
                                      blurRadius: 5
                                    ),
                                  ]
                                ),
                              ),

                              if(widget.story.time.substring(0,10)==currentDate)...{
                                Text('Hari ini '+widget.story.time.substring(11,16),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black.withOpacity(0.7),
                                            offset: const Offset(0.3, 0.3),
                                            blurRadius: 5
                                        ),
                                      ]
                                  ),
                                ),
                              } else ...{
                                Text('Kemarin '+widget.story.time.substring(11,16),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black.withOpacity(0.7),
                                            offset: const Offset(0.3, 0.3),
                                            blurRadius: 5
                                        ),
                                      ]
                                  ),
                                ),
                              },

                            ],
                          )
                        ],
                      )
                    ),
                    if (idUser == widget.story.idUser) ...[
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 5),
                            child: ZoomTapAnimation(
                                child: GestureDetector(
                                    onTap: () {
                                      removeStories();
                                    },
                                    child:
                                    CircleAvatar(
                                        radius: 15.0,
                                        backgroundColor: Colors.black.withOpacity(0.3),
                                        child:
                                        Icon(Icons.delete, size: 23, color: Colors.white)
                                    ),
                                )
                            )
                        ),
                      )
                    ]
                  ],
                )
              ],
            ),
          ),
          if (idUser == widget.story.idUser) ...[
            Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(widget.story.deskripsi!=null)...{
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 15,top: 15),
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.5),
                            child: Text(widget.story.deskripsi,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        },
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: 10,top: 10),
                          width: double.infinity,
                          //color: Colors.black.withOpacity(0.5),
                          child: Row(
                            children: [
                              ZoomTapAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      new Future.delayed(new Duration(milliseconds: 300), () {
                                        _timer.cancel();
                                        _viewerStories();
                                      });// print();
                                    },
                                    child:
                                    Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Card(
                                                color: Colors.orange.withOpacity(0.8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                ),
                                                child:
                                                Container(
                                                  padding: EdgeInsets.only(right: 13, left: 13, top: 3, bottom: 5),
                                                  child:  Wrap(
                                                    children: [
                                                      Container(
                                                        height: 20,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(bottom: 1,top: 2),
                                                        child: Text(viewer,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Container(
                                                        height: 20,
                                                        padding: EdgeInsets.only(bottom: 1,top: 2),
                                                        alignment: Alignment.center,
                                                        child: Icon(FontAwesomeIcons.eye,color: Colors.white, size: 15),
                                                      )
                                                    ],
                                                  ),
                                                )
                                            )
                                          ],
                                        )
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                )
            )
          ] else ...[
            Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if(widget.story.deskripsi!=null)...{
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: 15,top: 15),
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.5),
                          child: Text(widget.story.deskripsi,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      },
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 10,top: 10),
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.5),
                        child: Row(
                          children: [
                            ZoomTapAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    new Future.delayed(new Duration(milliseconds: 300), () {
                                      _timer.cancel();
                                      _reactionStories();
                                    });// print();
                                  },
                                  child:
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Card(
                                              color: Colors.orange,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.0),
                                              ),
                                              child:
                                              Container(
                                                padding: EdgeInsets.only(right: 10, left: 13, top: 3, bottom: 5),
                                                child:  Wrap(
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      alignment: Alignment.center,
                                                      child: Text('Reaction',
                                                        style: TextStyle(
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Container(
                                                      height: 20,
                                                      padding: EdgeInsets.only(bottom: 2),
                                                      alignment: Alignment.center,
                                                      child: Icon(FontAwesomeIcons.angleUp,color: Colors.white, size: 17),
                                                    )
                                                  ],
                                                ),
                                              )
                                          )
                                        ],
                                      )
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            )
          ]
        ],
      )
    );
  }

}
