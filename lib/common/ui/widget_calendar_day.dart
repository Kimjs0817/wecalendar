import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarDay extends StatelessWidget {
  const CalendarDay({
    super.key,
    required this.dDate,
    required this.nGridIndex,
    required this.nSelectedIndex,
    required this.dSelectedDate,
    required this.sMonthType,
    required this.jKorHolidays,
  });

  final DateTime dDate;
  final int nGridIndex;
  final int nSelectedIndex;
  final DateTime dSelectedDate;
  final String sMonthType; // 저번달:"0", 이번달:"1", 다음달:"2"
  final String jKorHolidays; // 공휴일 api 정보(json String)

  @override
  Widget build(BuildContext context) {
    String sWeek = DateFormat("E", "ko_KR").format(dDate);
    Color oTextColor = Colors.black;
    Color oBoxColor = Colors.white;
    Color oBoxBorderColor = Colors.white;
    String sDateName = "", sIsHoliday = "";

    // debugPrint("-------------------------");
    // debugPrint("dDate : $dDate");
    // debugPrint("nGridIndex : $nGridIndex");
    // debugPrint("nSelectedIndex : $nSelectedIndex");
    // debugPrint("dSelectedDate : $dSelectedDate");
    // debugPrint("sMonthType : $sMonthType");
    // debugPrint("jKorHolidays : $jKorHolidays");

    if (jKorHolidays != "") {
      Map<String, dynamic> oKorHolidays = jsonDecode(jKorHolidays);
      sIsHoliday = oKorHolidays["isHoliday"];
      sDateName = oKorHolidays["dateName"];
    }

    // 일자별 텍스트 컬러 지정
    if (sMonthType == "0" || sMonthType == "2") {
      oTextColor = Colors.grey;
    } else if (sIsHoliday == "Y") {
      oTextColor = Colors.red;
    } else {
      switch (sWeek) {
        case "월":
          oTextColor = Colors.black;
          break;
        case "화":
          oTextColor = Colors.black;
          break;
        case "수":
          oTextColor = Colors.black;
          break;
        case "목":
          oTextColor = Colors.black;
          break;
        case "금":
          oTextColor = Colors.black;
          break;
        case "토":
          oTextColor = Colors.blue;
          break;
        case "일":
          oTextColor = Colors.red;
          break;
      }
    }

    // 사용자가 선택한 인덱스는 색깔 변경
    if (nGridIndex == nSelectedIndex) {
      oBoxColor = Colors.lightBlueAccent;
      oBoxBorderColor = Colors.blue;
    }

    return Container(
      decoration: BoxDecoration(
        color: oBoxColor,
        border: Border.all(
          color: oBoxBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                padding: const EdgeInsets.fromLTRB(
                    6, 0, 0, 0), // left, top, right, bottom
                child: Text(
                  dDate.day.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: oTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 50,
                padding: const EdgeInsets.fromLTRB(
                    6, 2, 0, 0), // left, top, right, bottom
                child: Text(
                  sDateName,
                  style: TextStyle(
                    fontSize: 6,
                    color: oTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          )
          // Container(
          //   height: 5,
          //   decoration: const BoxDecoration(
          //     color: Colors.red,
          //     borderRadius: BorderRadius.horizontal(
          //       right: Radius.circular(20)
          //     )
          //   ),
          //   margin: const EdgeInsets.only(top: 2),
          // ),
        ],
      ),
    );
  }
}
