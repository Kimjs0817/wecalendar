import 'package:flutter/material.dart';

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
        backgroundColor: Colors.white,
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 500,
            child: WidgetCalendar(), // 캘린더 표시
          ),
          SizedBox(
            height: 306,
            child: CalendarSchedule(), // 내 일정 표시
          )
        ],
      ),
    );
  }

  Widget CalendarSchedule() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
            bottom: Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 10,
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 290,
                width: 420,
                margin: const EdgeInsets.fromLTRB(
                    10, 10, 10, 5), // left, top, right, bottom
                child: const WidgetScheduleTabbar(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
