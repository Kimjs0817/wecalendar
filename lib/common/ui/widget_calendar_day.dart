import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecalendar/common/function/common_function.dart';

class CalendarDay extends StatelessWidget {
  const CalendarDay({
    super.key,
    required this.nCurYear,
    required this.nCurMonth,
    required this.nGridIndex,
    required this.dSelectedFromDate,
    required this.dSelectedToDate,
    required this.dScheduleFromDate,
    required this.dScheduleToDate,
    required this.jKorHolidays,
  });

  final int nCurYear;
  final int nCurMonth;
  final int nGridIndex;
  final DateTime dSelectedFromDate; // 선택한 일자(from)
  final DateTime dSelectedToDate; // 선택한 일자(from)
  final DateTime dScheduleFromDate; // 선택한 일자(from)
  final DateTime dScheduleToDate; // 선택한 일자(from)
  final String jKorHolidays; // 공휴일 api 정보(json String)

  @override
  Widget build(BuildContext context) {
    DateTime dDate = gfn_getIndexToDate(context, nCurYear.toString(), nCurMonth.toString(), nGridIndex);

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
    Map<String, dynamic> oBoxBorderRadius = {}; // 박스 테두리 둥글게
    oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
    oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
    oBoxBorderRadius["topLeft"] = const Radius.circular(0);
    oBoxBorderRadius["topRight"] = const Radius.circular(0);

    String sDateName = "", sIsHoliday = "";

    if (jKorHolidays != "") {
      Map<String, dynamic> oKorHolidays = jsonDecode(jKorHolidays);
      sIsHoliday = oKorHolidays["isHoliday"];
      sDateName = oKorHolidays["dateName"];
    }

    // 일자별 텍스트 컬러 지정
    String sWeek = DateFormat("E", "ko_KR").format(dDate);
    Color oTextColor = Colors.black;
    if (dDate.month != nCurMonth) {
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

    // 사용자 선택 일자(from-to)
    if (dSelectedFromDate != DateTime.parse("99991231") && dSelectedToDate != DateTime.parse("99991231")) {
      DateTime dGridDate = gfn_getIndexToDate(context, nCurYear.toString(), nCurMonth.toString(), nGridIndex);
      int nDateCnt =
          gfn_getDateToIndex(context, nCurYear.toString(), nCurMonth.toString(), dSelectedToDate) - gfn_getDateToIndex(context, nCurYear.toString(), nCurMonth.toString(), dSelectedFromDate);
      if (dSelectedFromDate == dGridDate || dSelectedToDate == dGridDate || dGridDate.isAfter(dSelectedFromDate) && dGridDate.isBefore(dSelectedToDate)) {
        // 선택한 일자가 from-to에 속해 있을 때 배경 색깔 변경
        if (dGridDate == dSelectedFromDate) {
          oBoxColor = Colors.blue.shade100;
          oBoxBorderColor["leftBorderColors"] = Colors.blue.shade100;
          oBoxBorderColor["rightBorderColors"] = Colors.blue.shade100;
          oBoxBorderColor["topBorderColors"] = Colors.blue.shade100;
          oBoxBorderColor["bottomBorderColors"] = Colors.blue.shade100;
        } else if (dGridDate == dSelectedToDate) {
          oBoxColor = Colors.blue.shade100;
          oBoxBorderColor["leftBorderColors"] = Colors.blue.shade100;
          oBoxBorderColor["rightBorderColors"] = Colors.blue.shade100;
          oBoxBorderColor["topBorderColors"] = Colors.blue.shade100;
          oBoxBorderColor["bottomBorderColors"] = Colors.blue.shade100;
        } else {
          oBoxColor = Colors.blue.shade50;
          oBoxBorderColor["leftBorderColors"] = Colors.blue.shade50;
          oBoxBorderColor["rightBorderColors"] = Colors.blue.shade50;
          oBoxBorderColor["topBorderColors"] = Colors.blue.shade50;
          oBoxBorderColor["bottomBorderColors"] = Colors.blue.shade50;
        }
        oBoxBorderWidth["leftBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["rightBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["topBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["bottomBorderWidth"] = 1.toDouble();

        if (nDateCnt == 0) {
          oBoxBorderRadius["topLeft"] = const Radius.circular(10);
          oBoxBorderRadius["topRight"] = const Radius.circular(10);
          oBoxBorderRadius["bottomLeft"] = const Radius.circular(10);
          oBoxBorderRadius["bottomRight"] = const Radius.circular(10);
        } else if (nDateCnt >= 7) {
          // 선택한 인덱스가 7개 이상이면 2줄로 넘어가기 때문에 테두리 자연스럽게 표시
          if (dGridDate == dSelectedFromDate) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(10);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
          } else if (dGridDate == dSelectedToDate) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(0);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(10);
          } else {
            oBoxBorderRadius["topLeft"] = const Radius.circular(0);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
          }
        } else {
          // 선택한 인덱스가 2~6개이면 한줄 표시
          if (dGridDate == dSelectedFromDate) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(10);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(10);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
          } else if (dGridDate == dSelectedToDate) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(0);
            oBoxBorderRadius["topRight"] = const Radius.circular(10);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(10);
          } else {
            oBoxBorderRadius["topLeft"] = const Radius.circular(0);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
          }
        }
      }
    }

    if (dScheduleFromDate != DateTime.parse("99991231") && dScheduleToDate != DateTime.parse("99991231")) {
      // 사용자 선택 스케쥴 일자(from-to)
      DateTime dGridDate = gfn_getIndexToDate(context, nCurYear.toString(), nCurMonth.toString(), nGridIndex);
      int nDateCnt =
          gfn_getDateToIndex(context, nCurYear.toString(), nCurMonth.toString(), dScheduleToDate) - gfn_getDateToIndex(context, nCurYear.toString(), nCurMonth.toString(), dScheduleFromDate);
      if (dScheduleFromDate == dGridDate || dScheduleToDate == dGridDate || dGridDate.isAfter(dScheduleFromDate) && dGridDate.isBefore(dScheduleToDate)) {
        // 해당 위젯의 일자가 스케쥴의 from일자와 to일자에 속해있을 때
        if (dGridDate == dScheduleFromDate) {
          oBoxColor = Colors.pink.shade100;
          oBoxBorderColor["leftBorderColors"] = Colors.pink.shade100;
          oBoxBorderColor["rightBorderColors"] = Colors.pink.shade100;
          oBoxBorderColor["topBorderColors"] = Colors.pink.shade100;
          oBoxBorderColor["bottomBorderColors"] = Colors.pink.shade100;
          if (dSelectedToDate != DateTime.parse("99991231") && dGridDate == dSelectedFromDate || dGridDate == dSelectedToDate
              || dGridDate.isAfter(dSelectedFromDate) && dGridDate.isBefore(dSelectedToDate)) {
            oBoxColor = Colors.orange.shade100;
            oBoxBorderColor["leftBorderColors"] = Colors.orange.shade100;
            oBoxBorderColor["rightBorderColors"] = Colors.orange.shade100;
            oBoxBorderColor["topBorderColors"] = Colors.orange.shade100;
            oBoxBorderColor["bottomBorderColors"] = Colors.orange.shade100;
          }
        } else if (dGridDate == dScheduleToDate) {
          oBoxColor = Colors.pink.shade100;
          oBoxBorderColor["leftBorderColors"] = Colors.pink.shade100;
          oBoxBorderColor["rightBorderColors"] = Colors.pink.shade100;
          oBoxBorderColor["topBorderColors"] = Colors.pink.shade100;
          oBoxBorderColor["bottomBorderColors"] = Colors.pink.shade100;
          if (dSelectedToDate != DateTime.parse("99991231") && dGridDate == dSelectedFromDate || dGridDate == dSelectedToDate
              || dGridDate.isAfter(dSelectedFromDate) && dGridDate.isBefore(dSelectedToDate)) {
            oBoxColor = Colors.orange.shade100;
            oBoxBorderColor["leftBorderColors"] = Colors.orange.shade100;
            oBoxBorderColor["rightBorderColors"] = Colors.orange.shade100;
            oBoxBorderColor["topBorderColors"] = Colors.orange.shade100;
            oBoxBorderColor["bottomBorderColors"] = Colors.orange.shade100;
          }
        } else {
          oBoxColor = Colors.pink.shade50;
          oBoxBorderColor["leftBorderColors"] = Colors.pink.shade50;
          oBoxBorderColor["rightBorderColors"] = Colors.pink.shade50;
          oBoxBorderColor["topBorderColors"] = Colors.pink.shade50;
          oBoxBorderColor["bottomBorderColors"] = Colors.pink.shade50;
          if (dSelectedToDate != DateTime.parse("99991231") && dGridDate == dSelectedFromDate || dGridDate == dSelectedToDate
              || dGridDate.isAfter(dSelectedFromDate) && dGridDate.isBefore(dSelectedToDate)) {
            oBoxColor = Colors.orange.shade50;
            oBoxBorderColor["leftBorderColors"] = Colors.orange.shade50;
            oBoxBorderColor["rightBorderColors"] = Colors.orange.shade50;
            oBoxBorderColor["topBorderColors"] = Colors.orange.shade50;
            oBoxBorderColor["bottomBorderColors"] = Colors.orange.shade50;
          }
        }
        oBoxBorderWidth["leftBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["rightBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["topBorderWidth"] = 1.toDouble();
        oBoxBorderWidth["bottomBorderWidth"] = 1.toDouble();

        if (nDateCnt == 0) {
          oBoxBorderRadius["topLeft"] = const Radius.circular(10);
          oBoxBorderRadius["topRight"] = const Radius.circular(10);
          oBoxBorderRadius["bottomLeft"] = const Radius.circular(10);
          oBoxBorderRadius["bottomRight"] = const Radius.circular(10);
          if (dSelectedToDate != DateTime.parse("99991231") && dSelectedFromDate != dSelectedToDate && dScheduleToDate == dSelectedToDate) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(0);
            oBoxBorderRadius["topRight"] = const Radius.circular(10);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(10);
          } else if (dSelectedToDate != DateTime.parse("99991231") && dSelectedFromDate != dSelectedToDate && dScheduleFromDate == dSelectedFromDate) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(10);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(10);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
          } else if (dSelectedToDate != DateTime.parse("99991231") && dSelectedFromDate != dSelectedToDate
              && dScheduleFromDate.isAfter(dSelectedFromDate) && dScheduleToDate.isBefore(dSelectedToDate)) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(0);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
          }
        } else if (nDateCnt >= 7) {
          // 선택한 인덱스가 7개 이상이면 2줄로 넘어가기 때문에 테두리 자연스럽게 표시
          if (dGridDate == dScheduleFromDate) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(10);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
            if (dSelectedToDate != DateTime.parse("99991231") && dSelectedFromDate != dSelectedToDate
                && (dScheduleFromDate == dSelectedToDate) || (dScheduleFromDate.isAfter(dSelectedFromDate) && dScheduleFromDate.isBefore(dSelectedToDate))) {
              // 사용자 선택일자가 1개가 아니고(dSelectedFromDate != dSelectedToDate), 선택 to일자가 스케쥴 from 일자와 같거나, 스케쥴의 from일자가 선택한 일자에 포함될 때
              oBoxBorderRadius["topLeft"] = const Radius.circular(0);
              oBoxBorderRadius["topRight"] = const Radius.circular(0);
              oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
              oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
            }
          } else if (dGridDate == dScheduleToDate) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(0);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(10);
            if (dSelectedToDate != DateTime.parse("99991231") && dSelectedFromDate != dSelectedToDate
                && (dScheduleToDate == dSelectedFromDate) || (dScheduleToDate.isAfter(dSelectedFromDate) && dScheduleToDate.isBefore(dSelectedToDate))) {
              // 사용자 선택일자가 1개가 아니고(dSelectedFromDate != dSelectedToDate), 선택 to일자가 스케쥴 from 일자와 같거나, 스케쥴의 from일자가 선택한 일자에 포함될 때
              oBoxBorderRadius["topLeft"] = const Radius.circular(0);
              oBoxBorderRadius["topRight"] = const Radius.circular(0);
              oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
              oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
            }
          } else {
            oBoxBorderRadius["topLeft"] = const Radius.circular(0);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
          }
        } else {
          // 선택한 인덱스가 2~6개이면 한줄 표시
          if (dGridDate == dScheduleFromDate) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(10);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(10);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
            if (dSelectedToDate != DateTime.parse("99991231") && dSelectedFromDate != dSelectedToDate
                && (dScheduleFromDate == dSelectedToDate) || (dScheduleFromDate.isAfter(dSelectedFromDate) && dScheduleFromDate.isBefore(dSelectedToDate))) {
              // 사용자 선택일자가 1개가 아니고(dSelectedFromDate != dSelectedToDate), 선택 to일자가 스케쥴 from 일자와 같거나, 스케쥴의 from일자가 선택한 일자에 포함될 때
              oBoxBorderRadius["topLeft"] = const Radius.circular(0);
              oBoxBorderRadius["topRight"] = const Radius.circular(0);
              oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
              oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
            }
          } else if (dGridDate == dScheduleToDate) {
            oBoxBorderRadius["topLeft"] = const Radius.circular(0);
            oBoxBorderRadius["topRight"] = const Radius.circular(10);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(10);
            if (dSelectedToDate != DateTime.parse("99991231") && dSelectedFromDate != dSelectedToDate
                && (dScheduleToDate == dSelectedFromDate) || (dScheduleToDate.isAfter(dSelectedFromDate) && dScheduleToDate.isBefore(dSelectedToDate))) {
              // 사용자 선택일자가 1개가 아니고(dSelectedFromDate != dSelectedToDate), 선택 to일자가 스케쥴 from 일자와 같거나, 스케쥴의 from일자가 선택한 일자에 포함될 때
              oBoxBorderRadius["topLeft"] = const Radius.circular(0);
              oBoxBorderRadius["topRight"] = const Radius.circular(0);
              oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
              oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
            }
          } else {
            oBoxBorderRadius["topLeft"] = const Radius.circular(0);
            oBoxBorderRadius["topRight"] = const Radius.circular(0);
            oBoxBorderRadius["bottomLeft"] = const Radius.circular(0);
            oBoxBorderRadius["bottomRight"] = const Radius.circular(0);
          }
        }
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
        ),
        borderRadius: BorderRadius.only(
          topLeft: oBoxBorderRadius["topLeft"],
          topRight: oBoxBorderRadius["topRight"],
          bottomLeft: oBoxBorderRadius["bottomLeft"],
          bottomRight: oBoxBorderRadius["bottomRight"],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45.w,
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0), // left, top, right, bottom
                child: Text(
                  gfn_getIndexToDate(context, nCurYear.toString(), nCurMonth.toString(), nGridIndex).day.toString(),
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
                padding: const EdgeInsets.fromLTRB(6, 1, 0, 0), // left, top, right, bottom
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
            padding: const EdgeInsets.fromLTRB(10, 3, 0, 0), // left, top, right, bottom
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
            padding: const EdgeInsets.fromLTRB(10, 3, 0, 0), // left, top, right, bottom
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                  child: Container(
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
              padding: const EdgeInsets.fromLTRB(10, 3, 0, 0), // left, top, right, bottom
              child: Text(
                "+5",
                style: TextStyle(fontSize: 5.sp),
              )),
        ],
      ),
    );
  }
}
