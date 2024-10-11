import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staff/config/palette.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/logins.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:flutter_staff/view/Widget/button_widget.dart';
import 'package:flutter_staff/view/Widget/dialogNotification_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final ApiServices apiService = ApiServices();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: Column(
          children: [
            const AppBarForm(
                title_: "Quên Mật Khẩu",
                width_: 100,
                icon_: Icons.contact_support_outlined),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  children: [
                    TextFormField(
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
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xff886ff2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xff6849ef),
                          ),
                        ),
                        // Cấu hình viền khi có lỗi
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.pink,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.pink,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Iconsax.password_check,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'không được để trống';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      title_: 'Tiếp Tục',
                      onTap_: () async {
                        final otpData = await apiService
                            .fetchSendOtpForgotPass(_phoneController.text);
                        if (otpData != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ForgotPasswordOTP(
                              otpData: otpData,
                            ),
                          ));
                        } else {
                          const MyDialogNotification(
                                  title: "Thông báo",
                                  content: "Lỗi. Vui lòng tạo lại!")
                              .showMyDialog(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ));
  }
}

class ForgotPasswordOTP extends StatefulWidget {
  final RequestOTP otpData;
  const ForgotPasswordOTP({super.key, required this.otpData});

  @override
  State<ForgotPasswordOTP> createState() => _ForgotPasswordOTPState();
}

class _ForgotPasswordOTPState extends State<ForgotPasswordOTP> {
  final ApiServices apiService = ApiServices();
  late TextEditingController _otpController1;
  late TextEditingController _otpController2;
  late TextEditingController _otpController3;
  late TextEditingController _otpController4;
  late String _phoneController_hidden;
  late Timer _timer;
  int _start = 120;
  bool _isButtonEnabled = false;
  bool _isBtnConfirm = false;
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

  Future<void> _verifyOTP() async {
    setState(() {
      _isBtnConfirm = true; // Bắt đầu xử lý, vô hiệu hóa nút
    });
    try {
      var enteredOtp = _otpController1.text +
          _otpController2.text +
          _otpController3.text +
          _otpController4.text;
      if (enteredOtp == "") {
        const MyDialogNotification(
                title: "Thông báo", content: "Không được để trống!")
            .showMyDialog(context);
      } else if (enteredOtp == _currentOtpData.otp) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => ResetPasswordPage(
                  empCode: _currentOtpData.emp_code.toString()),
            ),
            (Route<dynamic> route) => false);
      } else {
        const MyDialogNotification(
                title: "Thông báo", content: "OTP không hợp lệ!")
            .showMyDialog(context);
      }
    } finally {
      setState(() {
        _isBtnConfirm = false; // Hoàn thành xử lý, kích hoạt lại nút
      });
    }
  }

  Future<void> _resendOTP() async {
    if (_isButtonEnabled) {
      var otpData =
          await apiService.fetchSendOtpForgotPass(_phoneController_hidden);
      if (otpData != null) {
        setState(() {
          _currentOtpData = otpData;
          _startTimer();
        });
        const MyDialogNotification(
                title: "Thông báo",
                content:
                    "Mã OTP đã được gửi lại. Vui lòng kiểm tra thư điện tử!")
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
      backgroundColor: Palette.backgroundColor,
      body: Column(
        children: [
          const AppBarForm(
              title_: "Xác Thực OTP",
              width_: 100,
              icon_: Icons.contact_support_outlined),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "Mã xác thực OTP đã được gửi qua:",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Text(
                        widget.otpData.gmail ?? '',
                        style: const TextStyle(
                          fontSize: 18,
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
                                    color: Colors.grey.shade400, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade800, width: 2))),
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
                                    color: Colors.grey.shade400, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade800, width: 2))),
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
                                    color: Colors.grey.shade400, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade800, width: 2))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade800),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Mã xác thực OTP có hiệu lực trong '),
                        TextSpan(
                            text: '$_start',
                            style: const TextStyle(color: Colors.red)),
                        const TextSpan(text: ' giây. \n'),
                        const TextSpan(
                            text: 'Kiểm tra thông báo thư điện tử để nhận mã.'),
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
                        color: (_isButtonEnabled && !_isBtnConfirm)
                            ? Colors.grey.shade300
                            : const Color(0xff6849ef),
                        //  border: Border.all(color: Colors.orange.shade800, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: (_isButtonEnabled && !_isBtnConfirm)
                            ? null
                            : _verifyOTP,
                        child: Text(
                          "Xác nhận",
                          style: TextStyle(
                            color: (_isButtonEnabled && !_isBtnConfirm)
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
        ],
      ),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  final String empCode;
  const ResetPasswordPage({super.key, required this.empCode});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool isButtonEnabled = false;
  bool isLoadingSignUp = false;
  final ApiServices apiService = ApiServices();
  @override
  void initState() {
    super.initState();
    // Adding listeners to all text controllers
    _passwordController.addListener(_checkFormValidity);
    _passwordConfirmController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    // Check if all fields are not empty
    setState(() {
      isButtonEnabled = _passwordController.text.isNotEmpty &&
          _passwordConfirmController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Column(
        //  crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBarForm(
              title_: "Đặt Lại Mật Khẩu",
              width_: 100,
              icon_: Icons.contact_support_outlined),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //  color: Colors.white.withOpacity(0.8),
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
                          size: 26,
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
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //   color: Colors.white.withOpacity(0.8),
                    child: TextFormField(
                      autofocus: true,
                      controller: _passwordConfirmController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true, // hidden text
                      style: const TextStyle(
                        color: Color(0xff6849ef),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xff886ff2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xff6849ef),
                          ),
                        ),
                        // Cấu hình viền khi có lỗi
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.pink,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.pink,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Iconsax.password_check,
                          size: 28,
                          color: Color(0xff6849ef),
                        ),
                        labelText: 'Xác nhận mật khẩu',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Mật khẩu không khớp';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // my button xác nhận
                  MyButton(title_: "Xác nhận", onTap_: () {
                    
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
