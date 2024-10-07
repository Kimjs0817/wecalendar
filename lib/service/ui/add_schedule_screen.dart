import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> with SingleTickerProviderStateMixin {
  DateTime _dSelectedDate = DateTime.now();

  String _sSelectedFromDate = '', _sSelectedToDate = '';
  String _sSelectedFromTime = '', _sSelectedToTime = '';
  bool _isAllTimeChecked = true;

  late AnimationController _selectedAnimationController; // 애니메이션 관련 컨트롤러
  late Animation<double> _allTimeSelectedAnimation; // "종일" 체크박스 선택 시 시간표시 관련 애니메이션

  bool _isScheduleSharedList01 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _allTimeSelectedAnimation = CurvedAnimation(
      parent: _selectedAnimationController,
      curve: Curves.easeIn,
    );
    _allTimeSelectedAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _selectedAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _sSelectedFromDate = DateFormat('yy년 MM월 dd일').format(DateTime.now());
    _sSelectedToDate = DateFormat('yy년 MM월 dd일').format(DateTime.now());
    _sSelectedFromTime = DateFormat.Hm().format(DateTime.now());
    _sSelectedToTime = DateFormat.Hm().format(DateTime.now());

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, // 스크롤시 appBar color 색상이 바뀌지 않게 하기 위함
          scrolledUnderElevation: 0, // 스크롤시 appBar color 색상이 바뀌지 않게 하기 위함
          title: Text("Calendar"),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              ////////////////////////////////////////////// Column 00 //////////////////////////////////////////////
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10), // left, top, right, bottom,
                    child: Text(
                      "일정 제목",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ////////////////////////////////////////////// Column 01 //////////////////////////////////////////////
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10), // left, top, right, bottom,
                    child: Text(
                      "일자",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ////////////////////////////////////////////// Column 02 //////////////////////////////////////////////
              Container(
                height: 30.h,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), // left, top, right, bottom,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          _sSelectedFromDate,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), // left, top, right, bottom
                      child: Text(
                        '~',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          _sSelectedToDate,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ////////////////////////////////////////////// Column 03 //////////////////////////////////////////////
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0), // left, top, right, bottom
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "시간",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "종일",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Checkbox(
                          value: _isAllTimeChecked,
                          onChanged: (value) {
                            setState(() {
                              _isAllTimeChecked = value!;
                              if (_isAllTimeChecked) {
                                _selectedAnimationController.reverse();
                              } else {
                                _selectedAnimationController.forward();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ////////////////////////////////////////////// Column 04 //////////////////////////////////////////////
              Container(
                height: _allTimeSelectedAnimation.value * 30.h, // 체크박스 체크 시, 애니메이션 동작
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), // left, top, right, bottom,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          _sSelectedFromTime,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), // left, top, right, bottom
                      child: Text(
                        '~',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          _sSelectedToTime,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ////////////////////////////////////////////// Column 05 //////////////////////////////////////////////
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0), // left, top, right, bottom
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "약속 공유",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isScheduleSharedList01 = !_isScheduleSharedList01;
                        });
                      },
                      icon: Icon(
                        _isScheduleSharedList01 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              ////////////////////////////////////////////// Column 06 //////////////////////////////////////////////
              ////////////////////////////////////////////// Column 07 //////////////////////////////////////////////
              ////////////////////////////////////////////// Column 08 //////////////////////////////////////////////
              ////////////////////////////////////////////// Column 09 //////////////////////////////////////////////
            ],
          ),
        ));
  }
}
