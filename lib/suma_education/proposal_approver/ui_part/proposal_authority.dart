// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:intl/intl.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_revision.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

SharedPreferences? prefs;

class ProposalAuthority extends StatefulWidget {
  const ProposalAuthority(
      {Key? key,
        this.mainScreenAnimationController,
        this.mainScreenAnimation,
        this.IdProposal,
        this.StatusProposal,
        this.ProposalUser,
        this.IdUserInput,
        this.NoReg,
        this.NoProposal,
        this.StatusRevisi,
        this.PemberiRevisi,
        this.CatatanRevisi,
        this.TotalSP
      })
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? IdProposal;
  final String? StatusProposal;
  final String? ProposalUser;
  final String? IdUserInput;
  final String? NoReg;
  final String? NoProposal;
  final String? StatusRevisi;
  final String? PemberiRevisi;
  final String? CatatanRevisi;
  final String? TotalSP;

  @override
  _ProposalAuthorityState createState() => _ProposalAuthorityState();
}

class _ProposalAuthorityState extends State<ProposalAuthority>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    getUser();
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  void action(String statusUpdate) async {
    prefs = await _prefs;
    try {
      var response = await http.post(
          Uri.parse("https://proposal.sumasistem.co.id/api/proposal_approval"),
          body: {
            "id_proposal": widget.IdProposal!,
            "status": statusUpdate,
            "id_user": prefs!.getString("IdUser"),
          });
      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        if(statusUpdate == "3") {
          await Future.delayed(Duration(milliseconds: 500));
          await CoolAlert.show(
              context: context,
              borderRadius: 25,
              type: CoolAlertType.success,
              backgroundColor: Colors.lightGreen.shade50,
              title: 'Diterima!',
              text: "Proposal berhasil diterima",
              confirmBtnText: 'OK',
              width: 30,
              loopAnimation: true,
              animType: CoolAlertAnimType.scale,
              confirmBtnColor: Colors.green.shade300,
              onConfirmBtnTap: (){
                setState(() {
                  new Future.delayed(new Duration(milliseconds: 500), () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProposalDetail(animationController: widget.mainScreenAnimationController, proposalId: widget.IdProposal),
                        )
                    );
                  });
                });
                Navigator.of(context, rootNavigator: true).pop('dialog');
              }
          );
        } else if(statusUpdate == "2") {
          await Future.delayed(Duration(milliseconds: 500));
          await CoolAlert.show(
              context: context,
              borderRadius: 25,
              type: CoolAlertType.success,
              backgroundColor: Colors.lightGreen.shade50,
              title: 'Diterima!',
              text: "Proposal berhasil diterima",
              confirmBtnText: 'OK',
              width: 30,
              loopAnimation: true,
              animType: CoolAlertAnimType.scale,
              confirmBtnColor: Colors.green.shade300,
              onConfirmBtnTap: (){
                setState(() {
                  new Future.delayed(new Duration(milliseconds: 500), () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProposalDetail(animationController: widget.mainScreenAnimationController, proposalId: widget.IdProposal),
                        )
                    );
                  });
                });
                Navigator.of(context, rootNavigator: true).pop('dialog');
              }
          );
        } else if(statusUpdate == "1") {
          await Future.delayed(Duration(milliseconds: 500));
          await CoolAlert.show(
              context: context,
              borderRadius: 25,
              type: CoolAlertType.success,
              backgroundColor: Colors.lightGreen.shade50,
              title: 'Diterima!',
              text: "Proposal berhasil diterima",
              confirmBtnText: 'OK',
              width: 30,
              loopAnimation: true,
              animType: CoolAlertAnimType.scale,
              confirmBtnColor: Colors.green.shade300,
              onConfirmBtnTap: (){
                setState(() {
                  new Future.delayed(new Duration(milliseconds: 500), () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProposalDetail(animationController: widget.mainScreenAnimationController, proposalId: widget.IdProposal),
                        )
                    );
                  });
                });
                Navigator.of(context, rootNavigator: true).pop('dialog');
              }
          );
        } else if(statusUpdate == "5") {
          await Future.delayed(Duration(milliseconds: 500));
          await CoolAlert.show(
              context: context,
              borderRadius: 25,
              type: CoolAlertType.success,
              backgroundColor: Colors.lightGreen.shade50,
              title: 'Ditolak!',
              text: "Proposal berhasil ditolak",
              confirmBtnText: 'OK',
              width: 30,
              loopAnimation: true,
              animType: CoolAlertAnimType.scale,
              confirmBtnColor: Colors.green.shade300,
              onConfirmBtnTap: (){
                setState(() {
                  new Future.delayed(new Duration(milliseconds: 500), () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProposalDetail(animationController: widget.mainScreenAnimationController, proposalId: widget.IdProposal),
                        )
                    );
                  });
                });
                Navigator.of(context, rootNavigator: true).pop('dialog');
              }
          );
        }
      } else {
        await Future.delayed(Duration(milliseconds: 500));
        await CoolAlert.show(
          context: context,
          borderRadius: 25,
          type: CoolAlertType.error,
          backgroundColor: Colors.red.shade50,
          title: 'Oops...',
          text: "Terjadi kesalahan",
          confirmBtnText: 'OK',
          width: 30,
          loopAnimation: true,
          animType: CoolAlertAnimType.scale,
          confirmBtnColor: Colors.red.shade300,
        );
      }
    } catch (e) {
        await Future.delayed(Duration(milliseconds: 500));
        await CoolAlert.show(
          context: context,
          borderRadius: 25,
          type: CoolAlertType.error,
          backgroundColor: Colors.red.shade50,
          title: 'Oops...',
          text: "Terjadi kesalahan",
          confirmBtnText: 'OK',
          width: 30,
          loopAnimation: true,
          animType: CoolAlertAnimType.scale,
          confirmBtnColor: Colors.red.shade300,
        );
    }
  }

  Future<String> getUser() async {
    prefs = await _prefs;
    print(prefs!.getString('IdUser'));
    return 'true';
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void actionApproval(String key) {
    if(key=="tolak"){
      CoolAlert.show(
          context: context,
          title: 'Perhatian',
          backgroundColor: Colors.lightBlue.shade50,
          borderRadius: 25,
          type: CoolAlertType.confirm,
          text: 'Apakah anda yakin untuk tolak proposal?',
          confirmBtnText: 'OK',
          cancelBtnText: 'Batal',
          animType: CoolAlertAnimType.scale,
          width: 30,
          loopAnimation: true,
          confirmBtnColor: Colors.red.shade300,
          onConfirmBtnTap: (){
            Navigator.of(context, rootNavigator: true).pop('dialog');
            action('5');
          }
      );
    } else if(key=="revisi"){
      CoolAlert.show(
          context: context,
          title: 'Perhatian',
          backgroundColor: Colors.lightBlue.shade50,
          borderRadius: 25,
          type: CoolAlertType.confirm,
          text: 'Apakah anda yakin untuk revisi proposal?',
          confirmBtnText: 'OK',
          cancelBtnText: 'Batal',
          animType: CoolAlertAnimType.scale,
          width: 30,
          loopAnimation: true,
          confirmBtnColor: Colors.orange.shade300,
          onConfirmBtnTap: (){
            Navigator.of(context, rootNavigator: true).pop('dialog');
            setState(() {
              new Future.delayed(new Duration(milliseconds: 500), () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProposalRevision(animationController: widget.mainScreenAnimationController, proposalId: widget.IdProposal, idPemohon: widget.IdUserInput, noProposal: widget.NoProposal, noReg: widget.NoReg),
                    )
                );
              });
            });
          }
      );
    } else if(key=="terima"){
      CoolAlert.show(
          context: context,
          title: 'Perhatian',
          backgroundColor: Colors.lightBlue.shade50,
          borderRadius: 25,
          type: CoolAlertType.confirm,
          text: 'Apakah anda yakin untuk terima proposal?',
          confirmBtnText: 'OK',
          cancelBtnText: 'Batal',
          animType: CoolAlertAnimType.scale,
          width: 30,
          loopAnimation: true,
          confirmBtnColor: Colors.green.shade300,
          onConfirmBtnTap: (){
            Navigator.of(context, rootNavigator: true).pop('dialog');
            if(prefs!.getString("IdUser")=="3") {
              action('3');
            } else if(prefs!.getString("IdUser")=="7"){
              // if(int.parse(widget.StatusProposal!)<50000000){
              //   action('3');
              // } else if(int.parse(widget.StatusProposal!)>=50000000){
                action('2');
              // }
            } else if(prefs!.getString("IdUser")=="1414" || prefs!.getString("IdUser")=="1415"){
              action('1');
            }
          }
      );
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    final widthButton = fullWidth * 0.5 / 2.7;
    return
      AnimatedBuilder(
        animation: widget.mainScreenAnimationController!,
        builder: (BuildContext context, Widget? child) {
          return
            FadeInUp(
               delay: Duration(milliseconds: 500),
               child: FadeTransition(
                  opacity: widget.mainScreenAnimation!,
                  child: new Transform(
                    transform: new Matrix4.translationValues(
                        0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 0, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.grey.withOpacity(0.3),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 3.0),
                          ],
                        ),
                        child: FutureBuilder<String>(
                          future: getUser(),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(width: double.infinity);
                            } else {
                              if (snapshot.hasError)
                                return SizedBox(width: double.infinity);
                              else
                                return Column(
                                  children: <Widget>[
                                    if(prefs!.getString("IdUser")=="3" && widget.StatusProposal=="2")...{
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 16, left: 16, right: 24),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 4, bottom: 3),
                                                    child: Text(
                                                      'Persetujuan :',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15,
                                                          color: Colors.grey
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.access_time,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                        size: 16,
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(left: 4.0),
                                                        child:
                                                        StreamBuilder(
                                                            stream: Stream.periodic(const Duration(seconds: 1)),
                                                            builder: (context, snapshot) {
                                                              return Text(
                                                                "Hari ini, "+DateFormat('kk:mm').format(DateTime.now())+" "+DateTime.now().timeZoneName.toString(),
                                                                textAlign: TextAlign.right,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    AppTheme.fontName,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 14,
                                                                    letterSpacing: 0.0,
                                                                    color: AppTheme.grey
                                                                        .withOpacity(0.5)),
                                                              );
                                                            }
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24, top: 8, bottom: 8),
                                        child: Container(
                                          height: 2,
                                          decoration: BoxDecoration(
                                            color: AppTheme.background,
                                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24, top: 3, bottom: 16),
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: widthButton,
                                              height: 50,
                                              child: GFButton(
                                                color: Colors.red,
                                                textStyle: TextStyle(fontSize: 15),
                                                onPressed: (){
                                                  actionApproval("tolak");
                                                },
                                                text: "Tolak",
                                                blockButton: true,
                                              ),
                                            ),
                                            SizedBox(
                                              width: widthButton,
                                              height: 50,
                                              child: GFButton(
                                                color: Colors.orange,
                                                textStyle: TextStyle(fontSize: 15),
                                                onPressed: (){
                                                  actionApproval("revisi");
                                                },
                                                text: "Revisi",
                                                blockButton: true,
                                              ),
                                            ),
                                            SizedBox(
                                              width: widthButton,
                                              height: 50,
                                              child: GFButton(
                                                color: Colors.green,
                                                textStyle: TextStyle(fontSize: 15),
                                                onPressed: (){
                                                  actionApproval("terima");
                                                },
                                                text: "Terima",
                                                blockButton: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    } else if(prefs!.getString("IdUser")=="7" && widget.StatusProposal=="1")...{
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 16, left: 16, right: 24),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 4, bottom: 3),
                                                    child: Text(
                                                      'Persetujuan :',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15,
                                                          color: Colors.grey
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.access_time,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                        size: 16,
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(left: 4.0),
                                                        child:
                                                        StreamBuilder(
                                                            stream: Stream.periodic(const Duration(seconds: 1)),
                                                            builder: (context, snapshot) {
                                                              return Text(
                                                                "Hari ini, "+DateFormat('kk:mm').format(DateTime.now())+" "+DateTime.now().timeZoneName.toString(),
                                                                textAlign: TextAlign.right,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    AppTheme.fontName,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 14,
                                                                    letterSpacing: 0.0,
                                                                    color: AppTheme.grey
                                                                        .withOpacity(0.5)),
                                                              );
                                                            }
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24, top: 8, bottom: 8),
                                        child: Container(
                                          height: 2,
                                          decoration: BoxDecoration(
                                            color: AppTheme.background,
                                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24, top: 3, bottom: 16),
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: widthButton,
                                              height: 50,
                                              child: GFButton(
                                                color: Colors.red,
                                                textStyle: TextStyle(fontSize: 15),
                                                onPressed: (){
                                                  actionApproval("tolak");
                                                },
                                                text: "Tolak",
                                                blockButton: true,
                                              ),
                                            ),
                                            SizedBox(
                                              width: widthButton,
                                              height: 50,
                                              child: GFButton(
                                                color: Colors.orange,
                                                textStyle: TextStyle(fontSize: 15),
                                                onPressed: (){
                                                  actionApproval("revisi");
                                                },
                                                text: "Revisi",
                                                blockButton: true,
                                              ),
                                            ),
                                            SizedBox(
                                              width: widthButton,
                                              height: 50,
                                              child: GFButton(
                                                color: Colors.green,
                                                textStyle: TextStyle(fontSize: 15),
                                                onPressed: (){
                                                  actionApproval("terima");
                                                },
                                                text: "Terima",
                                                blockButton: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    } else if((prefs!.getString("IdUser")=="1414" || prefs!.getString("IdUser")=="1415") && widget.StatusProposal=="0")...{
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 16, left: 16, right: 24),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 4, bottom: 3),
                                                    child: Text(
                                                      'Persetujuan :',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: AppTheme.fontName,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15,
                                                          color: Colors.grey
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.access_time,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                        size: 16,
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(left: 4.0),
                                                        child:
                                                        StreamBuilder(
                                                            stream: Stream.periodic(const Duration(seconds: 1)),
                                                            builder: (context, snapshot) {
                                                              return Text(
                                                                "Hari ini, "+DateFormat('kk:mm').format(DateTime.now())+" "+DateTime.now().timeZoneName.toString(),
                                                                textAlign: TextAlign.right,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    AppTheme.fontName,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 14,
                                                                    letterSpacing: 0.0,
                                                                    color: AppTheme.grey
                                                                        .withOpacity(0.5)),
                                                              );
                                                            }
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24, top: 8, bottom: 8),
                                        child: Container(
                                          height: 2,
                                          decoration: BoxDecoration(
                                            color: AppTheme.background,
                                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24, top: 3, bottom: 16),
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: widthButton,
                                              height: 50,
                                              child: GFButton(
                                                color: Colors.red,
                                                textStyle: TextStyle(fontSize: 15),
                                                onPressed: (){
                                                  actionApproval("tolak");
                                                },
                                                text: "Tolak",
                                                blockButton: true,
                                              ),
                                            ),
                                            SizedBox(
                                              width: widthButton,
                                              height: 50,
                                              child: GFButton(
                                                color: Colors.orange,
                                                textStyle: TextStyle(fontSize: 15),
                                                onPressed: (){
                                                  actionApproval("revisi");
                                                },
                                                text: "Revisi",
                                                blockButton: true,
                                              ),
                                            ),
                                            SizedBox(
                                              width: widthButton,
                                              height: 50,
                                              child: GFButton(
                                                color: Colors.green,
                                                textStyle: TextStyle(fontSize: 15),
                                                onPressed: (){
                                                  actionApproval("terima");
                                                },
                                                text: "Terima",
                                                blockButton: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    } else ...{
                                      if(widget.StatusProposal=="0")...{
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                      child: Text(
                                                        'Menunggu persetujuan Bapak Asrel Marpaung',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 15,
                                                            color: Colors.blue.shade300
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      } else if(widget.StatusProposal=="1")...{
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                      child: Text(
                                                        'Menunggu persetujuan Ibu Theresia Tunjung',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 15,
                                                            color: Colors.purple.shade300
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      } else if(widget.StatusProposal=="2")...{
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                      child: Text(
                                                        'Menunggu persetujuan Ibu Deborah Hutauruk',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 15,
                                                            color: Colors.deepOrange.shade300
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      } else if(widget.StatusProposal=="3")...{
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                      child: Text(
                                                        'Proposal Diterima',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 15,
                                                            color: Colors.green.shade300
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      } else if(widget.StatusProposal=="5")...{
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                      child: Text(
                                                        'Proposal Ditolak',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 15,
                                                            color: Colors.grey
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      } else if(widget.StatusProposal=="6")...{
                                        if(widget.StatusRevisi=='1' && widget.PemberiRevisi==prefs!.getString("IdUser"))...{
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 16, left: 16, right: 24),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 4, bottom: 3),
                                                        child: Text(
                                                          'Persetujuan :',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily: AppTheme.fontName,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 15,
                                                              color: Colors.grey
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.access_time,
                                                            color: AppTheme.grey
                                                                .withOpacity(0.5),
                                                            size: 16,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(left: 4.0),
                                                            child:
                                                            StreamBuilder(
                                                                stream: Stream.periodic(const Duration(seconds: 1)),
                                                                builder: (context, snapshot) {
                                                                  return Text(
                                                                    "Hari ini, "+DateFormat('kk:mm').format(DateTime.now())+" "+DateTime.now().timeZoneName.toString(),
                                                                    textAlign: TextAlign.right,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                        AppTheme.fontName,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 14,
                                                                        letterSpacing: 0.0,
                                                                        color: AppTheme.grey
                                                                            .withOpacity(0.5)),
                                                                  );
                                                                }
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24, right: 24, top: 8, bottom: 8),
                                            child: Container(
                                              height: 2,
                                              decoration: BoxDecoration(
                                                color: AppTheme.background,
                                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24, right: 24, top: 3, bottom: 16),
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: widthButton,
                                                  height: 50,
                                                  child: GFButton(
                                                    color: Colors.red,
                                                    textStyle: TextStyle(fontSize: 15),
                                                    onPressed: (){
                                                      actionApproval("tolak");
                                                    },
                                                    text: "Tolak",
                                                    blockButton: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: widthButton,
                                                  height: 50,
                                                  child: GFButton(
                                                    color: Colors.orange,
                                                    textStyle: TextStyle(fontSize: 15),
                                                    onPressed: (){
                                                      actionApproval("revisi");
                                                    },
                                                    text: "Revisi",
                                                    blockButton: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: widthButton,
                                                  height: 50,
                                                  child: GFButton(
                                                    color: Colors.green,
                                                    textStyle: TextStyle(fontSize: 15),
                                                    onPressed: (){
                                                      actionApproval("terima");
                                                    },
                                                    text: "Terima",
                                                    blockButton: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        }else...{
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 3, top: 5),
                                                  child:
                                                    Center(
                                                      child: Text(
                                                        'Proposal dalam tahap Revisi',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: AppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 15,
                                                            color: Colors.yellow.shade700
                                                        ),
                                                      ),
                                                    ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 6, right: 6, top: 15, bottom: 5),
                                                  child: Container(
                                                    height: 2,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.background.withOpacity(0.5),
                                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 3, top: 5),
                                                  child:
                                                    Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 2, left: 7, right: 7, bottom: 3),
                                                          child: Text(
                                                            'Pemberi Revisi',
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              fontFamily: AppTheme.fontName,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 12,
                                                              color:
                                                              AppTheme.grey.withOpacity(0.3),
                                                            ),
                                                          ),
                                                        ),

                                                        if(widget.PemberiRevisi=="3")...{
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 2, left: 7, right: 7, bottom: 3),
                                                            child: Text(
                                                              'Ibu Deborah Hutauruk',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontFamily: AppTheme.fontName,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 15,
                                                                  color: Colors.grey.shade400
                                                              ),
                                                            ),
                                                          ),
                                                        } else if(widget.PemberiRevisi=="7")...{
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 2, left: 7, right: 7, bottom: 3),
                                                            child: Text(
                                                              'Ibu Theresia Thunjung',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontFamily: AppTheme.fontName,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 15,
                                                                  color: Colors.grey.shade400
                                                              ),
                                                            ),
                                                          ),
                                                        } else if(widget.PemberiRevisi=="1414")...{
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 2, left: 7, right: 7, bottom: 3),
                                                            child: Text(
                                                              'Bapak Dominggus',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontFamily: AppTheme.fontName,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 15,
                                                                  color: Colors.yellow.shade700
                                                              ),
                                                            ),
                                                          ),
                                                        } else if(widget.PemberiRevisi=="1415")...{
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 2, left: 7, right: 7, bottom: 3),
                                                            child:  Text(
                                                              'Bapak Asrel Marpaung',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontFamily: AppTheme.fontName,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 15,
                                                                  color: Colors.yellow.shade700
                                                              ),
                                                            ),
                                                          ),
                                                        },

                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 6, right: 6, top: 8, bottom: 5),
                                                          child: Container(
                                                            height: 2,
                                                            decoration: BoxDecoration(
                                                              color: AppTheme.background.withOpacity(0.5),
                                                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                            ),
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 2, left: 7, right: 7, bottom: 3),
                                                          child: Text(
                                                            'Point Revisi',
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              fontFamily: AppTheme.fontName,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 12,
                                                              color:
                                                              AppTheme.grey.withOpacity(0.3),
                                                            ),
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 2, left: 7, right: 7, bottom: 3),
                                                          child: Text(
                                                            widget.CatatanRevisi!,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontFamily: AppTheme.fontName,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 14,
                                                                color: Colors.grey.shade400
                                                            ),
                                                          ),
                                                        ),

                                                      ]
                                                    ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        }
                                      }
                                    }
                                  ],
                                );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                )
            );
        },
      );
  }
}
