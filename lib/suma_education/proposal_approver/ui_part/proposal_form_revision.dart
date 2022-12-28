import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:suma_education/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suma_education/suma_education/main_page/screen/login_screen.dart';
import 'package:suma_education/suma_education/proposal_approver/model/proposal_list_data.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../main.dart';

class ProposalRevisionForm extends StatefulWidget {
  const ProposalRevisionForm(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.idProposal, required this.idPemohon, required this.noProposal, required this.noReg})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? idProposal;
  final String? idPemohon;
  final String? noProposal;
  final String? noReg;

  @override
  _ProposalRevisionFormState createState() => _ProposalRevisionFormState();
}

class _ProposalRevisionFormState extends State<ProposalRevisionForm>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var txtEditPoint = TextEditingController();
  bool sendLoad = false;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  void _load() {
    setState(() {
      sendLoad = !sendLoad;
    });
  }

  _sendRevision(BuildContext context, String statusUpdate) async {
    final SharedPreferences prefs = await _prefs;

    try {
      var response = await http.post(
          Uri.parse("https://proposal.sumasistem.co.id/api/proposal_approval"),
          body: {
            "id_proposal": widget.idProposal,
            "status": statusUpdate,
            "id_user": prefs.getString("IdUser"),
            "poin_revisi": txtEditPoint.text,
            "tgl_permintaan": DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
            "id_pemohon": widget.idPemohon,
          });
      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        await Future.delayed(Duration(milliseconds: 500));
        _load();
        await CoolAlert.show(
            context: context,
            borderRadius: 25,
            type: CoolAlertType.success,
            backgroundColor: Colors.lightGreen.shade50,
            title: 'Terkirim!',
            text: "Point Revisi Proposal berhasil dikirim",
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
                        builder: (BuildContext context) => ProposalDetail(animationController: widget.mainScreenAnimationController, proposalId: widget.idProposal),
                      )
                  );
                });
              });
              Navigator.of(context, rootNavigator: true).pop('dialog');
            }
        );
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
        return
          FadeInUp(
            delay: Duration(milliseconds: 800),
            child: FadeTransition(
              opacity: widget.mainScreenAnimation!,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 32, bottom: 3),
                    child:
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              HexColor("#ffac1a"),
                              HexColor("#ffcb70"),
                            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topRight: Radius.circular(50.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.3),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 3.0),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2, left: 7, right: 7),
                                  child: Text(
                                    'No Register',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                      AppTheme.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1, left: 7, right: 7),
                                  child: Text(
                                    widget.noReg!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2, left: 7, right: 7),
                                  child: Text(
                                    'No Proposal',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                      AppTheme.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1, left: 7, right: 7, bottom: 10),
                                  child: Text(
                                    widget.noProposal!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              HexColor("#fff4db"),
                              HexColor("#ffffff"),
                            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2, left: 7, right: 7),
                                  child: Text(
                                    'Point Revisi :',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                        Colors.blueGrey
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 5, left: 7, right: 7, bottom: 10),
                                    child:
                                    TextField(
                                      keyboardType: TextInputType.multiline,
                                      minLines: 1,//Normal textInputField will be displayed
                                      maxLines: 100,
                                      controller: txtEditPoint,
                                      decoration: InputDecoration(
                                        hintText: 'Ketik point revisi...',
                                        hintStyle: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          color: const Color(0xFF151624).withOpacity(0.5),
                                        ),
                                        // fillColor: txtEditUsername.text.isNotEmpty
                                        //     ? Colors.transparent
                                        //     : const Color.fromRGBO(248, 247, 251, 1),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey.shade100
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: Colors.orange.shade600,
                                            )),
                                        prefixIcon: Icon(
                                          Icons.note_alt_outlined,
                                          color: const Color(0xFF151624).withOpacity(0.5),
                                          size: 18,
                                        ),
                                      ),// when user presses enter it will adapt to it
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),

                        ZoomTapAnimation(
                          child:
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              CoolAlert.show(
                                  context: context,
                                  title: 'Perhatian',
                                  backgroundColor: Colors.lightBlue.shade50,
                                  borderRadius: 25,
                                  width: 30,
                                  loopAnimation: true,
                                  type: CoolAlertType.confirm,
                                  text: 'Kirim point/catatan revisi?',
                                  confirmBtnText: 'OK',
                                  cancelBtnText: 'Batal',
                                  animType: CoolAlertAnimType.scale,
                                  confirmBtnColor: Colors.orange.shade300,
                                  onConfirmBtnTap: (){
                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                    _sendRevision(context, '6');
                                    _load();
                                  }
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 45,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  HexColor("#00a029"),
                                  HexColor("#14b83e"),
                                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.25),
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 3.0),
                                ],
                              ),
                              child:
                              Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10, right: 9, left: 9),
                                child: Center(
                                    child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: sendLoad ? SizedBox(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                            height: 13.0,
                                            width: 13.0,
                                          ) : null,
                                        ),
                                        Text('Kirim Revisi', style: TextStyle(color: Colors.white, fontSize: 17)),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ),
            ),
          );
      },
    );
  }
}

