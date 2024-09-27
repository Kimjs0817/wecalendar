import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:wecalendar/common/providers/kor_holiday_provider.dart';

import 'package:wecalendar/service/ui/calendar_day.dart';
import 'package:wecalendar/service/ui/calendar_add_schedule.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
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

  int _nSelectedIndex = -1; // 그리드뷰에서 클릭한 인덱스 값

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

    // 공휴일 api 호출
    if (_isKorHolidayApiCall) {
      _korHolidayProvider =
          Provider.of<KorHolidayProvider>(context, listen: false);
      _korHolidayProvider.loadKorHolidays(_sCurYear, _sCurMonth);

      _isKorHolidayApiCall = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          CalendarTitleText(),
          const SizedBox(
            height: 10,
          ),
          CalendarWeekText(), // 요일 텍스트 표시
          const SizedBox(
            height: 10,
          ),
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
          CalendarSchedule(), // 내 일정 표시
        ],
      ),
    );
  }

  Widget CalendarTitleText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ),
        ),
        IconButton(
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
              height: 300,
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          child: const Text('취소'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        CupertinoButton(
                          child: const Text('확인'),
                          onPressed: () {
                            Navigator.of(context).pop(_oTempSelectedDate);
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 230,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: const Text('일'),
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: const Text('월'),
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: const Text('화'),
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: const Text('수'),
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: const Text('목'),
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: const Text('금'),
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: const Text('토'),
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

    return Container(
      child: Expanded(
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
                _nSelectedIndex = -1; // 그리드에서 선택된 인덱스 초기화
                fn_setPreMonth();
              });
            } else {
              // 왼쪽 스와이프 시 다음달 표시
              setState(() {
                _nSelectedIndex = -1; // 그리드에서 선택된 인덱스 초기화
                fn_setNextMonth();
              });
            }
          },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisSpacing: 0, crossAxisSpacing: 0),
            itemCount: 35,
            itemBuilder: (context, index) {
              if (index < _nCurrentMonthStartDayOffSet) {
                // 이전달 일자 표시
                nPreviousMonthDay = ((_nPreviousMonthDays + 1) -
                    (_nCurrentMonthStartDayOffSet - index));
                sFullDate = _sPreYear +
                    _sPreMonth +
                    nPreviousMonthDay.toString().padLeft(2, "0");
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      fn_setPreMonth(); // 이전달 표시
                      _nSelectedIndex = index;
                    });
                  },
                  child: CalendarDay(
                    dDate: DateTime.parse(sFullDate),
                    nGridIndex: index,
                    nSelectedIndex: _nSelectedIndex,
                    sMonthType: "0", // 저번달:"0", 이번달:"1", 다음달:"2"
                    jKorHolidays: "", // 공휴일 api 정보(json String)
                  ),
                );
              } else if (nCurrentMonthDay < _nCurrentMonthDays) {
                // 이번달 일자 표시
                nCurrentMonthDay++;
                sFullDate = _sCurYear +
                    _sCurMonth +
                    nCurrentMonthDay.toString().padLeft(2, "0");

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
                      _nSelectedIndex = index;
                    });
                  },
                  child: CalendarDay(
                    dDate: DateTime.parse(sFullDate),
                    nGridIndex: index,
                    nSelectedIndex: _nSelectedIndex,
                    sMonthType: "1", // 저번달:"0", 이번달:"1", 다음달:"2"
                    jKorHolidays: sKorHolidaysJson, // 공휴일 api 정보(json String)
                  ),
                );
              } else {
                // 다음달 일자 표시
                nNextMonthDay++;
                sFullDate = _sNextYear +
                    _sNextMonth +
                    nNextMonthDay.toString().padLeft(2, "0");
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      fn_setNextMonth(); // 다음달 표시
                      _nSelectedIndex = index;
                    });
                  },
                  child: CalendarDay(
                    dDate: DateTime.parse(sFullDate),
                    nGridIndex: index,
                    nSelectedIndex: _nSelectedIndex,
                    sMonthType: "2", // 저번달:"0", 이번달:"1", 다음달:"2"
                    jKorHolidays: "", // 공휴일 api 정보(json String)
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget CalendarSchedule() {
    return Container(
      height: 360,
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
                height: 30,
                margin: const EdgeInsets.fromLTRB(
                    30, 30, 30, 30), // left, top, right, bottom
                child: const Text(
                  "내 일정",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
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
  }
}
