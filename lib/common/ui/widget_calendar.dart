import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wecalendar/common/function/common_function.dart';
import 'package:wecalendar/common/providers/kor_holiday_provider.dart';

import 'package:wecalendar/common/ui/widget_calendar_day.dart';
import 'package:wecalendar/service/ui/calendar_screen_list.dart';

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
  int _nPreYear = 0, _nPreMonth = 0;
  int _nCurYear = 0, _nCurMonth = 0;
  int _nNextYear = 0, _nNextMonth = 0;

  // 화면에 박스 표시 될 날짜(from-to)
  final Map<String, dynamic> _oUserSelectedDate = {};
  // 화면에 박스 표시 될 날짜(from-to)(스케쥴데이터)
  final Map<String, dynamic> _oUserScheduleDate = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _oUserSelectedDate['from'] = DateTime.parse("99991231");
    _oUserSelectedDate['to'] = DateTime.parse("99991231");
    _oUserScheduleDate['from'] = DateTime.parse("99991231");
    _oUserScheduleDate['to'] = DateTime.parse("99991231");
  }

  @override
  Widget build(BuildContext context) {
    // 이번달 정보 저장
    _nCurYear = _oSelectedDate.year;
    _nCurMonth = _oSelectedDate.month;
    // 이전달 정보 저장
    _nPreYear = DateUtils.addMonthsToMonthDate(_oSelectedDate, -1).year;
    _nPreMonth = DateUtils.addMonthsToMonthDate(_oSelectedDate, -1).month;
    // 다음달 정보 저장
    _nNextYear = DateUtils.addMonthsToMonthDate(_oSelectedDate, 1).year;
    _nNextMonth = DateUtils.addMonthsToMonthDate(_oSelectedDate, 1).month;

    debugPrint('----------------------------------------------------------------');
    debugPrint('_nCurYear $_nCurYear');
    debugPrint('_nCurMonth $_nCurMonth');
    debugPrint('_nPreYear $_nPreYear');
    debugPrint('_nPreMonth $_nPreMonth');
    debugPrint('_nNextYear $_nNextYear');
    debugPrint('_nNextMonth $_nNextMonth');
    debugPrint('_oUserSelectedDate["from"] ${_oUserSelectedDate['from']}');
    debugPrint('_oUserSelectedDate["to"] ${_oUserSelectedDate['to']}');
    debugPrint('_oUserScheduleDate["from"] ${_oUserScheduleDate['from']}');
    debugPrint('_oUserScheduleDate["to"] ${_oUserScheduleDate['to']}');
    debugPrint('----------------------------------------------------------------');

    // 공휴일 api 호출
    if (_isKorHolidayApiCall) {
      _korHolidayProvider = Provider.of<KorHolidayProvider>(context, listen: false);
      _korHolidayProvider.loadKorHolidays(_nCurYear.toString(), _nCurMonth.toString());

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
          // '<' 버튼
          onPressed: () {
            setState(() {
              fn_setPreMonth(); // 이전달 변경
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
              '${_oSelectedDate.year}. ${_oSelectedDate.month.toString().padLeft(2, "0")}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
                color: Colors.black,
              ),
            ),
          ),
        ),
        IconButton(
          // '>' 버튼
          onPressed: () {
            setState(() {
              fn_setNextMonth(); // 다음달 변경
            });
          },
          icon: const Icon(
            Icons.navigate_next,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              // 초기화
              _oUserSelectedDate['from'] = DateTime.parse("99991231");
              _oUserSelectedDate['to'] = DateTime.parse("99991231");
            });
          },
          icon: const Icon(
            Icons.history,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const CalendarScreenList(),
                ),
              );
            });
          },
          icon: const Icon(
            Icons.view_list,
          ),
        ),
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
                          // '취소' 버튼
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
                          // '확인' 버튼
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
    var sDragDx = '';

    ////////////////////////////////////////////// 테스트 ///////////////////////////////////////////////
    _oUserScheduleDate['from'] = DateTime.parse("20241014");
    _oUserScheduleDate['to'] = DateTime.parse("20241022");
    
    // 공휴일 List 인덱스 정보를 Map 형식으로 저장한다.
    Map<String, int> _oKorHolidaysindex = {};
    for (var i = 0; i < _korHolidayProvider.korHolidays.length; i++) {
      _oKorHolidaysindex[_korHolidayProvider.korHolidays[i].locdate] = i; // ex) key:20240101, value:0
    }

    return Expanded(
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 0) {
            sDragDx = 'R'; // 오른쪽 스와이프
          } else {
            sDragDx = 'L'; // 왼쪽 스와이프
          }
        },
        onPanEnd: (DragEndDetails detail) {
          if (sDragDx == 'R') {
            setState(() {
              fn_setPreMonth(); // 이전달 변경
            });
          } else {
            setState(() {
              fn_setNextMonth(); // 다음달 변경
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
                  fn_setUserSelectedDate(index); // 사용자 일자 선택 저장
                });
              },
              child: CalendarDay(
                nCurYear: _nCurYear,
                nCurMonth: _nCurMonth,
                nGridIndex: index,
                dSelectedFromDate: _oUserSelectedDate['from'],
                dSelectedToDate: _oUserSelectedDate['to'],
                dScheduleFromDate: _oUserScheduleDate['from'],
                dScheduleToDate: _oUserScheduleDate['to'],
                jKorHolidays: '', // 공휴일 api 정보(json String)
              ),
            );
          },
        ),
      ),
    );
  }

  void fn_setUserSelectedDate(int pnIndex) {
    // 사용자 일자 선택 저장
    DateTime dSelectedDate = gfn_getIndexToDate(context, _nCurYear.toString(), _nCurMonth.toString(), pnIndex);
    if (_oUserSelectedDate['from'] == DateTime.parse("99991231") && _oUserSelectedDate['to'] == DateTime.parse("99991231")) {
      // 초기 선택 했을 때, from to 셋팅
      _oUserSelectedDate['from'] = dSelectedDate;
      _oUserSelectedDate['to'] = dSelectedDate;
    } else if (dSelectedDate.isBefore(_oUserSelectedDate['from'])) {
      _oUserSelectedDate['from'] = dSelectedDate;
    } else if (_oUserSelectedDate['from'] == dSelectedDate ||
        _oUserSelectedDate['to'] == dSelectedDate ||
        dSelectedDate.isAfter(_oUserSelectedDate['from']) && dSelectedDate.isBefore(_oUserSelectedDate['to'])) {
      // from && to && 그 사이 일자를 선택 했을 경우 초기화
      _oUserSelectedDate['from'] = DateTime.parse("99991231");
      _oUserSelectedDate['to'] = DateTime.parse("99991231");
    } else {
      _oUserSelectedDate['to'] = dSelectedDate;
    }
  }

  void fn_setPreMonth() {
    // 이전달 변경
    if (_oSelectedDate.year != _nPreYear) {
      _isKorHolidayApiCall = true; // 년도가 바뀌면 공휴일 api 호출
    }
    _oSelectedDate = DateUtils.addMonthsToMonthDate(_oSelectedDate, -1);
  }

  void fn_setNextMonth() {
    // 다음달 변경
    if (_oSelectedDate.year != _nNextYear) {
      _isKorHolidayApiCall = true; // 년도가 바뀌면 공휴일 api 호출
    }
    _oSelectedDate = DateUtils.addMonthsToMonthDate(_oSelectedDate, 1);
  }
}
