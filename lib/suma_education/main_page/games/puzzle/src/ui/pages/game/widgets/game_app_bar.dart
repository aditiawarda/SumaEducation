import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/ui/global/controllers/theme_controller.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/ui/global/widgets/my_icon_button.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/ui/icons/puzzle_icons.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/ui/pages/game/controller/game_controller.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/ui/utils/platform.dart';

const whiteFlutterLogoColorFilter = ColorFilter.matrix(
  [1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0],
);

class GameAppBar extends StatelessWidget {
  const GameAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Row(
          children: [
            FittedBox(
              child: Text.rich(
                TextSpan(
                  text: "${isIOS ? "Puzzle" : "Puzzle"}\n",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                  children: const [
                    TextSpan(
                      text: "SUMA",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 24,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const Spacer(),
            Consumer<GameController>(
              builder: (_, controller, __) => Row(
                children: [
                  MyIconButton(
                    onPressed: controller.toggleVibration,
                    iconData: controller.state.vibration
                        ? Icons.vibration
                        : Icons.phone_android,
                  ),
                  const SizedBox(width: 10),
                  MyIconButton(
                    onPressed: controller.toggleSound,
                    iconData: controller.state.sound
                        ? Icons.volume_up
                        : Icons.volume_off,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Consumer<ThemeController>(
              builder: (_, controller, __) => MyIconButton(
                onPressed: controller.toggle,
                iconData: controller.isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
