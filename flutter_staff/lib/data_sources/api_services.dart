import 'package:flutter_staff/models/employees.dart';
import 'package:flutter_staff/models/leaves.dart';
import 'package:flutter_staff/models/logListMonths.dart';
import 'package:flutter_staff/models/logins.dart';
import 'package:flutter_staff/models/salarys.dart';
import 'package:flutter_staff/models/timeKeeps.dart';
import 'package:dio/dio.dart';

class ApiServices {
  //final String baseUrl = 'https:/localhost:7144/api';
  //final String baseUrl = 'https://192.168.90.111/api';
  final String baseUrl = 'https://gw.conectvn.com:4432/api';
  final dio = Dio();

  // get employee
  Future<List<EmployeeModel>> fetchEmpolyee() async {
    try {
      var response = await dio.get('$baseUrl/Employee');
      List<EmployeeModel> emps = (response.data as List)
          .map((userJson) => EmployeeModel.fromJson(userJson))
          .toList();
      return emps;
    } catch (e) {
      throw Exception('Failed to load staff');
    }
  }

  // get employee = code
  Future<EmployeeViewModel?> fetchInfoEmpCode(String code) async {
    var response = await dio.get('$baseUrl/Employee/GetByCode?code=$code');
    //  var response = await dio.get('/Employee/GetByCode?code=$code');
    if (response.data is List) {
      return EmployeeViewModel.fromJson(response.data[0]);
    } else if (response.data is Map) {
      return EmployeeViewModel.fromJson(response.data);
    } else {
      throw Exception('Unexpected response format');
    }
  }

  //----------------------------- login ----------------------------
  // check time login app
  Future<bool> fetchCheckTimeLogin(String phone) async {
    try {
      final response = await dio.get('$baseUrl/Login/CheckTime?phone=$phone');
      if (response.statusCode == 200) {
        return response.data == true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // check phone of user
  Future<bool> fetchCheckPhoneUser(String phone) async {
    try {
      final response =
          await dio.get('$baseUrl/Login/CheckPhoneUser?phone=$phone');
      if (response.statusCode == 200) {
        return response.data == true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // login == phone, password
  Future<RequestByAccount?> fetchCheckAcByPhone(
      String phone, String pass) async {
    try {
      final response = await dio
          .get('$baseUrl/Login/CheckAcByPhone?phone=$phone&password=$pass');
      if (response.statusCode == 200) {
        return RequestByAccount.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // send email otp
  Future<RequestOTP?> fetchSendOtpSignUpUser(String phone) async {
    try {
      var response = await dio.post(
        '$baseUrl/Email/SendOtpSignUpUser',
        queryParameters: {
          'number_phone': phone,
        },
      );
      if (response.statusCode == 200) {
        return RequestOTP.fromJson(response.data);
      } else {
        print('Failed to send OTP');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // send otp email of forgotPassword Page
  Future<RequestOTP?> fetchSendOtpForgotPass(String phone) async {
    try {
      var response = await dio.get(
        '$baseUrl/Email/sendOtpForgotPass',
        queryParameters: {
          'number_phone': phone,
        },
      );
      if (response.statusCode == 200) {
        return RequestOTP.fromJson(response.data);
      } else {
        print('Failed to send OTP');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // update status login = otp
  Future<bool> fetchUpStatusLogin(
      String emp_code, String phone, String otp) async {
    try {
      await dio.put('$baseUrl/login/UpdateStatus', queryParameters: {
        'emp_code': emp_code,
        'phone': phone,
        'otp': otp,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // =========================== SignUp Account ===========================
  Future<bool> fetchSignUpCheckAccount(String phone) async {
    try {
      final response =
          await dio.get('$baseUrl/SignUp/CheckAccountByPhone?phone=$phone');
      if (response.statusCode == 200) {
        return response.data == true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchSignUpAddAccount(int empID, String password) async {
    try {
      final response =
          await dio.put('$baseUrl/SignUp/AddAccount', queryParameters: {
        'empId': empID,
        'password': password,
      });
      if (response.statusCode == 200) {
        return response.data == true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // ------------------------- timekeep -------------------------
  // get data timekeep
  Future<List<TimeKeepModel>> fetchTimeKeep(
      String code, String month, String year) async {
    try {
      var response = await dio.get(
          '$baseUrl/TimeKeep/timeKeepMonth?code=$code&month=$month&year=$year');
      List<TimeKeepModel> timekeeps = (response.data as List)
          .map((userJson) => TimeKeepModel.fromJson(userJson))
          .toList();
      return timekeeps;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  //get data log list current month = emp code
  Future<List<LogListMonthModel>> fetchLogListCurrentMonth(String code) async {
    try {
      var response = await dio.get('$baseUrl/TimeKeep/logListTime?code=$code');
      List<LogListMonthModel> lists = (response.data as List)
          .map((userJson) => LogListMonthModel.fromJson(userJson))
          .toList();
      return lists;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  //get data log list = emp code by month year
  Future<List<LogListMonthModel>> fetchLogListEmpByMonth(
      String code, String month, String year) async {
    try {
      var response = await dio.get(
          '$baseUrl/TimeKeep/logListTimeByMonth?code=$code&month=$month&year=$year');
      List<LogListMonthModel> lists = (response.data as List)
          .map((userJson) => LogListMonthModel.fromJson(userJson))
          .toList();
      return lists;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  //------------------------------- LEAVE ------------------------------
  // get select cal leave by employee id
  Future<CalLeaveModel?> fetchGetCalLeave(int emp_id) async {
    try {
      var response = await dio.get('$baseUrl/Leave/Cal_EmpID?emp_id=$emp_id');
      //  var response = await dio.get('/Leave/Cal_EmpID?emp_id=$emp_id');
      if (response.data is List) {
        return CalLeaveModel.fromJson(response.data[0]);
      }
      if (response.statusCode == 200) {
        return CalLeaveModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // get leave table by leave id
  Future<LeaveModel?> fetchGetLeaveByID(int leaveId) async {
    try {
      var response =
          await dio.get('$baseUrl/Leave/GetLeaveByID?leave_id=$leaveId');
      if (response.data is List) {
        return LeaveModel.fromJson(response.data[0]);
      }
      if (response.statusCode == 200) {
        return LeaveModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // get count waiting leave by employee id
  Future<CountWaitLeaveModel?> fetchGetCountWaitingLeave(int emp_id) async {
    try {
      var response =
          await dio.get('$baseUrl/Leave/Count_WaitLeave_EmpID?emp_id=$emp_id');

      if (response.data is List) {
        return CountWaitLeaveModel.fromJson(response.data[0]);
      }
      if (response.statusCode == 200) {
        return CountWaitLeaveModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // get select list leave by employee id
  Future<List<LeaveModel>> fetchGetListLeave(int emp_id) async {
    try {
      var response =
          await dio.get('$baseUrl/Leave/GetListByMonth_EmpID?emp_id=$emp_id');
      List<LeaveModel> lists = (response.data as List)
          .map((userJson) => LeaveModel.fromJson(userJson))
          .toList();
      return lists;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  // get all KindLeave
  Future<List<KindLeaveModel>> fetchAllKindLeave() async {
    try {
      var response = await dio.get('$baseUrl/Leave/GetAllKindLeave');
      List<KindLeaveModel> lists = (response.data as List)
          .map((dataJson) => KindLeaveModel.fromJson(dataJson))
          .toList();
      return lists;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  // get list leave 1 employee by month
  Future<List<LeaveModel>> fetchListLeaveEmpIdByMonth(
      int empId, int month) async {
    try {
      var response = await dio.get(
          '$baseUrl/Leave/GetListByMonth_EmpID?emp_id=$empId&month=$month');
      List<LeaveModel> lists = (response.data as List)
          .map((dataJson) => LeaveModel.fromJson(dataJson))
          .toList();
      return lists;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  // insert leave for employee
  Future<Map<String, dynamic>> fetchAddLeave(int empID, int kindLeaveID,
      int period, String startDate, String endDate, String detailReason) async {
    try {
      var response = await dio.post(
        '$baseUrl/Leave/Insert',
        queryParameters: {
          'emp_id': empID,
          'kindLeave_id': kindLeaveID,
          'period': period,
          'startDate': startDate,
          'endDate': endDate,
          'detailReason': detailReason,
        },
      );

      if (response.statusCode == 200) {
        if (response.data.containsKey('error')) {
          return {
            'status': false,
            'message': response.data['error'], // Trả về thông báo lỗi
          };
        } else if (response.data.containsKey('success')) {
          return {
            'status': true,
            'message': response.data['success'], // Trả về thông báo thành công
          };
        }
      }
      return {
        'status': false,
        'message': 'Unknown error occurred', // Trả về thông báo lỗi chung
      };
    } catch (e) {
      return {
        'status': false,
        'message': 'Error: $e', // Trả về lỗi xảy ra trong quá trình gọi API
      };
    }
  }

  //---------------------------- SALARY -------------------------
  // get salary by employee code
  Future<SalaryModel?> fetchGetSalaryEmp(String code, String yearMonth) async {
    try {
      var response = await dio
          .get('$baseUrl/Salary/ByMonth?code=$code&year_month=$yearMonth');
      if (response.statusCode == 200) {
        return SalaryModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}


// class ApiServices {
//   final String baseUrl = 'https://gw.conectvn.com:4432/api';
//   var dio = Dio();
//   Future<List<UserModel>> fetchUser() async {
//     try {
//       dio.options.baseUrl = baseUrl;
//       dio.options.connectTimeout = const Duration(seconds: 10);
//  dio.httpClientAdapter = IOHttpClientAdapter(
//       createHttpClient: () {
//         final HttpClient client =
//             HttpClient(context: SecurityContext(withTrustedRoots: false));
//         client.badCertificateCallback = (cert, host, port) => true;
//         return client;
//       },
//       validateCertificate: (cert, host, port) {
//         return true;
//       },
//     );
//       var response = await dio.get('$baseUrl/users', queryParameters: {
//         'fbclid':
//             'IwZXh0bgNhZW0CMTAAAR240iqQU69kGpfTvsa8jI59u9M4VNHlstTU7WVATBR_JVGMXe9jUUAkhFQ_aem_ASdCSx_-QYCEL6-PXajlrSoRB2FG-Pke7Mq0vl2-UVXDFUFVY_ysn9G6G7dR2uSQHJjR9RUcUIxXA20EEDPX8Fze'
//       });
//       List<UserModel> users = (response.data as List)
//           .map((userJson) => UserModel.fromJson(userJson))
//           .toList();
//       return users;
//     } catch (e) {
//       print(e);
//       throw Exception('Failed to load users');
//     }
//   }
// }
