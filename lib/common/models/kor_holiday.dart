class KorHoliday {
  late String locdate; // 날짜
  late String seq; // 순번
  late String dateKind; // 특일정보의 분류(02: 기념일)
  late String isHoliday; // 공공기관 휴일여부
  late String dateName; // 명칭

  KorHoliday({
    required this.locdate,
    required this.seq,
    required this.dateKind,
    required this.isHoliday,
    required this.dateName,
  });

  factory KorHoliday.fromJson(Map<String, dynamic> json) {
    return KorHoliday(
      locdate: json["locdate"] as String,
      seq: json["seq"] as String,
      dateKind: json["dateKind"] as String,
      isHoliday: json["isHoliday"] as String,
      dateName: json["dateName"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locdate':locdate,
      'seq':seq,
      'dateKind':dateKind,
      'isHoliday':isHoliday,
      'dateName':dateName,
    };
  }
}
