import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staff/config/palette.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/l10n/cubits/languages_cubit.dart';
import 'package:flutter_staff/view/Screen/login_page_screen.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staff/view/Widget/button_widget.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:flutter_staff/view/Screen/profile_page_screen.dart';
import 'package:flutter_staff/models/employees.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<LanguagesCubit>().load(context);
  }

  @override
  void initState() {
    super.initState();
    getDataEmpCode(widget.emp_code.toString());
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Locale? selectedLocale =
            Localizations.localeOf(context); // Lấy ngôn ngữ hiện tại
        return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.language,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6849ef),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/vietnam.png',
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          Text('Tiếng Việt',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              )),
                          
                        ],
                      ),
                      leading: Radio<Locale>(
                        value: const Locale('vi', ''),
                        groupValue: selectedLocale,
                        onChanged: (Locale? value) {
                          setState(() {
                            selectedLocale = value;
                          });
                          context
                              .read<LanguagesCubit>()
                              .change(const Locale('vi', ''));
                        },
                      ),
                    ),
                    ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/us.png',
                            height: 20,
                          ),
                            const SizedBox(width: 10),
                          Text('English',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              )),
                        
                        ],
                      ),
                      leading: Radio<Locale>(
                        value: const Locale('en', ''),
                        groupValue: selectedLocale,
                        onChanged: (Locale? value) {
                          setState(() {
                            selectedLocale = value;
                          });
                          context
                              .read<LanguagesCubit>()
                              .change(const Locale('en', ''));
                        },
                      ),
                    ),
                  ],
                );
              },
            ));
      },
    ).then((selectedLocale) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Column(
        children: [
          AppBarForm(
              title_: AppLocalizations.of(context)!.setting,
              width_: 100,
              icon_: Icons.contact_support_outlined),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                // SizedBox(height: 40),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: Color(0xff886ff2),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.account,
                      style: const TextStyle(
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
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      color: Color(0xff886ff2),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.setting,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    )
                  ],
                ),
                const Divider(height: 20, thickness: 0.5),
                const SizedBox(height: 20),
                SettingItem(
                  title: AppLocalizations.of(context)!.language,
                  icon: Ionicons.earth,
                  bgColor: Colors.orange.shade100,
                  iconColor: Colors.orange,
                  value: AppLocalizations.of(context)!.englishVietnam,
                  onTap: () {
                    _showLanguageDialog(context);
                  },
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: AppLocalizations.of(context)!.notification,
                  icon: Ionicons.notifications,
                  bgColor: Colors.blue.shade100,
                  iconColor: Colors.blue,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                SettingSwitch(
                  title: AppLocalizations.of(context)!.darkMode,
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
                  title: AppLocalizations.of(context)!.help,
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
                    child: Text(
                      AppLocalizations.of(context)!.logOut,
                      style: const TextStyle(
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
        child:const Icon(Ionicons.chevron_forward_outline),
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
            value
                ? AppLocalizations.of(context)!.on
                : AppLocalizations.of(context)!.off,
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
