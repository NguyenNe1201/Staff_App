import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staff/config/palette.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/logins.dart';
import 'package:flutter_staff/view/Screen/login_page_screen.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:flutter_staff/view/Widget/dialogNotification_widget.dart';
import 'package:ionicons/ionicons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// -------------------------- form đăng ký tài khoản --------------------
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoadingSignUp = false;
  final ApiServices apiService = ApiServices();
  @override
  void initState() {
    super.initState();

    // Adding listeners to all text controllers
    _phoneController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
    _passwordConfirmController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    // Check if all fields are not empty
    setState(() {
      isButtonEnabled = _phoneController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _passwordConfirmController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
             constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom,
                    ),
            child: IntrinsicHeight(
              child: Column(
                //  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarForm(
                      title_: AppLocalizations.of(context)!.signUp,
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
                            // color: Colors.white.withOpacity(0.8),
                            child: TextFormField(
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
                                  size: 26,
                                  color: Color(0xff6849ef),
                                ),
                                labelText: AppLocalizations.of(context)!.phoneNumber,
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
                                labelText: AppLocalizations.of(context)!.password,
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
                                labelText: AppLocalizations.of(context)!.confirmPassword,
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return AppLocalizations.of(context)!.passwordMismatch;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          buildButton_SignUp(
                              AppLocalizations.of(context)!.signUp,
                              _phoneController.text,
                              _userNameController.text,
                              _passwordController.text,
                              _passwordConfirmController.text,
                              isButtonEnabled),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton_SignUp(String title, String phoneNumber, String username,
      String password, String passwordConfirm, bool isBtn) {
    return GestureDetector(
      onTap: (isBtn && !isLoadingSignUp)
          ? () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoadingSignUp = true;
                });
                try {
                  final checkPhoneUser =
                      await apiService.fetchCheckPhoneUser(phoneNumber);
                  if (checkPhoneUser == true) {
                    final checkAccountByPhone =
                        await apiService.fetchSignUpCheckAccount(phoneNumber);
                    if (checkAccountByPhone) {
                      final otpData =
                          await apiService.fetchSendOtpSignUpUser(phoneNumber);
                      if (otpData != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ConfirmOTP(
                            otpData: otpData,
                            password: password,
                          ),
                        ));
                      } else {
                       MyDialogNotification(
                                title: AppLocalizations.of(context)!.notification,
                                content: "Lỗi. Vui lòng tạo lại!")
                            .showMyDialog(context);
                      }
                    } else {
                     MyDialogNotification(
                              title:  AppLocalizations.of(context)!.notification,
                              content: "Tài khoản này đã tồn tại.")
                          .showMyDialog(context);
                    }
                  } else {
                    MyDialogNotification(
                            title: AppLocalizations.of(context)!.notification,
                            content:
                                "Số điện thoại chưa tồn tại trên hệ thống. Liên hệ quản lý để cập nhật!")
                        .showMyDialog(context);
                  }
                } finally {
                  setState(() {
                    isLoadingSignUp = false;
                  });
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
            color: (isBtn && !isLoadingSignUp)
                ? Palette.btnColor
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: (isBtn && !isLoadingSignUp)
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

// ---------------------- form xác thực otp -------------------------------
class ConfirmOTP extends StatefulWidget {
  final RequestOTP otpData;
  final String password;
  const ConfirmOTP({super.key, required this.otpData, required this.password});

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
         MyDialogNotification(
                title: AppLocalizations.of(context)!.notification, content: "Không được để trống!")
            .showMyDialog(context);
      } else if (enteredOtp == _currentOtpData.otp) {
        final result = await apiService.fetchSignUpAddAccount(
            _currentOtpData.emp_id!, widget.password);
        if (result == true) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage(),
              ),
              (Route<dynamic> route) => false);
         MyDialogNotification(
                  title:  AppLocalizations.of(context)!.notification, content: "Đăng ký tài khoản thành công.")
              .showMyDialog(context);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => const SignUpPage(),
              ),
              (Route<dynamic> route) => false);
          MyDialogNotification(
                  title:  AppLocalizations.of(context)!.notification, content: "Xác thực OTP thất bại.")
              .showMyDialog(context);
        }
      } else {
        MyDialogNotification(
                title:  AppLocalizations.of(context)!.notification, content: "OTP không hợp lệ!")
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
      var otpData = await apiService.fetchSendOtpSignUpUser(_phoneController_hidden);
      if (otpData != null) {
        setState(() {
          _currentOtpData = otpData;
          _startTimer();
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Mã OTP đã được gửi lại.')));
        MyDialogNotification(
                title:  AppLocalizations.of(context)!.notification,
                content:
                    "Mã OTP đã được gửi lại. Vui lòng kiểm tra thư điện tử!")
            .showMyDialog(context);
      } else {
       MyDialogNotification(
                title:  AppLocalizations.of(context)!.notification,
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
         AppBarForm(
            title_: AppLocalizations.of(context)!.verificationCode,
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
                       AppLocalizations.of(context)!.resend,
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
                        AppLocalizations.of(context)!.confirm,
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
      ]),
    );
  }
}
