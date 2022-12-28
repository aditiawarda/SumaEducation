import 'package:animate_do/animate_do.dart';
import 'package:suma_education/suma_education/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_all_list.dart';
import 'package:suma_education/suma_education/proposal_approver/screen/proposal_detail_view.dart';

class TitleViewProposal extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const TitleViewProposal(
      {Key? key,
      this.titleTxt: "",
      this.subTxt: "",
      this.animationController,
      this.animation})
      : super(key: key);

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
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            titleTxt,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 0.5,
                              color: AppTheme.lightText,
                            ),
                          ),
                        ),
                        if(titleTxt=='Antrian Proposal')...{
                          InkWell(
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            onTap: () {
                              Navigator.push<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => ProposalAllList(animationController: animationController),
                                  )
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    subTxt,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                      color: AppTheme.nearlyDarkOrange,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 38,
                                    width: 26,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: AppTheme.darkText,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        }
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
  }
}
