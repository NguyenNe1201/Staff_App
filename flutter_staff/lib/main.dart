import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/l10n/cubits/languages_cubit.dart';
import 'package:flutter_staff/view/Screen/appLifecycle.dart';
import 'package:flutter_staff/view/Screen/leave_page_screen.dart';
import 'package:flutter_staff/view/Screen/login_page_screen.dart';
import 'package:flutter_staff/view/Screen/salary_page_screen.dart';
import 'package:flutter_staff/view/Widget/dropdown_widget.dart';
import 'package:flutter_staff/view/Screen/profile_page_screen.dart';
import 'package:flutter_staff/view/Screen/setting_page_screen.dart';
import 'package:flutter_staff/view/Screen/home_page_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return BlocProvider(
      create: (_) => LanguagesCubit(),
      child: BlocBuilder<LanguagesCubit, Locale?>(
        builder: (context, locale) {
          return MaterialApp(
            theme: ThemeData(fontFamily: 'Mulish'),
            debugShowCheckedModeBanner: false,
            title: "HRM",
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('vi', ''),
            ],
            locale: locale ?? Locale('vi'), // Ngôn ngữ mặc định nếu null
           // home: const HomePage(emp_code: '164', emp_id: 64),
            home: LoginPage(),
            routes: {},
          );
        },
      ),
    );
    // return MaterialApp(
    //   theme: ThemeData(fontFamily: 'Mulish'),
    //   debugShowCheckedModeBanner: false,
    //   title: "HRM",
    //   localizationsDelegates: const [
    //     AppLocalizations.delegate,
    //     GlobalMaterialLocalizations.delegate,
    //     GlobalWidgetsLocalizations.delegate,
    //     GlobalCupertinoLocalizations.delegate,
    //   ],
    //   supportedLocales: const [
    //     Locale('en', ''), // Tiếng Anh
    //     Locale('vi', ''), // Tiếng Việt
    //   ],
    //   locale: const Locale('en'),
    //   // home: const HomePage(emp_code: '164',emp_id: 64),
    //   home: LoginPage(),
    //   routes: {},
    // );
  }
}
