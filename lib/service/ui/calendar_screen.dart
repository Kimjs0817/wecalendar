import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wecalendar/common/ui/widget_calendar.dart';
import 'package:wecalendar/common/ui/widget_schedule_tabbar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // 스크롤시 appBar color 색상이 바뀌지 않게 하기 위함
        scrolledUnderElevation: 0, // 스크롤시 appBar color 색상이 바뀌지 않게 하기 위함
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          SizedBox( // 캘린더 위젯은 크기 고정
            height: 360.h,
            child: const WidgetCalendar(), // 캘린더 위젯 표시
          ),
          Expanded( // 나머지 공간은 내 일정으로 표시
            child: CalendarSchedule(), // 내 일정 표시
          ),
        ],
      ),
    );
  }

  Widget CalendarSchedule() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        10, 5, 10, 5), // left, top, right, bottom,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
            bottom: Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 5,
                offset: const Offset(0, 5))
          ]),
      child: const WidgetScheduleTabbar(),
    );
  }
}
