import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/main_page/ui_part/main_user_bio.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_list_data.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../main.dart';

SharedPreferences? prefs;

class ProposalListAllData extends StatefulWidget {
  const ProposalListAllData(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _ProposalListAllDataState createState() => _ProposalListAllDataState();
}

class _ProposalListAllDataState extends State<ProposalListAllData>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<ProposalData> proposalListData = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    getProposalAll();
    super.initState();
  }

  Future<String> getProposalAll() async {
    prefs = await _prefs;
    try {
      var response = await http.post(Uri.parse("https://proposal.sumasistem.co.id/api/proposal_all_list"),
          body: {
            "request": "request",
          });
      proposalListData = [];
      var dataAntrianProposal = json.decode(response.body);
      print(dataAntrianProposal);
      print(prefs!.getString("IdUser"));
      for (var i = 0; i < dataAntrianProposal['data'].length; i++) {
        var IdProposal = dataAntrianProposal['data'][i]['IdProposal'].toString();
        var IdUser = dataAntrianProposal['data'][i]['IdUser'].toString();
        var NoRegProp = dataAntrianProposal['data'][i]['NoRegProp'].toString();
        var JudulProposal = dataAntrianProposal['data'][i]['JudulProposal'].toString();
        var TglProposal = dataAntrianProposal['data'][i]['TglProposal'].toString();
        var StatusProposal = dataAntrianProposal['data'][i]['StatusProposal'].toString();
        var StatusRevisi = dataAntrianProposal['data'][i]['StatusRevisi'].toString();
        var PemberiRevisi = dataAntrianProposal['data'][i]['PemberiRevisi'].toString();

        proposalListData.add(ProposalData(IdProposal, IdUser, NoRegProp, JudulProposal, TglProposal.substring(8, 10)+'/'+TglProposal.substring(5, 7)+'/'+TglProposal.substring(0, 4), StatusProposal, StatusRevisi, PemberiRevisi));
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
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        child:
        Wrap(
          children: <Widget>[
            FutureBuilder<String>(
              future: getProposalAll(), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 10),
                      itemCount: proposalListData.length,
                      itemBuilder: (BuildContext context, int index) {
                        final int count = proposalListData.length;
                        final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                        animationController?.forward();
                        return itemProposalAll(proposalListData[index], context, animationController!, animation);
                      });
                } else {
                  if (snapshot.hasError)
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.55,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 10),
                        itemCount: proposalListData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = proposalListData.length;
                          final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                          animationController?.forward();
                          return itemProposalAll(proposalListData[index], context, animationController!, animation);
                        });
                  else
                    if(proposalListData.length==0)
                      return
                      FadeInUp(
                        delay: Duration(milliseconds: 500),
                        child: Container(
                          margin: EdgeInsets.only(top: 130, bottom: 100),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Image.asset("assets/images/empty_data.png", height: 100),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Data tidak tersedia',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                      color: Colors.blueGrey.shade200,
                                    ),
                                  ),
                                  Text(
                                    'Data proposal tidak tersedia',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      letterSpacing: 0.5,
                                      color: Colors.blueGrey.shade200,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    else
                      return
                        GridView.builder(
                          padding: EdgeInsets.only(bottom: 150),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.55,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 10),
                          itemCount: proposalListData.length,
                          itemBuilder: (BuildContext context, int index) {
                            final int count = proposalListData.length;
                            final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                            animationController?.forward();
                            return itemProposalAll(proposalListData[index], context, animationController!, animation);
                          });
                }
              },
            )
          ],
        ),
    );
  }
}

Widget itemProposalAll(ProposalData proposalListData, BuildContext context, AnimationController animationController, Animation<double> animation){
  return
    AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return
        FadeInUp(
          delay: Duration(milliseconds: 500),
          child: ZoomTapAnimation(
                onTap: () {
                  new Future.delayed(new Duration(milliseconds: 300), () {
                    Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => ProposalDetail(animationController: animationController, proposalId: proposalListData.IdProposal),
                        )
                    );
                  });
                },
                child: Stack(
                  children: [
                    if(proposalListData.StatusProposal=='3')...{ // Verifikasi Bu Deby (Diterima)
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32, left: 2, right: 2, bottom: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.3),
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 3.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: <HexColor>[
                                      HexColor("#24a831"),
                                      HexColor("#8adb92"),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 54, left: 16, right: 16, bottom: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        proposalListData.NoRegProp,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 0.2,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                    proposalListData.JudulProposal,
                                                    maxLines: 3, overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: 0.2,
                                                      color: AppTheme.white,
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            proposalListData.TglProposal.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              letterSpacing: 0.2,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: AppTheme.nearlyWhite.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 8,
                              child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child:
                                  Stack(
                                    children: [
                                      Image.asset('assets/suma_education/proposal.png'),
                                    ],
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 27,
                        right: 15,
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child:
                            Stack(
                              children: [
                                Image.asset('assets/suma_education/appointment_approved.png'),
                              ],
                            )
                        ),
                      ),
                    } else if(proposalListData.StatusProposal=='2')...{ // Verifikasi Bu There
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32, left: 2, right: 2, bottom: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.3),
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 3.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: <HexColor>[
                                      HexColor("#FA7D82"),
                                      HexColor("#FFB295"),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 54, left: 16, right: 16, bottom: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        proposalListData.NoRegProp,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 0.2,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                    proposalListData.JudulProposal,
                                                    maxLines: 3, overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: 0.2,
                                                      color: AppTheme.white,
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            proposalListData.TglProposal.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                              letterSpacing: 0.2,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: AppTheme.nearlyWhite.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 8,
                              child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child:
                                  Stack(
                                    children: [
                                      Image.asset('assets/suma_education/proposal.png'),
                                    ],
                                  )
                              ),
                            ),
                            if(prefs!.getString("IdUser")=="3")...{ // Bu Deby
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppTheme.nearlyWhite.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: RippleAnimation(
                                      repeat: true,
                                      color: Colors.white,
                                      minRadius: 20,
                                      ripplesCount: 6, child: null,
                                    )
                                ),
                              )
                            }
                          ],
                        ),
                      ),
                    } else if(proposalListData.StatusProposal=='1')...{ // Verifikasi Pak Dom
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32, left: 2, right: 2, bottom: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.3),
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 3.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: <HexColor>[
                                      HexColor("#bc83ef"),
                                      HexColor("#c1a5d9"),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 54, left: 16, right: 16, bottom: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        proposalListData.NoRegProp,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 0.2,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                    proposalListData.JudulProposal,
                                                    maxLines: 3, overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: 0.2,
                                                      color: AppTheme.white,
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            proposalListData.TglProposal.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              letterSpacing: 0.2,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: AppTheme.nearlyWhite.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 8,
                              child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child:
                                  Stack(
                                    children: [
                                      Image.asset('assets/suma_education/proposal.png'),
                                    ],
                                  )
                              ),
                            ),
                            if(prefs!.getString("IdUser")=="7")...{ // Bu There
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppTheme.nearlyWhite.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: RippleAnimation(
                                      repeat: true,
                                      color: Colors.white,
                                      minRadius: 20,
                                      ripplesCount: 6, child: null,
                                    )
                                ),
                              )
                            }
                          ],
                        ),
                      ),
                    } else if(proposalListData.StatusProposal=='0')...{ // Buka
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32, left: 2, right: 2, bottom: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.3),
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 3.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: <HexColor>[
                                      HexColor("#187cb4"),
                                      HexColor("#7cc5ee"),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 54, left: 16, right: 16, bottom: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        proposalListData.NoRegProp,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 0.2,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                    proposalListData.JudulProposal,
                                                    maxLines: 3, overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: 0.2,
                                                      color: AppTheme.white,
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            proposalListData.TglProposal.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              letterSpacing: 0.2,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: AppTheme.nearlyWhite.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 8,
                              child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child:
                                  Stack(
                                    children: [
                                      Image.asset('assets/suma_education/proposal.png'),
                                    ],
                                  )
                              ),
                            ),
                            if(prefs!.getString("IdUser")=="1414" || prefs!.getString("IdUser")=="1415")...{ // Bu Pak Dom
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppTheme.nearlyWhite.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: RippleAnimation(
                                      repeat: true,
                                      color: Colors.white,
                                      minRadius: 20,
                                      ripplesCount: 6, child: null,
                                    )
                                ),
                              )
                            }
                          ],
                        ),
                      ),
                    } else if(proposalListData.StatusProposal=='6')...{ // Revisi
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32, left: 2, right: 2, bottom: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.3),
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 3.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: <HexColor>[
                                      HexColor("#c5a427"),
                                      HexColor("#e7d388"),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 54, left: 16, right: 16, bottom: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        proposalListData.NoRegProp,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 0.2,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                    proposalListData.JudulProposal,
                                                    maxLines: 3, overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: 0.2,
                                                      color: AppTheme.white,
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            proposalListData.TglProposal.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                              letterSpacing: 0.2,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: AppTheme.nearlyWhite.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 8,
                              child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child:
                                  Stack(
                                    children: [
                                      Image.asset('assets/suma_education/proposal.png'),
                                    ],
                                  )
                              ),
                            ),
                            if(proposalListData.StatusRevisi=='1' && prefs!.getString("IdUser")==proposalListData.PemberiRevisi)...{
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: AppTheme.nearlyWhite.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: RippleAnimation(
                                        repeat: true,
                                        color: Colors.white,
                                        minRadius: 20,
                                        ripplesCount: 6, child: null,
                                      )
                                  ),
                                )
                            }
                          ],
                        ),
                      ),
                    } else if(proposalListData.StatusProposal=='5')...{ //Tolak
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32, left: 2, right: 2, bottom: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.3),
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 3.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: <HexColor>[
                                      HexColor("#827a78"),
                                      HexColor("#bab7b5"),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 54, left: 16, right: 16, bottom: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        proposalListData.NoRegProp,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 0.2,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                    proposalListData.JudulProposal,
                                                    maxLines: 3, overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: 0.2,
                                                      color: AppTheme.white,
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            proposalListData.TglProposal.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                              letterSpacing: 0.2,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: AppTheme.nearlyWhite.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 8,
                              child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child:
                                  Stack(
                                    children: [
                                      Image.asset('assets/suma_education/proposal_rejected.png'),
                                    ],
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 27,
                        right: 15,
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child:
                            Stack(
                              children: [
                                Image.asset('assets/suma_education/rejected.png'),
                              ],
                            )
                        ),
                      ),
                    }
                  ],
                )
            ),
        );
      },
    );
}
