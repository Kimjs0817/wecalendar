import 'package:flutter/material.dart';

DateTime gfn_getIndexToDate(context, String pYear, String pMonth, int pIndex) {
  DateTime dReturnDate = DateTime.now(); // 최종 리턴 값

  if (pIndex == -1) {
    // 인덱스가 -1 이 들어오면 9999년 12월 31일 리턴
    dReturnDate = DateTime.parse("99991231");
  } else {
    DateTime dStartDate = DateTime.parse("$pYear${pMonth.padLeft(2, "0")}01"); // 파라미터로 받은 년, 월의 1일의 날짜
    int nStartDayOffSet = DateUtils.firstDayOffset(int.parse(pYear), int.parse(pMonth), MaterialLocalizations.of(context)); // 해당 월의 1일의 인덱스
    int nDiffDate = pIndex - nStartDayOffSet; // 시작 인덱스부터 파라미터로 넘어온 index까지의 경과된 일수
    dReturnDate = DateUtils.addDaysToDate(dStartDate, nDiffDate); // 경과된 일수만큼 더하거나 빼줘서 해당 날짜를 구한다.
  }
  return dReturnDate;
}

int gfn_getDateToIndex(context, String pYear, String pMonth, DateTime pDate) {
  int nReturnIndex = 0;

  if (DateUtils.isSameDay(pDate, DateTime.parse("99991231"))) {
    // 9999년 12월 31일이 들어오면 -1 리턴
    nReturnIndex = -1;
  } else {
    DateTime dStartDate = DateTime.parse("$pYear${pMonth.padLeft(2, "0")}01"); // 파라미터로 받은 년, 월의 1일의 날짜
    int nStartDayOffSet = DateUtils.firstDayOffset(int.parse(pYear), int.parse(pMonth), MaterialLocalizations.of(context)); // 해당 월의 1일의 인덱스
    int nDiffDate = pDate.difference(dStartDate).inDays; // 1일부터 파라미터로 들어온 일까지의 경과된 일수
    nReturnIndex = nStartDayOffSet + nDiffDate; // 경과된 일수만큼 더하거나 빼줘서 해당 인덱스를 구한다.
  }
  return nReturnIndex;
}
