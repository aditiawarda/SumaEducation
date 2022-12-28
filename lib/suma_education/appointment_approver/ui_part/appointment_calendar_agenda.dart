import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:suma_education/main.dart';
import '../../app_theme/app_theme.dart';
import 'package:http/http.dart' as http;

class AppointmentCalendarAgenda extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const AppointmentCalendarAgenda({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;

    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:
        DayView(
          controller: EventController(),
          eventTileBuilder: (date, events, boundry, start, end) {
            // Return your widget to display as event tile.
            return Container(
              child: Text('tes'),
            );
          },
          showVerticalLine: true, // To display live time line in day view.
          showLiveTimeLineInAllDays: true, // To display live time line in all pages in day view.
          minDay: DateTime(1990),
          maxDay: DateTime(2050),
          initialDay: DateTime(2021),
          heightPerMinute: 1, // height occupied by 1 minute time span.
          eventArranger: SideEventArranger(), // To define how simultaneous events will be arranged.
          onEventTap: (events, date) => print(events),
          onDateLongPress: (date) => print(date),
        ),
    );
  }
}
