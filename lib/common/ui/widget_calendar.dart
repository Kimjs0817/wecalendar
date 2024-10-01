import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wecalendar/common/providers/kor_holiday_provider.dart';

import 'package:wecalendar/common/ui/widget_calendar_day.dart';

class WidgetCalendar extends StatefulWidget {
  const WidgetCalendar({super.key});

  @override
  State<WidgetCalendar> createState() => _WidgetCalendarState();
}

class _WidgetCalendarState extends State<WidgetCalendar> {
  DateTime _oSelectedDate = DateTime.now();
  DateTime? _oTempSelectedDate;

  KorHolidayProvider _korHolidayProvider = KorHolidayProvider(); // 공휴일 api Provider

  bool _isKorHolidayApiCall = true;
  String _sPreYear = "", _sPreMonth = "";
  String _sCurYear = "", _sCurMonth = "";
  String _sNextYear = "", _sNextMonth = "";

  bool _isUserSelected = false; // 사용자 일자 선택 여부
  Map<String, dynamic> oUserPreSelectedIndex = {}; // 사용자가 이전에 선택한 from-to 인덱스 저장
  Map<String, dynamic> oUserCurSelectedIndex = {}; // 사용자가 현재 선택한 from-to 인덱스 저장

  bool _isUserSelectedFixed = false; // 사용자 일자 선택 여부(달 변경 후 다시 돌아왔을 때 표시하기 위함)
  Map<String, dynamic> oUserCurSelectedFixedIndex = {}; // 사용자가 현재 선택한 from-to 인덱스 저장(달 변경 후 다시 돌아왔을 때 표시하기 위함)
  Map<String, dynamic> oUserCurSelectedFixedDate = {}; // 사용자가 현재 선택한 from-to 날짜 저장(달 변경 후 다시 돌아왔을 때 표시하기 위함)

  Map<String, dynamic> oPreMonthSelectedIndex = {}; // 현재 달에서 이전달 날짜를 선택했을 경우 이전달 날짜에 대한 인덱스 값
  Map<String, dynamic> oNextMonthSelectedIndex = {}; // 현재 달에서 다음달 날짜를 선택했을 경우 다음달 날짜에 대한 인덱스 값

  Map<String, dynamic> oScheduleDate = {}; // 일정의 from-to 저장

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 초기 실행 시 현재 일자 정보로 디폴트 값 지정
    _sCurYear = _oSelectedDate.year.toString();
    _sCurMonth = _oSelectedDate.month.toString().padLeft(2, "0");

    // 사용자가 선택한 인덱스 값 초기화
    oUserPreSelectedIndex["fromIndex"] = -1;
    oUserPreSelectedIndex["toIndex"] = -1;

    oUserCurSelectedIndex["fromIndex"] = -1;
    oUserCurSelectedIndex["toIndex"] = -1;

    oUserCurSelectedFixedIndex["fromIndex"] = -1;
    oUserCurSelectedFixedIndex["toIndex"] = -1;
    oUserCurSelectedFixedDate["year"] = "9999";
    oUserCurSelectedFixedDate["month"] = "12";
  }

  @override
  Widget build(BuildContext context) {
    fn_getDayInfo(); // 저번달, 이번달, 다음달의 시작 요일, 달의 전체 일수 정보를 구한다.

    // 공휴일 api 호출
    if (_isKorHolidayApiCall) {
      _korHolidayProvider = Provider.of<KorHolidayProvider>(context, listen: false);
      _korHolidayProvider.loadKorHolidays(_sCurYear, _sCurMonth);

      _isKorHolidayApiCall = false;
    }

    return SizedBox(
      child: Column(
        children: [
          CalendarTitleText(), // 년도, 월 선택 버튼 표시
          CalendarWeekText(), // 요일 텍스트 표시
          Consumer<KorHolidayProvider>(builder: (context, provider, widget) {
            // 데이터가 있으면 CalendarGrid 생성
            if (provider.korHolidays.isNotEmpty) {
              return CalendarGrid(); // 각 일자 표시
            }
            // 데이터가 없으면 CircularProgressIndicator 수행(로딩)
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
        ],
      ),
    );
  }

  Widget CalendarTitleText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          // "<" 버튼
          onPressed: () {
            setState(() {
              fn_setPreMonth(); // 저번달 표시
            });
          },
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              _selectDate();
            },
            child: Text(
              "${"$_oSelectedDate".substring(0, 4)}."
              "${"$_oSelectedDate".substring(5, 7)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
                color: Colors.black,
              ),
            ),
          ),
        ),
        IconButton(
          // ">" 버튼
          onPressed: () {
            setState(() {
              fn_setNextMonth(); // 다음달 표시
            });
          },
          icon: const Icon(
            Icons.navigate_next,
          ),
        ),
        // TextButton(
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (BuildContext context) => const CalendarAddSchedule(),
        //       ),
        //     );
        //   },
        //   child: const Text(
        //     "+",
        //     style: TextStyle(
        //       fontSize: 30,
        //       color: Colors.black,
        //     ),
        //   ),
        // )
      ],
    );
  }

  _selectDate() async {
    DateTime? pickDate = await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            child: SizedBox(
              height: 230.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // "취소" 버튼
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0), // left, top, right, bottom
                          child: CupertinoButton(
                            child: Text(
                              '취소',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        Container(
                          // "확인" 버튼
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0), // left, top, right, bottom
                          child: CupertinoButton(
                            child: Text(
                              '확인',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(_oTempSelectedDate);
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 190.h,
                    child: CupertinoDatePicker(
                      initialDateTime: _oSelectedDate,
                      mode: CupertinoDatePickerMode.monthYear,
                      onDateTimeChanged: (DateTime date) {
                        _oTempSelectedDate = date;
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );

    if (pickDate != null && pickDate != _oSelectedDate) {
      setState(() {
        if (_oSelectedDate.year != pickDate.year) {
          _isKorHolidayApiCall = true; // 년도가 바뀌면 공휴일 api 호출
        }
        _oSelectedDate = pickDate;
      });
    }
  }

  Widget CalendarWeekText() {
    var nHeight = 30.h;
    var nWidth = 50.w;
    var oPadding = EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 0.h); // left, top, right, bottom

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: nHeight,
          width: nWidth,
          padding: oPadding,
          child: const Text(
            '일',
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          height: nHeight,
          width: nWidth,
          padding: oPadding,
          child: const Text(
            '월',
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          height: nHeight,
          width: nWidth,
          padding: oPadding,
          child: const Text(
            '화',
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          height: nHeight,
          width: nWidth,
          padding: oPadding,
          child: const Text(
            '수',
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          height: nHeight,
          width: nWidth,
          padding: oPadding,
          child: const Text(
            '목',
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          height: nHeight,
          width: nWidth,
          padding: oPadding,
          child: const Text(
            '금',
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          height: nHeight,
          width: nWidth,
          padding: oPadding,
          child: const Text(
            '토',
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget CalendarGrid() {
    var sDragDx = "";

    // 공휴일 List 인덱스 정보를 Map 형식으로 저장한다.
    Map<String, int> _oKorHolidaysindex = {};
    for (var i = 0; i < _korHolidayProvider.korHolidays.length; i++) {
      _oKorHolidaysindex[_korHolidayProvider.korHolidays[i].locdate] = i; // ex) key:20240101, value:0
    }

    oScheduleDate = {};
    oScheduleDate["fromDate"] = "20240905"; // 테스트
    oScheduleDate["toDate"] = "20240908"; // 테스트
    String sScheduleJson = jsonEncode(oScheduleDate);

    return Expanded(
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 0) {
            sDragDx = "R"; // 오른쪽 스와이프
          } else {
            sDragDx = "L"; // 왼쪽 스와이프
          }
        },
        onPanEnd: (DragEndDetails detail) {
          if (sDragDx == "R") {
            // 오른쪽 스와이프 시 저번달 표시
            setState(() {
              fn_setPreMonth();
            });
          } else {
            // 왼쪽 스와이프 시 다음달 표시
            setState(() {
              fn_setNextMonth();
            });
          }
        },
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  fn_setUserSelectedIndex(index); // 사용자가 선택한 인덱스 값 저장
                });
              },
              child: CalendarDay(
                sCurYear: _sCurYear,
                sCurMonth: _sCurMonth,
                nGridIndex: index,
                jPreSelectedIndex: jsonEncode(oUserPreSelectedIndex),
                jCurSelectedIndex: jsonEncode(oUserCurSelectedIndex),
                jKorHolidays: "", // 공휴일 api 정보(json String)
                jScheduleDate: sScheduleJson, // 위젯에 표시할 스케쥴 정보(from-to)
              ),
            );
          },
        ),
      ),
    );
  }

  /*
    저번달, 이번달, 다음달의 시작 요일, 달의 전체 일수 정보를 구한다.
   */
  void fn_getDayInfo() {
    // 이번달 정보 저장
    _sCurYear = _oSelectedDate.year.toString();
    _sCurMonth = _oSelectedDate.month.toString().padLeft(2, "0");
    // 이전달 정보 저장
    _sPreYear = DateUtils.addMonthsToMonthDate(DateTime.parse("$_sCurYear${_sCurMonth}01"), -1).year.toString();
    _sPreMonth = DateUtils.addMonthsToMonthDate(DateTime.parse("$_sCurYear${_sCurMonth}01"), -1).month.toString().padLeft(2, "0");
    // 다음달 정보 저장
    _sNextYear = DateUtils.addMonthsToMonthDate(DateTime.parse("$_sCurYear${_sCurMonth}01"), 1).year.toString();
    _sNextMonth = DateUtils.addMonthsToMonthDate(DateTime.parse("$_sCurYear${_sCurMonth}01"), 1).month.toString().padLeft(2, "0");

    // 인덱스 선택 후 달을 변경했을 시, 값을 저장해 놓고 해당 달에 들어오면 저장된 인덱스 값으로 다시 박스 표시
    if (!_isUserSelected && _isUserSelectedFixed && oUserCurSelectedFixedIndex["fromIndex"] > -1 && oUserCurSelectedFixedIndex["toIndex"] > -1) {
      if (_sCurYear == oUserCurSelectedFixedDate["year"] && _sCurMonth == oUserCurSelectedFixedDate["month"]) {
        // 저장되어 있는 인덱스 값으로 박스 표시
        _isUserSelected = true;
        oUserCurSelectedIndex["fromIndex"] = oUserCurSelectedFixedIndex["fromIndex"];
        oUserCurSelectedIndex["toIndex"] = oUserCurSelectedFixedIndex["toIndex"];
      }
    }
  }

  /*
    사용자가 선택한 인덱스 값 저장
    [param]
    index : GridView index
   */
  fn_setUserSelectedIndex(int index) {
    // 인덱스가 -1 값이 들어오면 전체 초기화
    if (index == -1) {
      _isUserSelected = false; // 사용자 일자 선택 여부
      oUserPreSelectedIndex["fromIndex"] = -1;
      oUserPreSelectedIndex["toIndex"] = -1;

      oUserCurSelectedIndex["fromIndex"] = -1;
      oUserCurSelectedIndex["toIndex"] = -1;
    } else {
      if (oUserCurSelectedIndex["fromIndex"] == null || oUserCurSelectedIndex["fromIndex"] == -1) {
        _isUserSelected = true; // 사용자 일자 선택 여부
        // 처음 클릭한 경우 from-to 셋팅
        oUserCurSelectedIndex["fromIndex"] = index;
        oUserCurSelectedIndex["toIndex"] = index;
      } else if (oUserCurSelectedIndex["fromIndex"] >= 0) {
        if (oUserCurSelectedIndex["fromIndex"] > index) {
          // 두번째 클릭한 인덱스가 from보다 작으면 무시
          return;
        } else if (oUserCurSelectedIndex["fromIndex"] <= index && oUserCurSelectedIndex["toIndex"] >= index) {
          _isUserSelected = false; // 사용자 일자 선택 여부
          // 이전에 선택한 인덱스 저장
          oUserPreSelectedIndex["fromIndex"] = oUserCurSelectedIndex["fromIndex"];
          oUserPreSelectedIndex["toIndex"] = oUserCurSelectedIndex["toIndex"];
          // 선택한 인덱스들을 한번 더 선택하면 현재 선택한 인덱스 초기화
          oUserCurSelectedIndex["fromIndex"] = -1;
          oUserCurSelectedIndex["toIndex"] = -1;
          // 달 변경 후 다시 돌아왔을 때 표시 하기 위한 저장 값 초기화
          _isUserSelectedFixed = false;
          oUserCurSelectedFixedIndex["fromIndex"] = -1;
          oUserCurSelectedFixedIndex["toIndex"] = -1;
          oUserCurSelectedFixedDate["year"] = "9999";
          oUserCurSelectedFixedDate["month"] = "12";
        } else {
          // to 인덱스 셋팅
          oUserCurSelectedIndex["toIndex"] = index;
        }
      }
    }
  }

  /*
    이전달 정보 셋팅
   */
  void fn_setPreMonth() {
    String sFullDate = "";
    if (_oSelectedDate.year.toString() != _sPreYear) {
      _isKorHolidayApiCall = true; // 년도가 바뀌면 공휴일 api 호출
    }

    // 사용자가 선택한 값들이 존재 하면 저장(달 변경 후 다시 돌아왔을 때 표시하기 위함)
    if (_isUserSelected) {
      _isUserSelectedFixed = true;
      oUserCurSelectedFixedIndex["fromIndex"] = oUserCurSelectedIndex["fromIndex"];
      oUserCurSelectedFixedIndex["toIndex"] = oUserCurSelectedIndex["toIndex"];
      oUserCurSelectedFixedDate["year"] = _sCurYear;
      oUserCurSelectedFixedDate["month"] = _sCurMonth;

      //fn_setDiffMonthIndex(oUserCurSelectedIndex["fromIndex"], oUserCurSelectedIndex["toIndex"]); // 현재 달이 아닌 달에 대한 인덱스 값 저장
    }

    sFullDate = _sPreYear + _sPreMonth + 01.toString().padLeft(2, "0");
    _oSelectedDate = DateTime.parse(sFullDate);

    fn_setUserSelectedIndex(-1); // 사용자 일자 선택 값 초기화
  }

  /*
    다음달 정보 셋팅
   */
  void fn_setNextMonth() {
    String sFullDate = "";
    if (_oSelectedDate.year.toString() != _sNextYear) {
      _isKorHolidayApiCall = true; // 년도가 바뀌면 공휴일 api 호출
    }

    // 사용자가 선택한 값들이 존재 하면 저장(달 변경 후 다시 돌아왔을 때 표시하기 위함)
    if (_isUserSelected) {
      _isUserSelectedFixed = true;
      oUserCurSelectedFixedIndex["fromIndex"] = oUserCurSelectedIndex["fromIndex"];
      oUserCurSelectedFixedIndex["toIndex"] = oUserCurSelectedIndex["toIndex"];
      oUserCurSelectedFixedDate["year"] = _sCurYear;
      oUserCurSelectedFixedDate["month"] = _sCurMonth;

      //fn_setDiffMonthIndex(oUserCurSelectedIndex["fromIndex"], oUserCurSelectedIndex["toIndex"]); // 현재 달이 아닌 달에 대한 인덱스 값 저장
    }

    sFullDate = _sNextYear + _sNextMonth + 01.toString().padLeft(2, "0");
    _oSelectedDate = DateTime.parse(sFullDate);

    fn_setUserSelectedIndex(-1); // 사용자 일자 선택 값 초기화
  }

  /*
    선택 된 일수가 이전달 또는 다음달과 겹쳐있을 때,
    이전달 또는 다음달로 넘어갔을 때 박스를 선택된걸로 보이게 한다
   */
  fn_setDiffMonthIndex(int fromIndex, int toIndex) {
  }
}
