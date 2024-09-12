import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/employee_views.dart';
import 'package:flutter_staff/models/leaves.dart';
import 'package:flutter_staff/view/Public/dataQuery_page_screen.dart';
import 'package:flutter_staff/view/Screen/leave_page_screen.dart';
import 'package:flutter_staff/view/Screen/salary_page_screen.dart';
import 'package:flutter_staff/view/Widget/boxCountLeave_widget.dart';
import 'package:flutter_staff/view/Screen/setting_page_screen.dart';
import 'package:flutter_staff/view/Widget/fileSizeChart_widget.dart';

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
      print('Failed to fetch employee data: $e');
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
          AppBar(fullName: FullNameView),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phép - 2024",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildBoxCountLeave(
                  title_: 'Tổng',
                  number_: Cal_leave_model?.aNUALLEAVEDAY.toString() ?? '',
                  colors_: const Color(0xfff62d51).withOpacity(0.8),
                  availableScreenWidth_: availableScreenWidth,
                  with_: .31),
              const SizedBox(width: 10),
              buildBoxCountLeave(
                  title_: 'Sử dụng',
                  number_: Cal_leave_model?.tONGCONG.toString() ?? "",
                  colors_: const Color(0xff55ce63).withOpacity(0.8),
                  availableScreenWidth_: availableScreenWidth,
                  with_: .31),
              const SizedBox(width: 10),
              buildBoxCountLeave(
                  title_: "Còn lại",
                  number_: Cal_leave_model?.rEMAIN.toString() ?? "",
                  colors_: Colors.orange.shade800.withOpacity(0.8),
                  availableScreenWidth_: availableScreenWidth,
                  with_: .31),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
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
          ),
          Expanded(
            child: GridView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 20,
                mainAxisSpacing: 24,
              ),
              children: [
                CategoryCard(
                  thumbnail: 'assets/images/check-in.png',
                  name: 'Check-in/out',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LoglistPage(emp_code: widget.emp_code.toString()),
                    ),
                  ),
                ),
                CategoryCard(
                  thumbnail: 'assets/images/timepiece.png',
                  name: 'Timekeeping',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TimekeepPage(emp_code: widget.emp_code.toString()),
                      ),
                    );
                  },
                ),
                CategoryCard(
                  thumbnail: 'assets/images/cv.png',
                  name: 'Leave Staff',
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
                ),
                CategoryCard(
                  thumbnail: 'assets/images/calendar.png',
                  name: 'Salary',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SalaryPage(emp_code: widget.emp_code.toString()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
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

  const CategoryCard({
    Key? key,
    required this.thumbnail,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
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
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  final String fullName;
  const AppBar({
    Key? key,
    required this.fullName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      height: 140,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5],
          colors: [
            Color(0xff886ff2),
            Color(0xff6849ef),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello,\n $fullName",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff8a72f1),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
