import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staff/view/Screen/signUp_page_screen.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/logins.dart';
import 'package:flutter_staff/view/Screen/home_page_screen.dart';
import 'dart:async';

import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:flutter_staff/view/Widget/dialogNotification_widget.dart';

// ---------------------------- form đăng nhập -------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoadingLogin = false;
  final ApiServices apiService = ApiServices();
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    setState(() {
      isButtonEnabled = _phoneController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_login_mobile.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Icon(Icons.person_outlined),
                Center(
                  child: Image(
                    image: Image.asset('assets/images/logo.png').image,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Đăng Nhập",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Text(
                //   'Sign in to continue',
                //   style: TextStyle(
                //       color: Colors.grey.shade800,
                //       fontWeight: FontWeight.w500,
                //       fontSize: 17),
                // ),
                const SizedBox(height: 30),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.white.withOpacity(0.8),
                  child: TextField(
                    autofocus: true,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      color: Color(0xff6849ef),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff886ff2),
                        ), // Màu khi không focus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff6849ef),
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.phone,
                        size: 28,
                        color: Color(0xff6849ef),
                      ),
                      labelText: 'Số điện thoại',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.white.withOpacity(0.8),
                  child: TextField(
                    autofocus: true,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true, // hidden text
                    style: const TextStyle(
                      color: Color(0xff6849ef),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff886ff2),
                        ), // Màu khi không focus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff6849ef),
                        ),
                      ),
                      prefixIcon: const Icon(
                        Iconsax.password_check,
                        size: 28,
                        color: Color(0xff6849ef),
                      ),
                      labelText: 'Mật khẩu',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildButton_Login("Đăng nhập", _phoneController.text,
                    _passwordController.text, isButtonEnabled),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade800),
                      children: <TextSpan>[
                        const TextSpan(text: 'Bạn chưa có tài khoản? '),
                        TextSpan(
                          text: 'Đăng ký',
                          style: const TextStyle(
                            color: Color(0xff6849ef),
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()),
                              );
                            },
                        ),
                      ]),
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(height: 30),
                // Center(
                //   child: Text(
                //     "Hoặc",
                //     style: TextStyle(color: Colors.grey.shade800, fontSize: 17),
                //   ),
                // ),
                // buildFolderRow('Tiếp tục với Gmail', Icons.email),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton_Login(
      String title, String phoneNumber, String password, bool isBtn) {
    return GestureDetector(
      onTap: (isBtn && !isLoadingLogin)
          ? () async {
              setState(() {
                isLoadingLogin = true; // Bắt đầu xử lý, vô hiệu hóa nút
              });
              try {
                final checkPhoneUser =
                    await apiService.fetchCheckPhoneUser(phoneNumber);
                if (checkPhoneUser == true) {
                  final checkAccountUser = await apiService.fetchCheckAcByPhone(
                      phoneNumber, password);

                  if (checkAccountUser == null) {
                    const MyDialogNotification(
                            title: "Thông báo",
                            content: "Mật khẩu không đúng. Vui lòng nhập lại!")
                        .showMyDialog(context);
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomePage(
                            emp_code: checkAccountUser.emp_code.toString(),
                            emp_id: checkAccountUser.emp_id!,
                          ),
                        ),
                        (Route<dynamic> route) => false);
                  }
                } else if (checkPhoneUser == false) {
                  const MyDialogNotification(
                          title: "Thông báo",
                          content:
                              "Số điện thoại này không tồn tại. Vui lòng đăng ký tài khoản!")
                      .showMyDialog(context);
                }
              } finally {
                setState(() {
                  isLoadingLogin = false; // Hoàn thành xử lý, kích hoạt lại nút
                });
              }
            }
          : null,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          //  padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          decoration: BoxDecoration(
            color: (isBtn && !isLoadingLogin)
                ? Color(0xff6849ef)
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: (isBtn && !isLoadingLogin)
                    ? Colors.white
                    : Colors.grey.shade400,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildFolderRow(String _title, IconData? _icon) {
  return GestureDetector(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xff886ff2),
            width: 1, // Độ rộng của viền
          ),
        ),
        child: Stack(
          // stack cho phép chồng các widget lên nhau
          children: [
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: Icon(
                _icon,
                color: Color(0xff886ff2),
              ),
            ),
            Center(
              child: Text(
                _title,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// class ConfirmPassWord extends StatefulWidget {
//   final String username;
//   const ConfirmPassWord({super.key, required this.username});

//   @override
//   State<ConfirmPassWord> createState() => _ConfirmPassWordState();
// }

// class _ConfirmPassWordState extends State<ConfirmPassWord> {
//   final TextEditingController _passController = TextEditingController();
//   bool _isButtonEnabled = false;
//   final ApiServices apiService = ApiServices();
//   @override
//   void initState() {
//     super.initState();
//     _passController.addListener(() {
//       setState(() {
//         _isButtonEnabled = _passController.text.isNotEmpty;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _passController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Column(
//         children: [
//           const AppBarForm(title_: "Nhập Thông Tin", width_: 100),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(25),
//             child: Column(children: [
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 child: TextField(
//                   autofocus: true,
//                   controller: _passController,
//                   keyboardType: TextInputType.visiblePassword,
//                   obscureText: true,
//                   style: const TextStyle(
//                     color: Color(0xff6849ef),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                   decoration: InputDecoration(
//                     // border: InputBorder.none,
//                     enabledBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color(0xff6849ef),
//                       ), // Màu khi không focus
//                     ),
//                     prefixIcon: const Icon(
//                       Ionicons.file_tray,
//                       size: 30,
//                       color: Color(0xff6849ef),
//                     ),
//                     labelText: 'Mật khẩu',
//                     labelStyle: TextStyle(
//                       fontSize: 17,
//                       color: Colors.grey[700],
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               ButtonLogin('Đăng nhập', widget.username, _passController.text,
//                   _isButtonEnabled),
//               const SizedBox(height: 20),
//               RichText(
//                 text: TextSpan(
//                     style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
//                     children: const <TextSpan>[
//                       TextSpan(
//                           text: 'Vui lòng nhập mật khẩu để vào ứng dụng. '),
//                       TextSpan(
//                         text: 'Quên mật khẩu?',
//                         style: TextStyle(
//                           color: Color(0xff6849ef),
//                           fontWeight: FontWeight.w600,
//                           fontSize: 17,
//                         ),
//                       ),
//                     ]),
//                 textAlign: TextAlign.center,
//               ),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget ButtonLogin(
//       String title, String username, String password, bool _isBtn) {
//     return GestureDetector(
//       onTap: _isBtn
//           ? () async {
//               final check_password_user =
//                   await apiService.fetchCheckAcByPhone(username, password);
//               if (check_password_user == null) {
//                 const MyDialogNotification(
//                         title: "Thông báo",
//                         content: "Mật khẩu không đúng. Vui lòng nhập lại!")
//                     .showMyDialog(context);
//               } else {
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                       builder: (BuildContext context) => HomePage(
//                         emp_code: check_password_user.emp_code.toString(),
//                         emp_id: check_password_user.emp_id!,
//                       ),
//                     ),
//                     (Route<dynamic> route) => false);
//               }
//             }
//           : null,
//       child: SizedBox(
//         height: 50,
//         width: double.infinity,
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 15),
//           // padding: const EdgeInsets.all(10),
//           height: 50,
//           decoration: BoxDecoration(
//             color: _isBtn ? const Color(0xff6849ef) : Colors.grey.shade300,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(
//             child: Text(
//               title,
//               style: TextStyle(
//                 color: _isBtn ? Colors.white : Colors.grey.shade400,
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
