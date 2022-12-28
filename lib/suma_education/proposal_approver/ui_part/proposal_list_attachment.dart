// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/main_page/ui_part/main_user_bio.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_attacment_data.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_list_data.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../main.dart';

SharedPreferences? prefs;

class ProposalListAttachment extends StatefulWidget {
  const ProposalListAttachment(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.idProposal})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? idProposal;

  @override
  _ProposalListAttachmentState createState() => _ProposalListAttachmentState();
}

class _ProposalListAttachmentState extends State<ProposalListAttachment>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<ProposalAttachment> proposalAttachment = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
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

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding : EdgeInsets.only(left: 20, right: 20, bottom: 10) ,
        width: MediaQuery.of(context).size.width,
        child :
        Wrap(
          children: <Widget>[
            FutureBuilder<String>(
              future: getProposalAttachment(), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 7,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 10),
                      itemCount: proposalAttachment.length,
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
                      });
                } else {
                  if (snapshot.hasError)
                    return GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 7,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 10),
                        itemCount: proposalAttachment.length,
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
                        });
                  else
                    return GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 7,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 10),
                        itemCount: proposalAttachment.length,
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
                        });  // snapshot.data  :- get your object which is pass from your downloadData() function
                }
              },
            )
          ],
        ),
    );
  }
}

Widget itemAttachment(ProposalAttachment proposalAttachment, BuildContext context, AnimationController animationController, Animation<double> animation){
  return
    AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return
        FadeInRight(
          delay: Duration(milliseconds: 500),
          child: ZoomTapAnimation(
                onTap: () {
                  new Future.delayed(new Duration(milliseconds: 500), () async {
                    await launch("https://proposal.sumasistem.co.id/file_proposal/"+proposalAttachment.FileProposal);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4),
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0),
                    ],
                    gradient: LinearGradient(
                      colors: <HexColor>[
                        HexColor("#ffffff"),
                        HexColor("#fcecb5"),
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
                  child:
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 3),
                          child: Text(proposalAttachment.NamaFile,
                            style: TextStyle(
                              fontFamily:
                              AppTheme.fontName,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child:
                          ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                            child: SizedBox(
                              height: 52,
                              child: Image.asset(
                                  "assets/suma_education/see_detail.png"),
                            ),
                          ),
                        )
                      ],
                    )
                ),
            ),
        );
      },
    );
}
