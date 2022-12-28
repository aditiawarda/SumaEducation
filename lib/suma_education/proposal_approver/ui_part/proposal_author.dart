import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../app_theme/app_theme.dart';
import 'package:http/http.dart' as http;

String? NmKaryawan = "";
String? Bagian = "";

class ProposalAuthor extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? IdUser;
  final String? StatusProposal;
  final String? WilayahCustomer;

  const ProposalAuthor({Key? key, this.animationController, this.animation, this.IdUser, this.StatusProposal, this.WilayahCustomer})
      : super(key: key);

  Future <String>_getProposalAuthor() async {
    try {
      var response = await http.post(
          Uri.parse("https://proposal.sumasistem.co.id/api/proposal_author"),
          body: {
            "id_user": IdUser!,
          });
      var json = jsonDecode(response.body);
      String status = json["status"];
      if (status == "Success") {
        NmKaryawan = json['data'][0]['NmKaryawan'];
        Bagian = json['data'][0]['NmDept'];
      }
    } catch (e) {
      print("Error");
    }
    return 'true';
  }

  @override
  Widget build(BuildContext context) {
    return
      FadeInUp(
          delay : Duration(milliseconds: 500),
          child : AnimatedBuilder(
            animation: animationController!,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation!,
                child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 30 * (1.0 - animation!.value), 0.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 0, bottom: 0),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                      bottomRight: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.3),
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 3.0),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: <Widget>[
                                    if(StatusProposal=="5")...{
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                        child: SizedBox(
                                          height: 74,
                                          child: AspectRatio(
                                            aspectRatio: 1.714,
                                            child: Image.asset(
                                                "assets/suma_education/back_rejected.png"),
                                          ),
                                        ),
                                      ),
                                    } else ...{
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                        child: SizedBox(
                                          height: 74,
                                          child: AspectRatio(
                                            aspectRatio: 1.714,
                                            child: Image.asset(
                                                "assets/suma_education/back.png"),
                                          ),
                                        ),
                                      ),
                                    },

                                    FutureBuilder<String>(
                                      future: _getProposalAuthor(), // function where you call your api
                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 20,
                                                  top: 14,
                                                  right: 16,
                                                ),
                                                child: Text(
                                                  "Penyusun :",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily: AppTheme.fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11,
                                                    letterSpacing: 0.0,
                                                    color: AppTheme.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  if(StatusProposal=='5')...{
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                        left: 20,
                                                        right: 16,
                                                        top: 5,
                                                      ),
                                                      child: Text(NmKaryawan!,
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily:
                                                          AppTheme.fontName,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 17,
                                                          letterSpacing: 0.0,
                                                          color:
                                                          Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  } else ...{
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                        left: 20,
                                                        right: 16,
                                                        top: 5,
                                                      ),
                                                      child: Text(NmKaryawan!,
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily:
                                                          AppTheme.fontName,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 17,
                                                          letterSpacing: 0.0,
                                                          color:
                                                          AppTheme.nearlyDarkOrange,
                                                        ),
                                                      ),
                                                    ),
                                                  }
                                                ],
                                              ),
                                              if(Bagian=="SUMA JAKARTA")...{
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 20,
                                                    bottom: 16,
                                                    top: 4,
                                                    right: 16,
                                                  ),
                                                  child: Text(
                                                    WilayahCustomer!+"  |  JAKARTA",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: 0.0,
                                                      color: AppTheme.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              }
                                              else ...{
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 20,
                                                    bottom: 16,
                                                    top: 4,
                                                    right: 16,
                                                  ),
                                                  child: Text(
                                                    Bagian!,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: 0.0,
                                                      color: AppTheme.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              }
                                            ],
                                          );
                                        } else {
                                          if (snapshot.hasError)
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 20,
                                                    top: 14,
                                                    right: 16,
                                                  ),
                                                  child: Text(
                                                    "Penyusun :",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 11,
                                                      letterSpacing: 0.0,
                                                      color: AppTheme.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    if(StatusProposal=='5')...{
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                          left: 20,
                                                          right: 16,
                                                          top: 5,
                                                        ),
                                                        child: Text(NmKaryawan!,
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            AppTheme.fontName,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 17,
                                                            letterSpacing: 0.0,
                                                            color:
                                                            Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    } else ...{
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                          left: 20,
                                                          right: 16,
                                                          top: 5,
                                                        ),
                                                        child: Text(NmKaryawan!,
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            AppTheme.fontName,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 17,
                                                            letterSpacing: 0.0,
                                                            color:
                                                            AppTheme.nearlyDarkOrange,
                                                          ),
                                                        ),
                                                      ),
                                                    }
                                                  ],
                                                ),
                                                if(Bagian=="SUMA JAKARTA")...{
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 16,
                                                      top: 4,
                                                      right: 16,
                                                    ),
                                                    child: Text(
                                                      WilayahCustomer!+"  |  JAKARTA",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14,
                                                        letterSpacing: 0.0,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                }
                                                else ...{
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 16,
                                                      top: 4,
                                                      right: 16,
                                                    ),
                                                    child: Text(
                                                      Bagian!,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14,
                                                        letterSpacing: 0.0,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                }
                                              ],
                                            );
                                          else
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 20,
                                                    top: 14,
                                                    right: 16,
                                                  ),
                                                  child: Text(
                                                    "Penyusun :",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 11,
                                                      letterSpacing: 0.0,
                                                      color: AppTheme.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    if(StatusProposal=='5')...{
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                          left: 20,
                                                          right: 16,
                                                          top: 5,
                                                        ),
                                                        child: Text(NmKaryawan!,
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            AppTheme.fontName,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 17,
                                                            letterSpacing: 0.0,
                                                            color:
                                                            Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    } else ...{
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                          left: 20,
                                                          right: 16,
                                                          top: 5,
                                                        ),
                                                        child: Text(NmKaryawan!,
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            AppTheme.fontName,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 17,
                                                            letterSpacing: 0.0,
                                                            color:
                                                            AppTheme.nearlyDarkOrange,
                                                          ),
                                                        ),
                                                      ),
                                                    }
                                                  ],
                                                ),

                                                if(Bagian=="SUMA JAKARTA")...{
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 16,
                                                      top: 4,
                                                      right: 16,
                                                    ),
                                                    child: Text(
                                                      WilayahCustomer!+"  |  JAKARTA",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14,
                                                        letterSpacing: 0.0,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                }
                                                else ...{
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 16,
                                                      top: 4,
                                                      right: 16,
                                                    ),
                                                    child: Text(
                                                      Bagian!,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14,
                                                        letterSpacing: 0.0,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                }

                                              ],
                                            ); // snapshot.data  :- get your object which is pass from your downloadData() function
                                        }
                                      },
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            if(StatusProposal=='5')...{
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: Image.asset("assets/suma_education/hand_write_rejected.png"),
                                ),
                              )
                            } else ...{
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: Image.asset("assets/suma_education/hand_write.png"),
                                ),
                              )
                            }
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      );
  }
}
