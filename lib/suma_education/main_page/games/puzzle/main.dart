import 'package:flutter/material.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/inject_dependencies.dart';
// import 'package:suma_learning/dashboard/fragment/gamelist/puzzle/';
import 'package:url_strategy/url_strategy.dart';
import 'src/my_app.dart';

void mainPUZ() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await injectDependencies();
  runApp(const MyAppGAME());
}
