import 'package:flutter/material.dart';

class WidgetScheduleTabbar extends StatefulWidget {
  const WidgetScheduleTabbar({super.key});

  @override
  State<WidgetScheduleTabbar> createState() => _WidgetScheduleTabbarState();
}

class _WidgetScheduleTabbarState extends State<WidgetScheduleTabbar>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
    animationDuration: const Duration(milliseconds: 800),
  );
  late ScrollController scrollController = ScrollController();

  int _SelectedTabIndex = 0; // 현재 선택 된 탭 인덱스

  final List<String> entries = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j"
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ScheduleTabbar();
  }

  Widget _ScheduleTabbar() {
    return Column(children: [
      TabBar(
        controller: tabController,
        labelColor: Colors.blue,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
        ),
        overlayColor: const WidgetStatePropertyAll(
          Colors.transparent, // 탭 클릭시 색깔 표시 안함
        ),
        indicatorColor: Colors.blue,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(
            text: "Tab0",
          ),
          Tab(
            text: "Tab1",
          )
        ],
        onTap: (index) {
          setState(() {
            _SelectedTabIndex = index;
            scrollController.animateTo(0.toDouble(),
                duration: const Duration(milliseconds: 500), curve: Curves.ease); // 탭 변경시 스크롤 맨위로 이동
          });
        },
      ),
      if (_SelectedTabIndex == 0) ...[
        // 0번째 탭 표시
        Container(
          height: 30,
          padding: const EdgeInsets.fromLTRB(
              2, 2, 2, 1), // left, top, right, bottom,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(500, 10),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: const Text(
              "일정 추가 하기",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 210,
          child: _ScheduleCutsomList(),
        ),
      ],
      if (_SelectedTabIndex == 1) ...[
        // 1번째 탭 표시
        Container(
          height: 30,
          padding: const EdgeInsets.fromLTRB(
              2, 2, 2, 1), // left, top, right, bottom,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(500, 10),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: const Text(
              "공유 추가 하기",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 210,
          child: _ScheduleCutsomList(),
        ),
      ]
    ]);
  }

  Widget _ScheduleCutsomList() {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            List.generate(
              entries.length,
              (index) => Card(
                color: Colors.white,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 2.0,
                child: InkWell(
                  onTap: () {
                    print(index);
                  },
                  child: Container(
                    height: 70,
                    padding: const EdgeInsets.fromLTRB(
                        10, 10, 10, 2), // left, top, right, bottom,
                    color: Colors.transparent,
                    child:
                        Text("tab $_SelectedTabIndex 순서대로 ${entries[index]}"),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
