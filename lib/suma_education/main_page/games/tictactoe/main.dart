import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/controllers/settings_controller.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/screens/ai_game_settings.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/screens/create_room_screen.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/screens/home.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/screens/multiplayer_options.dart';
import 'package:suma_education/suma_education/main_page/games/tictactoe/screens/settings_screen.dart';

void mainTIX() {
  runApp(const MyAppTICTAC());
}

class MyAppTICTAC extends StatelessWidget {
  const MyAppTICTAC({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put<SettingsController>(SettingsController());

    return GetMaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: '/', page: () => const Home()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
        GetPage(name: '/game_settings', page: () => const GameSettings()),
        GetPage(name: '/multiplayer_options', page: () => const MultiplayerOptions()),
        GetPage(name: '/create_room', page: () => const CreateRoomScreen()),
      ],
      initialRoute: '/',
    );
  }
}
