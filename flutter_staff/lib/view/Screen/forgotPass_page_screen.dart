import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staff/config/palette.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/logins.dart';
import 'package:flutter_staff/view/Screen/login_page_screen.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:flutter_staff/view/Widget/button_widget.dart';
import 'package:flutter_staff/view/Widget/dialogNotification_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final ApiServices apiService = ApiServices();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoadingForgotPass = false;
  Future<void> _btnHandleForgotPass() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: Column(
          children: [
             AppBarForm(
                title_: AppLocalizations.of(context)!.forgotPassword,
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
                        labelText: AppLocalizations.of(context)!.phoneNumber,
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '${AppLocalizations.of(context)!.fieldIsRequired}';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      title_: AppLocalizations.of(context)!.conTinue,
                      onTap_: (!isLoadingForgotPass)
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoadingForgotPass = true;
                                });
                                try {
                                  final otpData =
                                      await apiService.fetchSendOtpForgotPass(
                                          _phoneController.text);
                                  if (otpData != null) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ForgotPasswordOTP(
                                        otpData: otpData,
                                      ),
                                    ));
                                  } else {
                                    MyDialogNotification(
                                            title: AppLocalizations.of(context)!
                                                .notification,
                                            content: "${ AppLocalizations.of(context)!.errorPleaseEnterAgain}.")
                                        .showMyDialog(context);
                                  }
                                } finally {
                                  setState(() {
                                    isLoadingForgotPass = false;
                                  });
                                }
                              }
                            }
                          : null,
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
        MyDialogNotification(
                title: AppLocalizations.of(context)!.notification,
                content: "${ AppLocalizations.of(context)!.fieldIsRequired}.")
            .showMyDialog(context);
      } else if (enteredOtp == _currentOtpData.otp) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ResetPasswordPage(empID: widget.otpData.emp_id!),
            ),
            (Route<dynamic> route) => false);
      } else {
        MyDialogNotification(
                title: AppLocalizations.of(context)!.notification,
                content: "${ AppLocalizations.of(context)!.invalidOTP}.")
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
        MyDialogNotification(
                title: AppLocalizations.of(context)!.notification,
                content:
                    "${AppLocalizations.of(context)!.oTPResentPlCheckEmail}.")
            .showMyDialog(context);
      } else {
        MyDialogNotification(
                title: AppLocalizations.of(context)!.notification,
                content: "${AppLocalizations.of(context)!.resendOTPfailedPleaseTryAgain}.")
            .showMyDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewInsets.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  AppBarForm(
                      title_: AppLocalizations.of(context)!.oTPverification,
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
                              Text(
                                "${AppLocalizations.of(context)!.oTPverificationCodeHasBeenSent}:",
                                style:const TextStyle(
                                    fontSize: 16, color: Colors.black54),
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
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
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
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
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
                                            color: Colors.grey.shade400,
                                            width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
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
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
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
                                            color: Colors.grey.shade400,
                                            width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
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
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
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
                                            color: Colors.grey.shade400,
                                            width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
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
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey.shade800),
                              children: <TextSpan>[
                                 TextSpan(
                                    text: '${AppLocalizations.of(context)!.oTPIsValidFor} '),
                                TextSpan(
                                    text: _start.toString(),
                                    style: const TextStyle(color: Colors.red)),
                                 TextSpan(text: ' ${AppLocalizations.of(context)!.second}. \n'),
                                 TextSpan(
                                    text:
                                        '${AppLocalizations.of(context)!.checkYourEmailForTheCode}.'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  final int empID;
  const ResetPasswordPage({super.key, required this.empID});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool isButtonEnabled = false;
  bool isLoadingForgotPass = false;
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
           AppBarForm(
              title_: AppLocalizations.of(context)!.resetPassword,
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
                  // my button xác nhận
                  MyButton(
                      title_: AppLocalizations.of(context)!.confirm,
                      onTap_: () async {
                        if (_formKey.currentState!.validate()) {
                          final result = await apiService.fetchSignUpAddAccount(
                              widget.empID, _passwordController.text);
                          if (result == true) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginPage(),
                                ),
                                (Route<dynamic> route) => false);
                            MyDialogNotification(
                                    title: AppLocalizations.of(context)!
                                        .notification,
                                    content: "${AppLocalizations.of(context)!.passwordChangedSuccess}.")
                                .showMyDialog(context);
                          } else {
                            MyDialogNotification(
                                    title: AppLocalizations.of(context)!
                                        .notification,
                                    content: "${AppLocalizations.of(context)!.passwordChangedFail}.")
                                .showMyDialog(context);
                          }
                        }
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
