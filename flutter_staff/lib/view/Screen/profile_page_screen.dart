import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/employees.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';

class ProfilePage extends StatefulWidget {
  final String? emp_code;
  final int? emp_id;
  const ProfilePage({super.key, this.emp_code, this.emp_id});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  EmployeeViewModel? _employeeViewModel;
  String birdthdayEmp="";
  final ApiServices apiServices = ApiServices();

  Future<void> getDataEmpCode(String code) async {
    try {
      _employeeViewModel = await apiServices.fetchInfoEmpCode(code);
      if (_employeeViewModel != null) {
        setState(() {
          birdthdayEmp = DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(_employeeViewModel!.dATEOFBIRTH!));
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const AppBarForm(title_: 'Trang Cá Nhân',width_: 100,icon_: Icons.contact_support_outlined),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            height: 80,
                            width: 80,
                            child: CircleAvatar(
                              backgroundImage:
                                  Image.asset('assets/images/user-1.jpg').image,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Thay đổi ảnh đại diện',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 171, 105, 209),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // details
                    const SizedBox(height: 10),
                    const Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Thông tin nhân viên",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 10),

                    TProfileMenu(
                      onPressed: () {},
                      title: 'Họ tên',
                      value: _employeeViewModel?.fULLNAME ?? "",
                    ),
                    TProfileMenu(
                      onPressed: () {},
                      title: 'Username',
                      value: _employeeViewModel?.uSERNAME ?? "",
                    ),

                    const SizedBox(height: 10),
                    const Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Thôn tin nhân viên",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 10),

                    TProfileMenu(
                      onPressed: () {},
                      title: 'Mã NV',
                      value: _employeeViewModel?.eMPCODE ?? "",
                    ),
                    TProfileMenu(
                      onPressed: () {},
                      title: 'E-mail',
                      value: _employeeViewModel?.eMAIL ?? "",
                    ),
                    TProfileMenu(
                      onPressed: () {},
                      title: 'SDT',
                      value: _employeeViewModel?.pHONENUMBER ?? "",
                    ),
                    TProfileMenu(
                      onPressed: () {},
                      title: 'Giới tính',
                      value:_employeeViewModel?.sEX ?? "",
                    ),
                    TProfileMenu(
                      onPressed: () {},
                      title: 'Ngày sinh',
                      value: birdthdayEmp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TProfileMenu extends StatelessWidget {
  final VoidCallback onPressed;
  // final IconData icon;
  final String title, value;
  const TProfileMenu({
    super.key,
    required this.onPressed,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Ionicons.chevron_forward_outline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
