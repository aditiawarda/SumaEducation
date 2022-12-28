// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/proposal_approver/model/proposal_attacment_data.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_list_data.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../main.dart';

class ProposalListLampiran extends StatefulWidget {
  const ProposalListLampiran(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.idProposal, required this.statusProposal})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? idProposal;
  final String? statusProposal;

  @override
  _ProposalListLampiranState createState() => _ProposalListLampiranState();
}

class _ProposalListLampiranState extends State<ProposalListLampiran>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<ProposalAttachment> proposalAttachment = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    String? statusProposalCurrent = widget.statusProposal;
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    getProposalAttachment();
    getUser();
    super.initState();
  }

  Future<String> getProposalAttachment() async {
    try {
      var response = await http.post(Uri.parse("https://proposal.sumasistem.co.id/api/proposal_attachment"),
          body: {
            "id_proposal": widget.idProposal!,
          });
      proposalAttachment = [];
      var dataAttachment= json.decode(response.body);
      print(dataAttachment);
      for (var i = 0; i < dataAttachment['data'].length; i++) {
        var IdFile = dataAttachment['data'][i]['IdFile'];
        var IdProposal = dataAttachment['data'][i]['IdProposal'];
        var NamaFile = dataAttachment['data'][i]['NamaFile'];
        var FileProposal = dataAttachment['data'][i]['FileProposal'];

        proposalAttachment.add(ProposalAttachment(IdFile, IdProposal, NamaFile, FileProposal));
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  Future<String> getUser() async {
    prefs = await _prefs;
    return 'true';
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  child: Container(
                      padding: const EdgeInsets.only(right: 25, left: 27, top: 15),
                      child:  Text(
                        "Attachment :",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          letterSpacing: 0.5,
                          color: AppTheme.lightText.withOpacity(0.5),
                        ),
                      ),
                    ),
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  child: Theme(
                    data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange[100])),
                    child:
                    FutureBuilder<String>(
                      future: getProposalAttachment(), // function where you call your api
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 5, right: 16, left: 16),
                            itemCount: proposalAttachment.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              final int count = proposalAttachment.length;
                              final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                              animationController?.forward();

                              return itemLampiranProposal(proposalAttachment[index], context, animationController!, animation, widget.statusProposal.toString());

                            },
                          );
                        } else {
                          if (snapshot.hasError)
                            return ListView.builder(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 5, right: 16, left: 16),
                              itemCount: proposalAttachment.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                final int count = proposalAttachment.length;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval((1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn)));
                                animationController?.forward();

                                return itemLampiranProposal(proposalAttachment[index], context, animationController!, animation, widget.statusProposal.toString());

                              },
                            );
                          else
                          if (proposalAttachment.length==0)
                            return
                              FadeInUp(
                                delay: Duration(milliseconds: 300),
                                child: Container(
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
                                                'Data tidak tersedia',
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
                                                'Attachment tidak tersedia',
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
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 5, right: 16, left: 16),
                              itemCount: proposalAttachment.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                final int count = proposalAttachment.length;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval((1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn)));
                                animationController?.forward();

                                return itemLampiranProposal(proposalAttachment[index], context, animationController!, animation, widget.statusProposal.toString());

                              },
                            ); // snapshot.data  :- get your object which is pass from your downloadData() function
                        }
                      },
                    ),
                  ),
                ),
              ],
            )

          ),
        );
      },
    );
  }
}

Widget itemLampiranProposal(ProposalAttachment proposalAttachment, BuildContext context, AnimationController animationController, Animation<double> animation, String status){
  return
    AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: ZoomTapAnimation(
              onTap: () {
                new Future.delayed(new Duration(milliseconds: 1000), () async {
                  await launch("https://proposal.sumasistem.co.id/file_proposal/"+proposalAttachment.FileProposal);
                });
              },
            child: Transform(
              transform: Matrix4.translationValues(100 * (1.0 - animation.value), 0.0, 0.0),
              child: SizedBox(
                width: 150,
                child: Stack(
                  children: <Widget>[

                    if(status=='0')...{
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 8, right: 8, bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.2),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 5.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor("#FFFFFF"),
                                HexColor("#FFFFFF"),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                proposalAttachment.NamaFile,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Colors.blue.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 21,
                        left: 6,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 8,
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child:
                            Stack(
                              children: [
                                Image.asset('assets/suma_education/marking_0.png'),
                              ],
                            )
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 12,
                        child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: RippleAnimation(
                              repeat: true,
                              color: Colors.blue.withOpacity(0.2),
                              minRadius: 10,
                              ripplesCount: 2, child: null,
                            )
                        ),
                      ),
                    } else if(status=='1') ...{
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 8, right: 8, bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.2),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 5.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor("#FFFFFF"),
                                HexColor("#FFFFFF"),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                proposalAttachment.NamaFile,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Colors.purple.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 21,
                        left: 6,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 8,
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child:
                            Stack(
                              children: [
                                Image.asset('assets/suma_education/marking_1.png'),
                              ],
                            )
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 12,
                        child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: RippleAnimation(
                              repeat: true,
                              color: Colors.purple.withOpacity(0.2),
                              minRadius: 10,
                              ripplesCount: 2, child: null,
                            )
                        ),
                      ),
                    } else if(status=='2') ...{
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 8, right: 8, bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.2),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 5.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor("#FFFFFF"),
                                HexColor("#FFFFFF"),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                proposalAttachment.NamaFile,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Colors.deepOrange.shade300.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 18,
                        left: 6,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange.shade300.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 8,
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child:
                            Stack(
                              children: [
                                Image.asset('assets/suma_education/marking_2.png'),
                              ],
                            )
                        ),
                      ),
                      Positioned(
                        bottom: 21,
                        right: 12,
                        child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange.shade300.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: RippleAnimation(
                              repeat: true,
                              color: Colors.deepOrange.shade300.withOpacity(0.2),
                              minRadius: 10,
                              ripplesCount: 2, child: null,
                            )
                        ),
                      ),
                    } else if(status=='3') ...{
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 8, right: 8, bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.2),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 5.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor("#FFFFFF"),
                                HexColor("#FFFFFF"),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                proposalAttachment.NamaFile,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Colors.green.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 21,
                        left: 6,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 8,
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child:
                            Stack(
                              children: [
                                Image.asset('assets/suma_education/marking_3.png'),
                              ],
                            )
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 12,
                        child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: RippleAnimation(
                              repeat: true,
                              color: Colors.green.withOpacity(0.2),
                              minRadius: 10,
                              ripplesCount: 2, child: null,
                            )
                        ),
                      ),
                    } else if(status=='6') ...{
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 8, right: 8, bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.2),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 5.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor("#FFFFFF"),
                                HexColor("#FFFFFF"),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                proposalAttachment.NamaFile,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Colors.yellow.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 21,
                        left: 6,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade700.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 8,
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child:
                            Stack(
                              children: [
                                Image.asset('assets/suma_education/marking_6.png'),
                              ],
                            )
                        ),
                      ),
                      Positioned(
                        bottom: 21,
                        right: 12,
                        child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade700.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: RippleAnimation(
                              repeat: true,
                              color: Colors.yellow.shade700.withOpacity(0.2),
                              minRadius: 10,
                              ripplesCount: 2, child: null,
                            )
                        ),
                      ),
                    } else if(status=='5') ...{
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 8, right: 8, bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.2),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 5.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor("#FFFFFF"),
                                HexColor("#FFFFFF"),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                proposalAttachment.NamaFile,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Colors.grey.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 18,
                        left: 6,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppTheme.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 8,
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child:
                            Stack(
                              children: [
                                Image.asset('assets/suma_education/marking_rejected.png'),
                              ],
                            )
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 12,
                        child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: RippleAnimation(
                              repeat: true,
                              color: Colors.grey.withOpacity(0.2),
                              minRadius: 10,
                              ripplesCount: 2, child: null,
                            )
                        ),
                      ),
                    },

                  ],
                ),
              ),
            )
          ),
        );
      },
    );
}

