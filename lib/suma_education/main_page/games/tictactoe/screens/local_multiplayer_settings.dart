import 'dart:ffi';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/controllers/offline_game_controller.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/models/tic_tac_toe.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/screens/offline_game.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/widgets/letter_choices.dart';

class LocalMultiplayerSettings extends StatefulWidget {
  const LocalMultiplayerSettings({Key? key}) : super(key: key);

  @override
  State<LocalMultiplayerSettings> createState() => _LocalMultiplayerSettingsState();
}

class _LocalMultiplayerSettingsState extends State<LocalMultiplayerSettings> {
  GameLetter letter = GameLetter.none;
  bool pilih = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          OrientationBuilder(
            builder: (context, orientation) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: FractionallySizedBox(
                      heightFactor: orientation == Orientation.portrait? 0.5 : 1,
                      widthFactor: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Get.theme.scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.1),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                child: LetterChoices(
                                  onChange: (value) {
                                    setState(() {
                                      letter = value;
                                      pilih = true;
                                    });
                                  }
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.blueGrey,
                                      backgroundColor: Colors.transparent,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Icon(Ionicons.arrow_back_outline),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.blueGrey,
                                      backgroundColor: Colors.transparent,
                                    ),
                                    onPressed: () {
                                      if(pilih==true){
                                        Get.back();
                                        Get.to(() => Game(
                                          playerLetter: letter,
                                          mode: GameMode.offlineFriend,
                                        ));
                                      } else {
                                        CoolAlert.show(
                                          context: context,
                                          borderRadius: 25,
                                          type: CoolAlertType.error,
                                          animType: CoolAlertAnimType.scale,
                                          backgroundColor: Colors.red.shade100,
                                          confirmBtnColor: Colors.orange.shade300,
                                          title: 'Oops...',
                                          text: 'Pick your side before continue',
                                          width: 30,
                                          loopAnimation: true,
                                        );
                                      }
                                    },
                                    child: const Icon(Ionicons.arrow_forward_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}