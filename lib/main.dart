import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'package:wecalendar/common/providers/kor_holiday_provider.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:wecalendar/common/ui/main_tap_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ko', ''),
        ],
        theme: ThemeData(
          fontFamily: GoogleFonts.nanumGothic().fontFamily,
        ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (BuildContext context) => KorHolidayProvider())
          ],
          child: const MainTapView(),
        ));
  }
}
