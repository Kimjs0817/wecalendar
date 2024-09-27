import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import 'package:wecalendar/common/models/kor_holiday.dart';

class KorHolidayRepository {
  final _EncodingApikey =
      "%2Bna2kpEXKer38hsVYVAH3ydp%2FaeCcqkSBCyDcSTc6Xb%2BzjP4mlBw6wlus4rNuf0iJUcf7O2uVdnXJXX%2BLRbnkg%3D%3D";
  final _DecodingApikey =
      "+na2kpEXKer38hsVYVAH3ydp/aeCcqkSBCyDcSTc6Xb+zjP4mlBw6wlus4rNuf0iJUcf7O2uVdnXJXX+LRbnkg==";

  Future<List<KorHoliday>?> loadKorHoliday(String pYear, String pMonth) async {
    var sYear = pYear;
    var sMonth = pMonth;

    var baseUrl =
        "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo?serviceKey=$_EncodingApikey&numOfRows=100&solYear=$sYear";

    final response = await http.get(Uri.parse(baseUrl));

    // 정상 응답 수신
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      // 데이터 저장
      final body = convert.utf8.decode(response.bodyBytes);

      // xml -> json 변환
      final xml = Xml2Json()..parse(body);
      final json = xml.toParker();

      // 수신 데이터 확인
      Map<String, dynamic> jsonResult = convert.json.decode(json);
      final jsonKorHoliday = jsonResult['response']['body']['items'];

      // 수신 데이터 존재
      if (jsonKorHoliday['item'] != null) {
        // map을 통해 데이터를 전달 하기 위해 객체인 List로 만든다.
        List<dynamic> list = jsonKorHoliday['item'];

        //List.generate(list.length, (index) => print(list[index]));

        print("getApi");

        // KorHoliday.fromJson으로 전달
        return list.map<KorHoliday>((item) => KorHoliday.fromJson(item)).toList();
      }
    }
  }
}
