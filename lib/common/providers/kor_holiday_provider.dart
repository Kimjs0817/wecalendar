import 'package:flutter/material.dart';

import 'package:wecalendar/common/models/kor_holiday.dart';
import 'package:wecalendar/repository/kor_holiday_repository.dart';

class KorHolidayProvider extends ChangeNotifier {
  // KorHolidayRepository를 접근(데이터를 받아와야 하기 때문에)
  KorHolidayRepository _korHolidayRepository = KorHolidayRepository();

  List<KorHoliday> _korHolidays = [];
  List<KorHoliday> get korHolidays => _korHolidays;

  // 데이터 로드
  loadKorHolidays(String pYear, String pMonth) async {
    List<KorHoliday>? listKorHolidays = await _korHolidayRepository.loadKorHoliday(pYear, pMonth);
    _korHolidays = listKorHolidays!;
    notifyListeners(); // 데이터가 업데이트가 됐으면 구독자에게 알린다.
  }
}
