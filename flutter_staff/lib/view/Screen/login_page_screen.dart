import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/logins.dart';
import 'package:flutter_staff/view/Screen/home_page_screen.dart';
import 'dart:async';

import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:flutter_staff/view/Widget/dialogNotification_widget.dart';

// ---------------------------------------

// ---------------------------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool isButtonEnabled = false;
  final ApiServices apiService = ApiServices();
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {
        isButtonEnabled = _phoneController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
                  "Wellcome back",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                const SizedBox(height: 30),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.white.withOpacity(0.8),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      color: Color(0xff6849ef),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                        fontSize: 17,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                buildButton_Continue(
                    "Tiếp tục", _phoneController.text, isButtonEnabled),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade800),
                      children: const <TextSpan>[
                        TextSpan(text: 'Bạn chưa có tài khoản? '),
                        TextSpan(
                          text: 'Đăng ký',
                          style: TextStyle(
                            color: Color(0xff6849ef),
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "Hoặc",
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 17),
                  ),
                ),
                buildFolderRow('Tiếp tục với Gmail', Icons.email),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton_Continue(String title, String phone_number, bool _isBtn) {
    return GestureDetector(
      onTap: _isBtn
          ? () async {
              final check_phone_user =
                  await apiService.fetchCheckPhoneUser(phone_number);
              if (check_phone_user == false) {
                const MyDialogNotification(
                        title: "Thông báo",
                        content:
                            "Số điện thoại này không tồn tại. Vui lòng nhập số khác!")
                    .showMyDialog(context);
              } else {
                final check_time_login =
                    await apiService.fetchCheckTimeLogin(phone_number);
                if (check_time_login) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ConfirmPassWord(
                        username: phone_number,
                      ),
                    ),
                  );
                } else {
                  final otpData = await apiService.fetchSendOtp(phone_number);
                  if (otpData != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ConfirmOTP(otpData: otpData),
                      ),
                    );
                  } else {
                    // Handle failure to send OTP here
                    print('Failed to send OTP');
                  }
                }
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
            color: _isBtn ? Color(0xff6849ef) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: _isBtn ? Colors.white : Colors.grey.shade400,
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

class ConfirmOTP extends StatefulWidget {
  final RequestOTP otpData;
  const ConfirmOTP({super.key, required this.otpData});

  @override
  State<ConfirmOTP> createState() => _ConfirmOTPState();
}

class _ConfirmOTPState extends State<ConfirmOTP> {
  final ApiServices apiService = ApiServices();
  late TextEditingController _otpController1;
  late TextEditingController _otpController2;
  late TextEditingController _otpController3;
  late TextEditingController _otpController4;
  late String _phoneController_hidden;
  late Timer _timer;
  int _start = 120;
  bool _isButtonEnabled = false;
  late RequestOTP _currentOtpData;

  @override
  void initState() {
    super.initState();
    _otpController1 = TextEditingController();
    _otpController2 = TextEditingController();
    _otpController3 = TextEditingController();
    _otpController4 = TextEditingController();
    _phoneController_hidden = widget.otpData.phone.toString();
    _currentOtpData = widget.otpData;
    _startTimer();
  }

  @override
  void dispose() {
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _start = 120;
    _isButtonEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonEnabled = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _verifyOTP() {
    final enteredOtp = _otpController1.text +
        _otpController2.text +
        _otpController3.text +
        _otpController4.text;
    if (enteredOtp == "") {
      const MyDialogNotification(
              title: "Thông báo", content: "Không được để trống!")
          .showMyDialog(context);
    } else if (enteredOtp == _currentOtpData.otp) {
      final info = apiService.fetchUpStatusLogin(
          _currentOtpData.emp_code.toString(),
          _currentOtpData.phone.toString(),
          _currentOtpData.otp.toString());
      if (info == true) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => HomePage(
              emp_code: _currentOtpData.emp_code.toString(),
              emp_id: _currentOtpData.emp_id!,
            ),
          ),
        );
      }
    } else {
      const MyDialogNotification(
              title: "Thông báo", content: "OTP không hợp lệ!")
          .showMyDialog(context);
    }
  }

  Future<void> _resendOTP() async {
    if (_isButtonEnabled) {
      var otpData = await apiService.fetchSendOtp(_phoneController_hidden);
      if (otpData != null) {
        setState(() {
          _currentOtpData = otpData;
          _startTimer();
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Mã OTP đã được gửi lại.')));
        const MyDialogNotification(
                title: "Thông báo",
                content: "Mã OTP đã được gửi lại. Vui lòng kiểm tra tin nhắn!")
            .showMyDialog(context);
      } else {
        const MyDialogNotification(
                title: "Thông báo",
                content: "Gửi lại mã OTP thất bại. Vui lòng thử lại!")
            .showMyDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        const AppBarForm(title_: "Nhập Mã Xác Minh"),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Mã xác thực OTP đã được gửi qua Gmail',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    Text(
                      widget.otpData.gmail ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // input OTP code
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextField(
                      controller: _otpController1,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      style: Theme.of(context).textTheme.headlineMedium,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          hintText: "",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  // edit color, width
                                  color: Colors.grey.shade400,
                                  width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  // edit color, width
                                  color: Colors.grey.shade800,
                                  width: 2))),
                    ),
                  ),
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextField(
                      controller: _otpController2,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      style: Theme.of(context).textTheme.headlineMedium,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          hintText: "",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  // edit color, width
                                  color: Colors.grey.shade400,
                                  width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  // edit color, width
                                  color: Colors.grey.shade800,
                                  width: 2))),
                    ),
                  ),
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextField(
                      controller: _otpController3,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      style: Theme.of(context).textTheme.headlineMedium,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          hintText: "",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  // edit color, width
                                  color: Colors.grey.shade400,
                                  width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  // edit color, width
                                  color: Colors.grey.shade800,
                                  width: 2))),
                    ),
                  ),
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextField(
                      controller: _otpController4,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      style: Theme.of(context).textTheme.headlineMedium,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          hintText: "",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  // edit color, width
                                  color: Colors.grey.shade400,
                                  width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  // edit color, width
                                  color: Colors.grey.shade800,
                                  width: 2))),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Mã xác thực OTP có hiệu lực trong '),
                      TextSpan(
                          text: '$_start',
                          style: const TextStyle(color: Colors.red)),
                      const TextSpan(text: ' giây. \n'),
                      const TextSpan(
                          text:
                              'Kiểm tra thông báo tin nhắn SMS để nhận mã kịp thời.'),
                    ]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              // Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: _isButtonEnabled
                              ? const Color(0xff6849ef)
                              : Colors.grey.shade300,
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: _isButtonEnabled ? _resendOTP : null,
                      child: Text(
                        "Gửi lại",
                        style: TextStyle(
                          color: _isButtonEnabled
                              ? const Color(0xff6849ef)
                              : Colors.grey.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 140,
                    decoration: BoxDecoration(
                      color: _isButtonEnabled
                          ? Colors.grey.shade300
                          : const Color(0xff6849ef),
                      //  border: Border.all(color: Colors.orange.shade800, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: _isButtonEnabled ? null : _verifyOTP,
                      child: Text(
                        "Xác nhận",
                        style: TextStyle(
                          color: _isButtonEnabled
                              ? Colors.grey.shade400
                              : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class ConfirmPassWord extends StatefulWidget {
  final String username;
  const ConfirmPassWord({super.key, required this.username});

  @override
  State<ConfirmPassWord> createState() => _ConfirmPassWordState();
}

class _ConfirmPassWordState extends State<ConfirmPassWord> {
  final TextEditingController _passController = TextEditingController();
  bool _isButtonEnabled = false;
  final ApiServices apiService = ApiServices();
  @override
  void initState() {
    super.initState();
    _passController.addListener(() {
      setState(() {
        _isButtonEnabled = _passController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const AppBarForm(title_: "Nhập Thông Tin"),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  controller: _passController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  style: const TextStyle(
                    color: Color(0xff6849ef),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff6849ef),
                      ), // Màu khi không focus
                    ),
                    prefixIcon: const Icon(
                      Ionicons.file_tray,
                      size: 30,
                      color: Color(0xff6849ef),
                    ),
                    labelText: 'Mật khẩu',
                    labelStyle: TextStyle(
                      fontSize: 17,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ButtonLogin('Đăng nhập', widget.username, _passController.text,
                  _isButtonEnabled),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    children: const <TextSpan>[
                      TextSpan(
                          text: 'Vui lòng nhập mật khẩu để vào ứng dụng. '),
                      TextSpan(
                        text: 'Quên mật khẩu?',
                        style: TextStyle(
                          color: Color(0xff6849ef),
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ]),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget ButtonLogin(
      String title, String username, String password, bool _isBtn) {
    return GestureDetector(
      onTap: _isBtn
          ? () async {
              final check_password_user =
                  await apiService.fetchCheckPassword(username, password);
              if (check_password_user == null) {
                MyDialogNotification(
                        title: "Thông báo",
                        content: "Mật khẩu không đúng. Vui lòng nhập lại!")
                    .showMyDialog(context);
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(
                      emp_code: check_password_user.emp_code.toString(),
                      emp_id: check_password_user.emp_id!,
                    ),
                  ),
                );
              }
            }
          : null,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          // padding: const EdgeInsets.all(10),
          height: 50,
          decoration: BoxDecoration(
            color: _isBtn ? const Color(0xff6849ef) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: _isBtn ? Colors.white : Colors.grey.shade400,
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
