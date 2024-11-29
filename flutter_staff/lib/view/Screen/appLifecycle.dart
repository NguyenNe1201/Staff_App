import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staff/view/Screen/login_page_screen.dart';
import 'package:local_session_timeout/local_session_timeout.dart';


class AppLifecycle extends StatefulWidget {
  final Widget child; // Widget con được bọc
  const AppLifecycle({Key? key, required this.child}) : super(key: key);
  @override
  State<AppLifecycle> createState() => _AppLifecycleState();
}
// class _AppLifecycleState extends State<AppLifecycle> {
//   late final SessionTimeoutManager _sessionTimeoutManager;

//   @override
//   void initState() {
//     super.initState();
//    // Khởi tạo SessionTimeoutManager
//     _sessionTimeoutManager = SessionTimeoutManager(
//       timeoutDuration: const Duration(minutes: 1), // Thời gian chờ 1 phút
//       onSessionTimeout: _handleSessionTimeout, // Callback khi hết thời gian
//     );

//     // Bắt đầu theo dõi hoạt động
//     _sessionTimeoutManager.startMonitoring();
//   }

//   @override
//   void dispose() {
//     // Dừng theo dõi và hủy tài nguyên
//     _sessionTimeoutManager.stopMonitoring();
//     super.dispose();
//   }

//   // Hàm xử lý khi hết thời gian
//   void _handleSessionTimeout() {
//     // Điều hướng về trang login
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(
//         builder: (BuildContext context) => const LoginPage(),
//       ),
//       (Route<dynamic> route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SessionHandler(
//       sessionTimeoutManager: _sessionTimeoutManager,
//       onSessionTimeout: _handleSessionTimeout,
//       child: widget.child, // Widget được bọc
//     );
//   }
// }
class _AppLifecycleState extends State<AppLifecycle>
    with WidgetsBindingObserver {
  Timer? _logoutTimer;

  void startLogoutTimer() {
    _logoutTimer = Timer(const Duration(minutes: 1), () {
      // Điều hướng về trang login
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage(),
          ),
          (Route<dynamic> route) => false);
    });
  }

  void resetLogoutTimer() {
    _logoutTimer?.cancel();
    startLogoutTimer();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Đăng ký observer
    startLogoutTimer(); // Khởi động timer khi ứng dụng mở
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Hủy đăng ký observer
    _logoutTimer?.cancel(); // Hủy timer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
     _logoutTimer?.cancel();
      startLogoutTimer(); // Reset timer khi ứng dụng quay lại foreground
    }
  }

  @override
  Widget build(BuildContext context) {
       return widget.child; // Thêm widget hiển thị nếu cần
  }
}

