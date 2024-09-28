import 'package:flutter/material.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/employee_views.dart';
import 'package:flutter_staff/models/leaves.dart';
import 'package:flutter_staff/view/Screen/timekeep_page_screen.dart';
import 'package:flutter_staff/view/Screen/leave_page_screen.dart';
import 'package:flutter_staff/view/Screen/salary_page_screen.dart';
import 'package:flutter_staff/view/Widget/boxCountLeave_widget.dart';
import 'package:flutter_staff/view/Screen/setting_page_screen.dart';

class HomePage extends StatefulWidget {
  final String? emp_code;
  final int? emp_id;
  const HomePage({super.key, required this.emp_code, required this.emp_id});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double availableScreenWidth = 0;
  String FullNameView = '';
  EmployeeViewModel? _employeeViewModel;
  CalLeaveModel? Cal_leave_model;
  String year_current = DateFormat('yyyy').format(DateTime.now());
  final ApiServices apiServices = ApiServices();

  int _selectedIndex = 0; // Biến lưu chỉ số tab hiện tại
  void _onItemTapped(int index) async {
    if (index == 1) {
      final result =
          await Navigator.of(context).push<String>(MaterialPageRoute<String>(
              builder: (BuildContext context) => SettingPage(
                    emp_code: widget.emp_code,
                    emp_id: widget.emp_id,
                  )));
      if (result != null) {
        setState(() {
          _selectedIndex = 0;
        });
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> getDataEmpCode(String code) async {
    try {
      _employeeViewModel = await apiServices.fetchInfoEmpCode(code);
      if (_employeeViewModel != null) {
        setState(() {
          FullNameView = _employeeViewModel?.fULLNAME ?? '';
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to fetch employee data: $e');
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> getCalLeave_EmpID(int empId) async {
    //  int id = int.parse(emp_id);
    try {
      var cal_leave = await apiServices.fetchGetCalLeave(empId);
      if (cal_leave != null) {
        setState(() {
          Cal_leave_model = cal_leave;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to fetch calculator leave data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataEmpCode(widget.emp_code.toString());
    getCalLeave_EmpID(widget.emp_id!);
  }

  @override
  Widget build(BuildContext context) {
    availableScreenWidth = MediaQuery.of(context).size.width - 50;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          AppBarHomePage(fullName: FullNameView),
          Expanded(
              child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phép Năm - $year_current",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildBoxCountLeave(
                          title_: 'Tổng',
                          number_:
                              Cal_leave_model?.aNUALLEAVEDAY.toString() ?? '0',
                          colors_: const Color(0xfff62d51).withOpacity(0.8),
                          availableScreenWidth_: availableScreenWidth,
                          with_: .31),
                      const SizedBox(width: 10),
                      buildBoxCountLeave(
                          title_: 'Sử dụng',
                          number_: Cal_leave_model?.tONGCONG.toString() ?? "0",
                          colors_: const Color(0xff55ce63).withOpacity(0.8),
                          availableScreenWidth_: availableScreenWidth,
                          with_: .31),
                      const SizedBox(width: 10),
                      buildBoxCountLeave(
                          title_: "Còn lại",
                          number_: Cal_leave_model?.rEMAIN.toString() ?? "0",
                          colors_: Colors.orange.shade800.withOpacity(0.8),
                          availableScreenWidth_: availableScreenWidth,
                          with_: .31),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Danh Mục",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Tất Cả",
                          style: TextStyle(
                            color: Colors.blue.shade300,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      CategoryCard(
                        thumbnail: 'assets/images/check-in.png',
                        name: 'Chấm công thực tế',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoglistPage(
                                emp_code: widget.emp_code.toString()
                                
                                ),
                          ),
                        ),
                        availableScreenWidth_: availableScreenWidth,
                        width_: 0.47,
                        size: 13,
                      ),
                      const SizedBox(width: 15),
                      CategoryCard(
                        thumbnail: 'assets/images/timepiece.png',
                        name: 'Bảng chấm công',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimekeepPage(
                                  emp_code: widget.emp_code.toString()),
                            ),
                          );
                        },
                        availableScreenWidth_: availableScreenWidth,
                        width_: 0.47,
                        size: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CategoryCard(
                        thumbnail: 'assets/images/cv.png',
                        name: 'Nghỉ phép',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LeavePage(
                                emp_code: widget.emp_code.toString(),
                                emp_id: widget.emp_id!,
                              ),
                            ),
                          );
                        },
                        availableScreenWidth_: availableScreenWidth,
                        width_: 0.47,
                        size: 14,
                      ),
                          const SizedBox(width: 15),
                      CategoryCard(
                        thumbnail: 'assets/images/calendar.png',
                        name: 'Phiếu lương',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SalaryPage(
                                  emp_code: widget.emp_code.toString()),
                            ),
                          );
                        },
                        availableScreenWidth_: availableScreenWidth,
                        width_: 0.47,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // selectedItemColor: kPrimaryColor,
        backgroundColor: Colors.white,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
              size: 24,
              color: _selectedIndex == 0 ? const Color(0xff886ff2) : null,
            ),
            icon: const Icon(
              Icons.home,
              size: 24,
            ),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.settings,
              size: 24,
              color: _selectedIndex == 1 ? const Color(0xff886ff2) : null,
            ),
            icon: const Icon(
              Icons.settings,
              size: 24,
            ),
            label: "Cài đặt",
          ),
        ],
        currentIndex: _selectedIndex, // Chỉ số tab hiện tại
        onTap: _onItemTapped,
      ),
    );
  }

  Column buildFileColumn(String img, String filename, String extension) {
    return Column(
      children: [
        Container(
          width: availableScreenWidth * .31,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.0)),
          padding: const EdgeInsets.all(38),
          height: 110,
          child: Image.asset('assets/images/$img'),
        ),
        const SizedBox(
          height: 15,
        ),
        RichText(
            text: TextSpan(
          text: filename,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: extension,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        )),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String thumbnail;
  final String name;
  final VoidCallback onTap;
  final double width_;
  final double availableScreenWidth_ ;
  final double? size;
  const CategoryCard({
    Key? key,
    required this.thumbnail,
    required this.name,
    required this.onTap, required this.width_, required this.availableScreenWidth_, required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width:  availableScreenWidth_ * width_,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: .05,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                thumbnail,
                height: 100,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: size),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

