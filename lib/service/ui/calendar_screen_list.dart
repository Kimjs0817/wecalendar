import 'package:flutter/material.dart';

import 'package:wecalendar/common/ui/widget_schedule_tabbar.dart';

class CalendarScreenList extends StatefulWidget {
  const CalendarScreenList({super.key});

  @override
  State<CalendarScreenList> createState() => _CalendarScreenListState();
}

class _CalendarScreenListState extends State<CalendarScreenList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // 스크롤시 appBar color 색상이 바뀌지 않게 하기 위함
        scrolledUnderElevation: 0, // 스크롤시 appBar color 색상이 바뀌지 않게 하기 위함
        title: Text("Calendar"),
      ),
      body: WidgetScheduleTabbar(),
    );
  }
}
