// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:intl/intl.dart';
import 'package:suma_education/main.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_attacment_data.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_revision.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

SharedPreferences? prefs;

class ProposalAttachmentDownload extends StatefulWidget {
  const ProposalAttachmentDownload(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, this.idProposal})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? idProposal;

  @override
  _ProposalAttachmentDownloadState createState() => _ProposalAttachmentDownloadState();
}

class _ProposalAttachmentDownloadState extends State<ProposalAttachmentDownload>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<ProposalAttachment> proposalAttachment = [];

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<String> getUser() async {
    prefs = await _prefs;
    return 'true';
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Future <String>_getProposalAttachment() async {
    final SharedPreferences prefs = await _prefs;
    try {
      var response = await http.post(Uri.parse("https://proposal.sumasistem.co.id/api/proposal_queue"),
          body: {
            "id_user": prefs.getString("IdUser"),
          });
      proposalAttachment = [];
      var dataAntrianProposal = json.decode(response.body);
      print(dataAntrianProposal);
      for (var i = 0; i < dataAntrianProposal['data'].length; i++) {
        var IdFile = dataAntrianProposal['data'][i]['IdProposal'];
        var IdProposal = dataAntrianProposal['data'][i]['IdUser'];
        var NamaFile = dataAntrianProposal['data'][i]['NoRegProp'];
        var FileProposal = dataAntrianProposal['data'][i]['JudulProposal'];

        proposalAttachment.add(ProposalAttachment(IdFile, IdProposal, NamaFile, FileProposal));
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
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
            child: Container(
              width: double.infinity,
              child: Theme(
                data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange[100])),
                child:
                FutureBuilder<String>(
                  future: _getProposalAttachment(), // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, right: 16, left: 16),
                        itemCount: proposalAttachment.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = proposalAttachment.length;
                          final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                          animationController?.forward();

                          return itemAttachment(proposalAttachment[index], context, animationController!, animation);

                        },
                      );
                    } else {
                      if (snapshot.hasError)
                        return ListView.builder(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 0, right: 16, left: 16),
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

                            return itemAttachment(proposalAttachment[index], context, animationController!, animation);

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
                                            'Antrian proposal tidak tersedia',
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
                              top: 0, bottom: 0, right: 16, left: 16),
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

                            return itemAttachment(proposalAttachment[index], context, animationController!, animation);

                          },
                        ); // snapshot.data  :- get your object which is pass from your downloadData() function
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget itemAttachment(ProposalAttachment proposalAttachment, BuildContext context, AnimationController animationController, Animation<double> animation){
  return
    AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: ZoomTapAnimation(
              onTap: () {
                new Future.delayed(new Duration(milliseconds: 300), () {
                  // Navigator.push<dynamic>(
                  //     context,
                  //     MaterialPageRoute<dynamic>(
                  //       //builder: (BuildContext context) => ProposalDetail(animationController: animationController, proposalId: proposalListData.IdProposal, proposalStatus: proposalListData.StatusProposal, proposalUser: proposalListData.IdUser),
                  //       builder: (BuildContext context) => ProposalDetail(animationController: animationController, proposalId: proposalListData.IdProposal),
                  //     )
                  // );
                });
              },
              child: Transform(
                transform: Matrix4.translationValues(100 * (1.0 - animation.value), 0.0, 0.0),
                child:
                Text(
                  proposalAttachment.NamaFile,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.2,
                    color: AppTheme.white,
                  ),
                ),
              )
          ),
        );
      },
    );
}
