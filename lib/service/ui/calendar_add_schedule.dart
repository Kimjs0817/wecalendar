import 'package:flutter/material.dart';

class CalendarAddSchedule extends StatefulWidget {
  const CalendarAddSchedule({super.key});

  @override
  State<CalendarAddSchedule> createState() => _CalendarAddScheduleState();
}

class _CalendarAddScheduleState extends State<CalendarAddSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Schedule"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is Second Screen'),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Go to First Screen'))
          ],
        ),
      ),
    );
  }
}
