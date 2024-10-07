import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wecalendar/common/ui/bottom_navigation_list.dart';
import 'package:wecalendar/service/ui/calendar_screen_list.dart';
import 'package:wecalendar/service/ui/calendar_screen.dart';

class MainTapView extends StatefulWidget {
  const MainTapView({super.key});

  @override
  State<MainTapView> createState() => _MainTapViewState();
}

class _MainTapViewState extends State<MainTapView>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: navItems.length, vsync: this);
    _tabController.addListener(tabListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      _index = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle( // 선택된 탭의 텍스트 스타일
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
        unselectedLabelStyle: TextStyle( // 선택되지 않은 탭의 텍스트 스타일
          fontSize: 12.sp,
        ),
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        onTap: (int index) {
          _tabController.animateTo(index);
        },
        currentIndex: _index,
        items: navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(
                _index == item.index ? item.activeIcon : item.inactiveIcon,),
            label: item.label,
          );
        }).toList(),
      ),
      body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            CalendarScreen(),
            CalendarScreenList(), // 임시
            CalendarScreenList(), // 임시
          ]),
    );
  }
}
