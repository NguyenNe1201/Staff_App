import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/view/Screen/login_page_screen.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staff/view/Widget/button_widget.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:flutter_staff/view/Screen/profile_page_screen.dart';
import 'package:flutter_staff/models/employee_views.dart';

class SettingPage extends StatefulWidget {
  final String? emp_code;
  final int? emp_id;
  const SettingPage({super.key, this.emp_code, this.emp_id});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkMode = false;
  String FullNameView = '';
  EmployeeViewModel? _employeeViewModel;
  final ApiServices apiServices = ApiServices();

  Future<void> getDataEmpCode(String code) async {
    try {
      var result = await apiServices.fetchInfoEmpCode(code);
      if (result != null) {
        setState(() {
          _employeeViewModel = result;
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
        const AppBarForm(title_: 'Cài Đặt',width_: 100),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                // SizedBox(height: 40),
                const Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xff886ff2),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Tài khoản",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    )
                  ],
                ),
                const Divider(height: 20, thickness: 0.5),
                const SizedBox(height: 10),
                Container(
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: CircleAvatar(
                          backgroundImage:
                              Image.asset('assets/images/user-1.jpg').image,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _employeeViewModel?.fULLNAME ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            _employeeViewModel?.titleNameVi ?? "",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          )
                        ],
                      ),
                      const Spacer(),
                      //  TProfileButton(),
                      ArrowRightBtn(
                        onTap_: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                emp_code: widget.emp_code,
                                emp_id: widget.emp_id,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Color(0xff886ff2),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Cài đặt",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    )
                  ],
                ),
                const Divider(height: 20, thickness: 0.5),
                const SizedBox(height: 20),
                SettingItem(
                  title: "Ngôn ngữ",
                  icon: Ionicons.earth,
                  bgColor: Colors.orange.shade100,
                  iconColor: Colors.orange,
                  value: "Tiếng việt",
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: "Thông báo",
                  icon: Ionicons.notifications,
                  bgColor: Colors.blue.shade100,
                  iconColor: Colors.blue,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                SettingSwitch(
                  title: "Chế độ tối",
                  icon: Ionicons.earth,
                  bgColor: Colors.purple.shade100,
                  iconColor: Colors.purple,
                  value: isDarkMode,
                  onTap: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: "Hỗ trợ",
                  icon: Ionicons.nuclear,
                  bgColor: Colors.red.shade100,
                  iconColor: Colors.red,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginPage(),
                          ),
                          (Route<dynamic> route) => false);
                    },
                    child: const Text(
                      "Đăng Xuất",
                      style: TextStyle(
                          fontSize: 17,
                          letterSpacing: 2.2,
                          color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TProfileButton extends StatelessWidget {
  final String empCode;
  final int empId;
  const TProfileButton({
    super.key,
    required this.empCode,
    required this.empId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(
                    emp_code: empCode,
                    emp_id: empId,
                  )),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(Ionicons.chevron_forward_outline),
      ),
    );
  }
}

class SettingSwitch extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final bool value;
  final Function(bool value) onTap;
  const SettingSwitch({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value ? "Bật" : "Tắt",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          CupertinoSwitch(value: value, onChanged: onTap),
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final Function() onTap;
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final String? value;
  const SettingItem(
      {super.key,
      required this.onTap,
      required this.title,
      required this.bgColor,
      required this.iconColor,
      required this.icon,
      this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          value != null
              ? Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                )
              : const SizedBox(),
          const SizedBox(width: 10),
          ForwardButton(onTop: onTap)
        ],
      ),
    );
  }
}
