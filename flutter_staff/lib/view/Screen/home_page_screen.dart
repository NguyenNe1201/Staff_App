import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/employees.dart';
import 'package:flutter_staff/models/leaves.dart';
import 'package:flutter_staff/view/Screen/timekeep_page_screen.dart';
import 'package:flutter_staff/view/Screen/leave_page_screen.dart';
import 'package:flutter_staff/view/Screen/salary_page_screen.dart';
import 'package:flutter_staff/view/Widget/boxCountLeave_widget.dart';
import 'package:flutter_staff/view/Screen/setting_page_screen.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_staff/config/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staff/view/Screen/appLifecycle.dart';

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
              builder: (BuildContext context) => AppLifecycle(
                      child: SettingPage(
                    emp_code: widget.emp_code,
                    emp_id: widget.emp_id,
                  ))));
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
    String annualLeave = AppLocalizations.of(context)!.annualLeave;
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
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
                        "$annualLeave - $year_current",
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
                          title_: AppLocalizations.of(context)!.total,
                          number_:
                              Cal_leave_model?.aNUALLEAVEDAY.toString() ?? '0',
                          colors_: const Color(0xfff62d51).withOpacity(0.8),
                          availableScreenWidth_: availableScreenWidth,
                          with_: .31),
                      const SizedBox(width: 10),
                      buildBoxCountLeave(
                          title_: AppLocalizations.of(context)!.used,
                          number_: Cal_leave_model?.tONGCONG.toString() ?? "0",
                          colors_: const Color(0xff55ce63).withOpacity(0.8),
                          availableScreenWidth_: availableScreenWidth,
                          with_: .31),
                      const SizedBox(width: 10),
                      buildBoxCountLeave(
                          title_: AppLocalizations.of(context)!.remain,
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
                      Text(
                        AppLocalizations.of(context)!.category,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of(context)!.all,
                          style: TextStyle(
                            color: Colors.blue.shade300,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 100,
                    child: Row(
                      // scrollDirection: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildCategoryRow(
                            AppLocalizations.of(context)!.salarySlip,
                            "",
                            'assets/images/calendar.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppLifecycle(
                                  child: SalaryPage(
                                      emp_code: widget.emp_code.toString())),
                            ),
                          );
                        }),
                        const SizedBox(width: 15),
                        buildCategoryRow(AppLocalizations.of(context)!.onLeave,
                            "", 'assets/images/application.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppLifecycle(
                                  child: LeavePage(
                                      emp_code: widget.emp_code.toString(),
                                      emp_id: widget.emp_id!)),
                            ),
                          );
                        }),
                        const SizedBox(width: 15),
                        buildCategoryRow(
                            AppLocalizations.of(context)!.checkInOut,
                            "",
                            'assets/images/check-in.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppLifecycle(
                                  child: LoglistPage(
                                      emp_code: widget.emp_code.toString())),
                            ),
                          );
                        }),
                        const SizedBox(width: 15),
                        buildCategoryRow(
                            AppLocalizations.of(context)!.timesheet,
                            AppLocalizations.of(context)!.month,
                            'assets/images/schedule.png', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppLifecycle(
                                  child: TimekeepPage(
                                      emp_code: widget.emp_code.toString())),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 300,
                    child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.05),
                                    blurRadius: 4.0,
                                    spreadRadius: .05,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                child: Image.asset(
                                  'assets/images/bg_home.jpg',
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Text(
                            //   'Giải quyết công việc',
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w700,
                            //   ),
                            // )
                          ],
                        )),
                  )
                  // Row(
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Column(
                  //           children: [
                  //             Container(
                  //               width: 50,
                  //               height: 50,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius:
                  //                     BorderRadius.all(Radius.circular(10)),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.black.withOpacity(.1),
                  //                     blurRadius: 4.0,
                  //                     spreadRadius: .05,
                  //                   )
                  //                 ],
                  //               ),
                  //               child: Icon(
                  //                 Iconsax.finger_scan_copy,
                  //                 size: 40,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //             SizedBox(height: 10),
                  //             Text('Chấm Công'),
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //     SizedBox(width: 10),
                  //     Row(
                  //       children: [
                  //         Column(
                  //           children: [
                  //             Container(
                  //               width: 50,
                  //               height: 50,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius:
                  //                     BorderRadius.all(Radius.circular(10)),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.black.withOpacity(.1),
                  //                     blurRadius: 4.0,
                  //                     spreadRadius: .05,
                  //                   )
                  //                 ],
                  //               ),
                  //               child: Icon(
                  //                 Iconsax.clock_copy,
                  //                 size: 40,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //             SizedBox(height: 10),
                  //             Text('Giờ vào-ra'),
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //     SizedBox(width: 10),
                  //     Row(
                  //       children: [
                  //         Column(
                  //           children: [
                  //             Container(
                  //               width: 50,
                  //               height: 50,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius:
                  //                     BorderRadius.all(Radius.circular(10)),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.black.withOpacity(.1),
                  //                     blurRadius: 4.0,
                  //                     spreadRadius: .05,
                  //                   )
                  //                 ],
                  //               ),
                  //               child:Align(
                  //                 alignment: Alignment.center,
                  //                 child: Image.asset(
                  //                   'assets/images/calendar_slr.png',
                  //                   height: 30,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(height: 10),
                  //             Text('Nghỉ Phép'),
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //     SizedBox(width: 10),
                  //     Row(
                  //       children: [
                  //         Column(
                  //           children: [
                  //             Container(
                  //               width: 50,
                  //               height: 50,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius:
                  //                     BorderRadius.all(Radius.circular(10)),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.black.withOpacity(.1),
                  //                     blurRadius: 4.0,
                  //                     spreadRadius: .05,
                  //                   )
                  //                 ],
                  //               ),
                  //               child: Align(
                  //                 alignment: Alignment.center,
                  //                 child: Image.asset(
                  //                   'assets/images/calendar_slr.png',
                  //                   height: 30,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(height: 10),
                  //             Text('Phiếu lương'),
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ],
                  // )
                  // ========  Category cũ ====================
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CategoryCard(
                  //       thumbnail: 'assets/images/check-in.png',
                  //       name: 'Chấm công thực tế',
                  //       onTap: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => LoglistPage(
                  //               emp_code: widget.emp_code.toString()

                  //               ),
                  //         ),
                  //       ),
                  //       availableScreenWidth_: availableScreenWidth,
                  //       width_: 0.47,
                  //       size: 13,
                  //     ),
                  //     const SizedBox(width: 15),
                  //     CategoryCard(
                  //       thumbnail: 'assets/images/timepiece.png',
                  //       name: 'Bảng chấm công',
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => TimekeepPage(
                  //                 emp_code: widget.emp_code.toString()),
                  //           ),
                  //         );
                  //       },
                  //       availableScreenWidth_: availableScreenWidth,
                  //       width_: 0.47,
                  //       size: 14,
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 15),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CategoryCard(
                  //       thumbnail: 'assets/images/cv.png',
                  //       name: 'Nghỉ phép',
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => LeavePage(
                  //               emp_code: widget.emp_code.toString(),
                  //               emp_id: widget.emp_id!,
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //       availableScreenWidth_: availableScreenWidth,
                  //       width_: 0.47,
                  //       size: 14,
                  //     ),
                  //         const SizedBox(width: 15),
                  //     CategoryCard(
                  //       thumbnail: 'assets/images/calendar.png',
                  //       name: 'Phiếu lương',
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => SalaryPage(
                  //                 emp_code: widget.emp_code.toString()),
                  //           ),
                  //         );
                  //       },
                  //       availableScreenWidth_: availableScreenWidth,
                  //       width_: 0.47,
                  //       size: 14,
                  //     ),
                  //   ],
                  // ),
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
              color: _selectedIndex == 0 ? Palette.btnColor : null,
            ),
            icon: const Icon(
              Icons.home,
              size: 24,
            ),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.settings,
              size: 24,
              color: _selectedIndex == 1 ? Palette.btnColor : null,
            ),
            icon: const Icon(
              Icons.settings,
              size: 24,
            ),
            label: AppLocalizations.of(context)!.setting,
          ),
        ],
        currentIndex: _selectedIndex, // Chỉ số tab hiện tại
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildCategoryRow(
      String title1, String? title2, String thumbnail, VoidCallback onTap_) {
    return GestureDetector(
      onTap: onTap_,
      child: Center(
        child: Column(
          children: [
            // Container(
            //   width: 70,
            //   height: 70,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(.1),
            //         blurRadius: 4.0,
            //         spreadRadius: .05,
            //       )
            //     ],
            //   ),
            //   child:
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                thumbnail,
                height: 50,
              ),
            ),
            //  ),
            const SizedBox(height: 10),
            Text(title1,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.grey.shade800)),
            Text(title2 ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.grey.shade800)),
          ],
        ),
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
  final double availableScreenWidth_;
  final double? size;
  const CategoryCard({
    Key? key,
    required this.thumbnail,
    required this.name,
    required this.onTap,
    required this.width_,
    required this.availableScreenWidth_,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: availableScreenWidth_ * width_,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
