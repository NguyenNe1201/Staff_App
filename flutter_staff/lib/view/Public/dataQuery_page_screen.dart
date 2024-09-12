import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/timKeeps.dart';

import 'package:flutter_staff/view/Screen/home_page_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import '../../models/logListMonths.dart';

class LoglistPage extends StatefulWidget {
  final String emp_code;
  const LoglistPage({super.key, required this.emp_code});

  @override
  State<LoglistPage> createState() => _LoglistPageState();
}

class _LoglistPageState extends State<LoglistPage> {
  final ApiServices apiHandler = ApiServices();
  List<LogListMonthModel> _lists = [];
  bool isLoading = false;
  // lấy dữ liệu từ model
  Future<void> getDataLogList(String code) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<LogListMonthModel> loglists =
          await apiHandler.fetchLogListMonth(widget.emp_code.toString());
      setState(() {
        _lists = loglists;
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataLogList(widget.emp_code
        .toString()); // Replace 'EMPLOYEE_CODE' with the actual employee code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          AppBarForm(title_: 'Check-in/out'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _lists.isEmpty
                          ? const Center(child: Text('No data found'))
                          : DataTable(
                              columns: <DataColumn>[
                                buildTitleRowDatatable('No.'),
                                buildTitleRowDatatable('ID Card'),
                                buildTitleRowDatatable('Name'),
                                buildTitleRowDatatable('Scan date'),
                                buildTitleRowDatatable('Scan time'),
                                buildTitleRowDatatable('Machine name'),
                              ],
                              rows: _lists.asMap().entries.map((entry) {
                                int index = entry.key;
                                var loglists = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(Text((index + 1).toString())),
                                    DataCell(Text(loglists.eMPCODE ?? '-')),
                                    DataCell(Text(loglists.fULLNAME ?? '-')),
                                    DataCell(
                                      Text(
                                        loglists.dATECHECK != null
                                            ? DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                    loglists.dATECHECK!))
                                            : '-',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        loglists.tIMETEMP != null
                                            ? DateFormat('HH:mm:ss').format(
                                                DateTime.parse(
                                                    loglists.tIMETEMP!))
                                            : '-',
                                      ),
                                    ),
                                    DataCell(Text(loglists.nM ?? '-')),
                                  ],
                                );
                              }).toList(),
                            ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataColumn buildTitleRowDatatable(String name_title) {
  return DataColumn(
    label: Expanded(
      child: Text(
        name_title,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Colors.orange.shade800,
          fontSize: 17,
        ),
      ),
    ),
  );
}

class TimekeepPage extends StatefulWidget {
  final String emp_code;
  const TimekeepPage({super.key, required this.emp_code});

  @override
  State<TimekeepPage> createState() => _TimekeepPageState();
}

class _TimekeepPageState extends State<TimekeepPage> {
  final ApiServices apiServices = ApiServices();
  List<TimeKeepModel> _Lists = [];
  bool isLoading = false;
  // lấy dữ liệu từ model
  Future<void> getDataTimeKeep(String code) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<TimeKeepModel> timekeeps =
          await apiServices.fetchTimeKeep(widget.emp_code.toString());
      setState(() {
        _Lists = timekeeps;
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
    //  print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataTimeKeep(widget.emp_code.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          AppBarForm(title_: 'Timekeep'),
          Expanded(
            //  child: Padding(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _Lists.isEmpty
                          ? const Center(child: Text('No users found'))
                          : DataTable(
                              columns: [
                                buildTitleRowDatatable("DATE"),
                                buildTitleRowDatatable('DAY'),
                                buildTitleRowDatatable('CHECK-IN'),
                                buildTitleRowDatatable('CHECK-OUT'),
                                buildTitleRowDatatable('HOUR'),
                                buildTitleRowDatatable('OT150'),
                                buildTitleRowDatatable('REMARK'),
                              ],
                              rows: _Lists.map((timekeeps) {
                                return DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (timekeeps.dATENAME == "SUN") {
                                        return Colors.grey.withOpacity(
                                            0.3); // Màu nền cho hàng có giá trị dATEOFMONTH là 'SUN'
                                      }
                                      return null; // Màu nền mặc định
                                    },
                                  ),
                                  cells: [
                                    DataCell(
                                      Text(timekeeps.dATEOFMONTH != null
                                          ? DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                  timekeeps.dATEOFMONTH!))
                                          : '-'),
                                    ),
                                    DataCell(Text(timekeeps.dATENAME ?? '-')),
                                    DataCell(
                                      Text(
                                        timekeeps.tIMECHECKIN != null
                                            ? DateFormat('HH:mm:ss').format(
                                                DateTime.parse(
                                                    timekeeps.tIMECHECKIN!))
                                            : '-',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        timekeeps.tIMECHECKOUT != null
                                            ? DateFormat('HH:mm:ss').format(
                                                DateTime.parse(
                                                    timekeeps.tIMECHECKOUT!))
                                            : '-',
                                      ),
                                    ),
                                    DataCell(Text(
                                        timekeeps.hOURWORK.toString() ?? '-')),
                                    DataCell(Text(
                                        timekeeps.oTWORK.toString() ?? '-')),
                                    DataCell(Text(timekeeps.rEMARK ?? '-')),
                                  ],
                                );
                              }).toList(),
                            )),
            ),
          ),
          //),
        ],
      ),
    );
  }
}
