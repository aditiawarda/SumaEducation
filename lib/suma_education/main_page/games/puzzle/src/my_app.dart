import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/generated/l10n.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/ui/routes/app_routes.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/ui/routes/routes.dart';

import 'ui/global/controllers/theme_controller.dart';
import 'ui/global/widgets/max_text_scale_factor.dart';

class MyAppGAME extends StatelessWidget {
  const MyAppGAME({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (_, controller, __) => MaterialApp(
          builder: (_, page) => MaxTextScaleFactor(
            child: page!,
          ),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate, // Here !
            DefaultWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
          ],
          debugShowCheckedModeBanner: false,
          themeMode: controller.themeMode,
          theme: controller.lightTheme,
          darkTheme: controller.darkTheme,
          initialRoute: Routes.splash,
          routes: appRoutes,
        ),
      ),
    );
  }
}
