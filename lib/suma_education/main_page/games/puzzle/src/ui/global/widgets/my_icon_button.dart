import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/ui/utils/colors.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/ui/utils/responsive.dart';

class MyIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  const MyIconButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    final size = Responsive.of(context).dp(6).clamp(40, 80).toDouble();
    return MaterialButton(
      onPressed: onPressed,
      child: Icon(
        iconData,
        size: size * 0.4,
      ),
      minWidth: size,
      height: size,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size / 2),
      ),
      color: lightColor.withOpacity(isDarkMode ? 0.2 : 1),
    );
  }
}
