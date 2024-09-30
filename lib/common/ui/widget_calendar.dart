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
  final DateTime _oNow = DateTime.now();
  DateTime _oSelectedDate = DateTime.now();
  DateTime? _oTempSelectedDate;

  KorHolidayProvider _korHolidayProvider =
      KorHolidayProvider(); // 공휴일 api Provider

  bool _isKorHolidayApiCall = true;
  String _sPreYear = "", _sPreMonth = "";
  String _sCurYear = "", _sCurMonth = "";
  String _sNextYear = "", _sNextMonth = "";

  int _nPreviousMonthStartDayOffSet = 0; // 이전달 월의 시작 요일
  int _nCurrentMonthStartDayOffSet = 0; // 이번달 월의 시작 요일
  int _nNextMonthStartDayOffSet = 0; // 다음달 월의 시작 요일
  int _nPreviousMonthDays = 0; // 이전달 월의 전체 일수
  int _nCurrentMonthDays = 0; // 이번달 월의 전체 일수
  int _nNextMonthDays = 0; // 다음달 월의 전체 일수

  final List<DateTime> _aGridDate = []; // 그리드 인덱스 별 날짜를 배열로 저장
  bool _isUserSelected = false;
  DateTime _dCurMonthSelectedDate = DateTime.parse(
      "99991231"); // 그리드뷰에서 이번달에 현재 선택한 날짜(다시 이번달로 돌아왔을 때 포커스 가기 위함)
  int _nCurMonthSelectedIndex =
      -1; // 그리드뷰에서 이번달에 현재 선택한 인덱스 값(다시 이번달로 돌아왔을 때 포커스 가기 위함)
  DateTime _dPreSelectedDate = DateTime.parse("99991231"); // 그리드뷰에서 이전에 선택한 날짜
  int _nPreSelectedIndex = -1; // 그리드뷰에서 이전에 선택한 인덱스 값
  DateTime _dCurSelectedDate = DateTime.parse("99991231"); // 그리드뷰에서 현재 선택한 날짜
  int _nCurSelectedIndex = -1; // 그리드뷰에서 현재 선택한 인덱스 값

  Map<String, dynamic> oScheduleDate = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 초기 실행 시 현재 일자 정보로 디폴트 값 지정
    _sCurYear = _oSelectedDate.year.toString();
    _sCurMonth = _oSelectedDate.month.toString().padLeft(2, "0");
  }

  @override
  Widget build(BuildContext context) {
    fn_getDayInfo(); // 저번달, 이번달, 다음달의 시작 요일, 달의 전체 일수 정보를 구한다.

    _aGridDate.clear(); // 날짜 배열 초기화

    // 공휴일 api 호출
    if (_isKorHolidayApiCall) {
      _korHolidayProvider =
          Provider.of<KorHolidayProvider>(context, listen: false);
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
                          padding: const EdgeInsets.fromLTRB(
                              10, 0, 0, 0), // left, top, right, bottom
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
                          padding: const EdgeInsets.fromLTRB(
                              0, 0, 10, 0), // left, top, right, bottom
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
    var oPadding =
        EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 0.h); // left, top, right, bottom

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
    int nPreviousMonthDay = 0; // 저번달
    int nCurrentMonthDay = 0; // 이번달
    int nNextMonthDay = 0; // 다음달
    var sFullDate = ""; // 전체일자(yyyymmdd)

    var sDragDx = "";

    // 공휴일 List 인덱스 정보를 Map 형식으로 저장한다.
    Map<String, int> _oKorHolidaysindex = {};
    for (var i = 0; i < _korHolidayProvider.korHolidays.length; i++) {
      _oKorHolidaysindex[_korHolidayProvider.korHolidays[i].locdate] =
          i; // ex) key:20240101, value:0
    }

    oScheduleDate = {};
    oScheduleDate["fromDate"] = "20240905"; // 테스트
    oScheduleDate["toDate"] = "20241007"; // 테스트
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
            if (index < _nCurrentMonthStartDayOffSet) {
              // 이전달 일자 표시
              nPreviousMonthDay = ((_nPreviousMonthDays + 1) -
                  (_nCurrentMonthStartDayOffSet - index));
              sFullDate = _sPreYear +
                  _sPreMonth +
                  nPreviousMonthDay.toString().padLeft(2, "0");
              _aGridDate.add(DateTime.parse(sFullDate)); // 해당 일자를 배열에 add
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _isUserSelected = true; // 사용자가 일자를 클릭했는지 여부
                    _nCurMonthSelectedIndex =
                        index; // 그리드뷰에서 이번달에 현재 선택한 인덱스 값(다시 이번달로 돌아왔을 때 포커스 가기 위함)
                    _dCurMonthSelectedDate = _aGridDate[
                        index]; // 그리드뷰에서 이번달에 현재 선택한 날짜(다시 이번달로 돌아왔을 때 포커스 가기 위함)
                    _nPreSelectedIndex =
                        _nCurSelectedIndex; // 그리드에서 이전에 선택한 인덱스
                    _dPreSelectedDate = _dCurSelectedDate; // 그리드에서 이전에 선택한 날짜
                    _nCurSelectedIndex = index; // 그리드에서 현재 선택한 인덱스
                    _dCurSelectedDate = _aGridDate[index]; // 그리드에서 현재 선택한 날짜
                  });
                },
                child: CalendarDay(
                  dDate: DateTime.parse(sFullDate),
                  nGridIndex: index,
                  nPreSelectedIndex: _nPreSelectedIndex,
                  dPreSelectedDate: _dPreSelectedDate,
                  nCurSelectedIndex: _nCurSelectedIndex,
                  dCurSelectedDate: _dCurSelectedDate,
                  sMonthType: "0", // 저번달:"0", 이번달:"1", 다음달:"2"
                  jKorHolidays: "", // 공휴일 api 정보(json String)
                  jScheduleDate: sScheduleJson, // 위젯에 표시할 스케쥴 정보(from-to)
                ),
              );
            } else if (nCurrentMonthDay < _nCurrentMonthDays) {
              // 이번달 일자 표시
              nCurrentMonthDay++;
              sFullDate = _sCurYear +
                  _sCurMonth +
                  nCurrentMonthDay.toString().padLeft(2, "0");
              _aGridDate.add(DateTime.parse(sFullDate)); // 해당 일자를 배열에 add
              // 현재 일자가 공휴일 인지 확인
              int? nKorHolidaysIndex = -1;
              String sKorHolidaysJson = "";
              if (_oKorHolidaysindex.containsKey(sFullDate)) {
                nKorHolidaysIndex = _oKorHolidaysindex[sFullDate];
              }
              if (nKorHolidaysIndex != null && nKorHolidaysIndex > -1) {
                sKorHolidaysJson = jsonEncode(
                    _korHolidayProvider.korHolidays[nKorHolidaysIndex]);
              }
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _isUserSelected = true; // 사용자가 일자를 클릭했는지 여부
                    _nCurMonthSelectedIndex =
                        index; // 그리드뷰에서 이번달에 현재 선택한 인덱스 값(다시 이번달로 돌아왔을 때 포커스 가기 위함)
                    _dCurMonthSelectedDate = _aGridDate[
                        index]; // 그리드뷰에서 이번달에 현재 선택한 날짜(다시 이번달로 돌아왔을 때 포커스 가기 위함)
                    _nPreSelectedIndex =
                        _nCurSelectedIndex; // 그리드에서 이전에 선택한 인덱스
                    _dPreSelectedDate = _dCurSelectedDate; // 그리드에서 이전에 선택한 날짜
                    _nCurSelectedIndex = index; // 그리드에서 현재 선택한 인덱스
                    _dCurSelectedDate = _aGridDate[index]; // 그리드에서 현재 선택한 날짜
                  });
                },
                child: CalendarDay(
                  dDate: DateTime.parse(sFullDate),
                  nGridIndex: index,
                  nPreSelectedIndex: _nPreSelectedIndex,
                  dPreSelectedDate: _dPreSelectedDate,
                  nCurSelectedIndex: _nCurSelectedIndex,
                  dCurSelectedDate: _dCurSelectedDate,
                  sMonthType: "1", // 저번달:"0", 이번달:"1", 다음달:"2"
                  jKorHolidays: sKorHolidaysJson, // 공휴일 api 정보(json String)
                  jScheduleDate: sScheduleJson, // 위젯에 표시할 스케쥴 정보(from-to)
                ),
              );
            } else {
              // 다음달 일자 표시
              nNextMonthDay++;
              sFullDate = _sNextYear +
                  _sNextMonth +
                  nNextMonthDay.toString().padLeft(2, "0");
              _aGridDate.add(DateTime.parse(sFullDate)); // 해당 일자를 배열에 add
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _isUserSelected = true; // 사용자가 일자를 클릭했는지 여부
                    _nCurMonthSelectedIndex =
                        index; // 그리드뷰에서 이번달에 현재 선택한 인덱스 값(다시 이번달로 돌아왔을 때 포커스 가기 위함)
                    _dCurMonthSelectedDate = _aGridDate[
                        index]; // 그리드뷰에서 이번달에 현재 선택한 날짜(다시 이번달로 돌아왔을 때 포커스 가기 위함)
                    _nPreSelectedIndex =
                        _nCurSelectedIndex; // 그리드에서 이전에 선택한 인덱스
                    _dPreSelectedDate = _dCurSelectedDate; // 그리드에서 이전에 선택한 날짜
                    _nCurSelectedIndex = index; // 그리드에서 현재 선택한 인덱스
                    _dCurSelectedDate = _aGridDate[index]; // 그리드에서 현재 선택한 날짜
                  });
                },
                child: CalendarDay(
                  dDate: DateTime.parse(sFullDate),
                  nGridIndex: index,
                  nPreSelectedIndex: _nPreSelectedIndex,
                  dPreSelectedDate: _dPreSelectedDate,
                  nCurSelectedIndex: _nCurSelectedIndex,
                  dCurSelectedDate: _dCurSelectedDate,
                  sMonthType: "2", // 저번달:"0", 이번달:"1", 다음달:"2"
                  jKorHolidays: "", // 공휴일 api 정보(json String)
                  jScheduleDate: sScheduleJson, // 위젯에 표시할 스케쥴 정보(from-to)
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /*
    저번달, 이번달, 다음달의 시작 요일, 달의 전체 일수 정보를 구한다.
   */
  fn_getDayInfo() {
    // 이전달 정보 저장
    if (_oSelectedDate.month == 1) {
      _sPreYear = (_oSelectedDate.year - 1).toString();
      _sPreMonth = "12";
    } else {
      _sPreYear = _oSelectedDate.year.toString();
      _sPreMonth = (_oSelectedDate.month - 1).toString().padLeft(2, "0");
    }
    // 이번달 정보 저장
    _sCurYear = _oSelectedDate.year.toString();
    _sCurMonth = _oSelectedDate.month.toString().padLeft(2, "0");
    // 다음달 정보 저장
    if (_oSelectedDate.month == 12) {
      _sNextYear = (_oSelectedDate.year + 1).toString();
      _sNextMonth = "01";
    } else {
      _sNextYear = _oSelectedDate.year.toString();
      _sNextMonth = (_oSelectedDate.month + 1).toString().padLeft(2, "0");
    }

    // 0 = 일요일, 1 = 월요일, 2 = 화요일, 3 = 수요일, 4 = 목요일, 5 = 금요일, 6 = 토요일
    _nPreviousMonthStartDayOffSet = DateUtils.firstDayOffset(
        int.parse(_sPreYear),
        int.parse(_sPreMonth),
        MaterialLocalizations.of(context)); // 저번달 시작 요일
    _nCurrentMonthStartDayOffSet = DateUtils.firstDayOffset(
        int.parse(_sCurYear),
        int.parse(_sCurMonth),
        MaterialLocalizations.of(context)); // 이번달 시작 요일
    _nNextMonthStartDayOffSet = DateUtils.firstDayOffset(int.parse(_sNextYear),
        int.parse(_sNextMonth), MaterialLocalizations.of(context)); // 다음달 시작 요일

    _nPreviousMonthDays = DateUtils.getDaysInMonth(
        int.parse(_sPreYear), int.parse(_sPreMonth)); // 저번달 총 일수
    _nCurrentMonthDays = DateUtils.getDaysInMonth(
        _oSelectedDate.year, _oSelectedDate.month); // 이번달 총 일수
    _nNextMonthDays = DateUtils.getDaysInMonth(
        int.parse(_sNextYear), int.parse(_sNextMonth)); // 다음달 총 일수

    if (_isUserSelected == false &&
        _oNow.month.toString().padLeft(2, "0") == _sCurMonth) {
      if (_nCurMonthSelectedIndex == -1) {
        // 현재 달과 같은데 사용자가 선택한 날짜가 없었을 경우 오늘 날짜 박스 표시
        _dCurSelectedDate = DateTime.now();
        _nCurSelectedIndex = (_dCurSelectedDate.day - 1);
      } else {
        // 현재 달과 같은데 사용자가 선택한 날짜가 있었을 경우 사용자가 선택한 날짜 박스 표시
        _dCurSelectedDate = _dCurMonthSelectedDate;
        _nCurSelectedIndex = _nCurMonthSelectedIndex;
      }
    } else if (_isUserSelected == false && _oNow.month.toString().padLeft(2, "0") != _sCurMonth) {
      // 다른 달인 경우에는 1일에 박스 표시
      _dCurSelectedDate = DateTime.parse("$_sCurYear${_sCurMonth}01");
      _nCurSelectedIndex = _nCurrentMonthStartDayOffSet;
    }
  }

  /*
    다음달 정보 셋팅
   */
  fn_setPreMonth() {
    String sFullDate = "";
    if (_oSelectedDate.year.toString() != _sPreYear) {
      _isKorHolidayApiCall = true; // 년도가 바뀌면 공휴일 api 호출
    }
    sFullDate = _sPreYear + _sPreMonth + 01.toString().padLeft(2, "0");
    _oSelectedDate = DateTime.parse(sFullDate);

    _nPreSelectedIndex = -1; // 그리드에서 이전에 선택된 인덱스 초기화
    _dPreSelectedDate = DateTime.parse("99991231"); // 그리드에서 이전에 선택된 날짜 초기화
    _nCurSelectedIndex = -1; // 그리드에서 현재 선택된 인덱스 초기화
    _dCurSelectedDate = DateTime.parse("99991231"); // 그리드에서 현재 선택된 날짜 초기화
    _isUserSelected = false; // 사용자가 일자를 클릭했는지 여부
  }

  /*
    이전달 정보 셋팅
   */
  fn_setNextMonth() {
    String sFullDate = "";
    if (_oSelectedDate.year.toString() != _sNextYear) {
      _isKorHolidayApiCall = true; // 년도가 바뀌면 공휴일 api 호출
    }
    sFullDate = _sNextYear + _sNextMonth + 01.toString().padLeft(2, "0");
    _oSelectedDate = DateTime.parse(sFullDate);

    _nPreSelectedIndex = -1; // 그리드에서 이전에 선택된 인덱스 초기화
    _dPreSelectedDate = DateTime.parse("99991231"); // 그리드에서 이전에 선택된 날짜 초기화
    _nCurSelectedIndex = -1; // 그리드에서 현재 선택된 인덱스 초기화
    _dCurSelectedDate = DateTime.parse("99991231"); // 그리드에서 현재 선택된 날짜 초기화
    _isUserSelected = false; // 사용자가 일자를 클릭했는지 여부
  }
}
