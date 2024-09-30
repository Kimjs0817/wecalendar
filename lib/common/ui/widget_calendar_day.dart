import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarDay extends StatelessWidget {
  const CalendarDay({
    super.key,
    required this.dDate,
    required this.nGridIndex,
    required this.nPreSelectedIndex,
    required this.dPreSelectedDate,
    required this.nCurSelectedIndex,
    required this.dCurSelectedDate,
    required this.sMonthType,
    required this.jKorHolidays,
    required this.jScheduleDate,
  });

  final DateTime dDate;
  final int nGridIndex;
  final int nPreSelectedIndex;
  final DateTime dPreSelectedDate;
  final int nCurSelectedIndex;
  final DateTime dCurSelectedDate;
  final String sMonthType; // 저번달:"0", 이번달:"1", 다음달:"2"
  final String jKorHolidays; // 공휴일 api 정보(json String)
  final String jScheduleDate; // 위젯에 표시할 스케쥴 정보(from-to)

  @override
  Widget build(BuildContext context) {
    String sWeek = DateFormat("E", "ko_KR").format(dDate);
    Color oTextColor = Colors.black;
    Color oBoxColor = Colors.white;

    Map<String, dynamic> oBoxBorderColor = {}; // 박스 테두리 색깔
    oBoxBorderColor["leftBorderColors"] = Colors.white;
    oBoxBorderColor["rightBorderColors"] = Colors.white;
    oBoxBorderColor["topBorderColors"] = Colors.white;
    oBoxBorderColor["bottomBorderColors"] = Colors.white;
    Map<String, dynamic> oBoxBorderWidth = {}; // 박스 테두리 두께
    oBoxBorderWidth["leftBorderWidth"] = 0.toDouble();
    oBoxBorderWidth["rightBorderWidth"] = 0.toDouble();
    oBoxBorderWidth["topBorderWidth"] = 0.toDouble();
    oBoxBorderWidth["bottomBorderWidth"] = 0.toDouble();

    String sDateName = "", sIsHoliday = "";
    Map<String, dynamic> oScheduleDate = {};

    // debugPrint("-------------------------");
    // debugPrint("dDate : $dDate");
    // debugPrint("nGridIndex : $nGridIndex");
    // debugPrint("nPreSelectedIndex : $nPreSelectedIndex");
    // debugPrint("dPreSelectedDate : $dPreSelectedDate");
    // debugPrint("nCurSelectedIndex : $nCurSelectedIndex");
    // debugPrint("dCurSelectedDate : $dCurSelectedDate");
    // debugPrint("sMonthType : $sMonthType");
    // debugPrint("jKorHolidays : $jKorHolidays");
    // debugPrint("jScheduleDate : $jScheduleDate");

    if (jKorHolidays != "") {
      Map<String, dynamic> oKorHolidays = jsonDecode(jKorHolidays);
      sIsHoliday = oKorHolidays["isHoliday"];
      sDateName = oKorHolidays["dateName"];
    }

    if (jScheduleDate != "") {
      oScheduleDate = jsonDecode(jScheduleDate);
      if (dDate == DateTime.parse(oScheduleDate["fromDate"]) ||
          dDate == DateTime.parse(oScheduleDate["toDate"])) {
        // 해당 위젯의 일자가 일정의 from일자 또는 to일자와 같을 때
        oBoxColor = Colors.pink.shade50;
        oBoxBorderColor["leftBorderColors"] = Colors.pink.shade50;
        oBoxBorderColor["rightBorderColors"] = Colors.pink.shade50;
        oBoxBorderColor["topBorderColors"] = Colors.pink.shade50;
        oBoxBorderColor["bottomBorderColors"] = Colors.pink.shade50;
        oBoxBorderWidth["leftBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["rightBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["topBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["bottomBorderWidth"] = 1.toDouble();
      } else if (dDate.isAfter(DateTime.parse(oScheduleDate["fromDate"])) &&
          dDate.isBefore(DateTime.parse(oScheduleDate["toDate"]))) {
        // 해당 위젯의 일자가 일정의 from일자와 to일자 사이에 있을 때
        oBoxColor = Colors.pink.shade50;
        oBoxBorderColor["leftBorderColors"] = Colors.pink.shade50;
        oBoxBorderColor["rightBorderColors"] = Colors.pink.shade50;
        oBoxBorderColor["topBorderColors"] = Colors.pink.shade50;
        oBoxBorderColor["bottomBorderColors"] = Colors.pink.shade50;
        oBoxBorderWidth["leftBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["rightBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["topBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["bottomBorderWidth"] = 1.toDouble();
      }
    }

    if (nGridIndex == nCurSelectedIndex) {
      // 사용자가 선택한 인덱스는 박스 색깔 변경
      oBoxColor = Colors.lightBlueAccent;
      oBoxBorderColor["leftBorderColors"] = Colors.blue;
      oBoxBorderColor["rightBorderColors"] = Colors.blue;
      oBoxBorderColor["topBorderColors"] = Colors.blue;
      oBoxBorderColor["bottomBorderColors"] = Colors.blue;
      oBoxBorderWidth["leftBorderWidth"] = 1.toDouble();
      oBoxBorderWidth["rightBorderWidth"] = 1.toDouble();
      oBoxBorderWidth["topBorderWidth"] = 1.toDouble();
      oBoxBorderWidth["bottomBorderWidth"] = 1.toDouble();
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

    return Container(
      decoration: BoxDecoration(
          color: oBoxColor,
          border: Border(
            left: BorderSide(
              color: oBoxBorderColor["leftBorderColors"],
              width: oBoxBorderWidth["leftBorderWidth"],
            ),
            right: BorderSide(
              color: oBoxBorderColor["rightBorderColors"],
              width: oBoxBorderWidth["rightBorderWidth"],
            ),
            top: BorderSide(
              color: oBoxBorderColor["topBorderColors"],
              width: oBoxBorderWidth["topBorderWidth"],
            ),
            bottom: BorderSide(
              color: oBoxBorderColor["bottomBorderColors"],
              width: oBoxBorderWidth["bottomBorderWidth"],
            ),
          )),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45.w,
                padding: const EdgeInsets.fromLTRB(
                    10, 0, 0, 0), // left, top, right, bottom
                child: Text(
                  dDate.day.toString(),
                  style: TextStyle(
                    fontSize: 10.sp,
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
                width: 45.w,
                padding: const EdgeInsets.fromLTRB(
                    6, 1, 0, 0), // left, top, right, bottom
                child: Text(
                  sDateName,
                  style: TextStyle(
                    fontSize: 6.sp,
                    color: oTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
                10, 3, 0, 0), // left, top, right, bottom
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child: // left, top, right, bottom)
                      Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.shade500,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
                10, 3, 0, 0), // left, top, right, bottom
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child:
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.shade500,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(
                10, 3, 0, 0), // left, top, right, bottom
            child: Text("+5", style: TextStyle(fontSize: 5.sp),)
          ),
        ],
      ),
    );
  }
}
