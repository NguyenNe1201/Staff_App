import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/view/Screen/leave_page_screen.dart';
import 'package:flutter_staff/view/Screen/login_page_screen.dart';
import 'package:flutter_staff/view/Screen/salary_page_screen.dart';
import 'package:flutter_staff/view/Widget/dropdown_widget.dart';
import 'package:flutter_staff/view/Screen/profile_page_screen.dart';
import 'package:flutter_staff/view/Screen/setting_page_screen.dart';
import 'package:flutter_staff/view/template/home_chatbox.dart';
import 'package:flutter_staff/view/Screen/home_page_screen.dart';
import 'package:flutter_staff/view/template/team_folder.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Mulish'),
      debugShowCheckedModeBanner: false,
      title: "HRM",
      // home: const HomePage(emp_code: '164',emp_id: 64),
        home: LoginPage(),
      //home: TeamFolderPage(),
      routes: {},
    );
  }
}
