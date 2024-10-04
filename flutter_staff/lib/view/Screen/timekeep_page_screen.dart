import 'dart:ui';
//import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/timeKeeps.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_staff/view/Widget/datatable_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import '../../models/logListMonths.dart';
import 'package:ionicons/ionicons.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

// ------------------------ form chấm công thực tế -----------------------
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
  bool isStatusFilter = false;
  late LoglistDataSource _loglistDataSource;
  String? selectedMonth;
  String? selectedYear;
  final List<String> items_month = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
  ];
  final List<String> items_year = [];
  final int startYear = 2019;
  final int currentYear = DateTime.now().year;

  void list_year() {
    for (int year = startYear; year <= currentYear; year++) {
      items_year.add(year.toString());
    }
  }

  // lấy dữ liệu từ model
  Future<void> getDataLogList(String code, String month, String year) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<LogListMonthModel> loglists =
          await apiHandler.fetchLogListEmpByMonth(code, month, year);
      setState(() {
        _lists = loglists;
        _loglistDataSource = LoglistDataSource(loglists);

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    list_year();
    _loglistDataSource = LoglistDataSource([]);
  }

  void _showCustomDialog() {
    String? tempSelectedMonth = selectedMonth;
    String? tempSelectedYear = selectedYear;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Tìm Kiếm",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff6849ef),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      menuMaxHeight: 200,
                      decoration: InputDecoration(
                        labelText: 'Tháng',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: const Color(0xff6849ef).withOpacity(0.8),
                            width: 0.5,
                          ),
                        ),
                      ),
                      value: tempSelectedMonth,
                      items: items_month.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          tempSelectedMonth = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      menuMaxHeight: 200,
                      decoration: InputDecoration(
                        labelText: 'Năm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: const Color(0xff6849ef).withOpacity(0.8),
                            width: 0.5,
                          ),
                        ),
                      ),
                      value: tempSelectedYear,
                      items: items_year.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          tempSelectedYear = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Hủy"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedMonth = tempSelectedMonth;
                        selectedYear = tempSelectedYear;
                      });
                      getDataLogList(
                          widget.emp_code.toString(),
                          tempSelectedMonth.toString(),
                          tempSelectedYear.toString());
                      Navigator.pop(context);
                    },
                    child: const Text("Chọn"),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          AppBarForm(
              title_: 'Chấm Công Thực Tế',
              title_1: "(Giờ Vào - Ra)",
              width_: 110,
              icon_: Ionicons.search_sharp,
              onTapLeftBtn: () {
                _showCustomDialog();
              }),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _lists.isEmpty
                    ? const Center(
                        child: Text('Không có dữ liệu.',
                            style: TextStyle(fontSize: 15)))
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SfDataGridTheme(
                          data: SfDataGridThemeData(
                            filterIconColor: Colors.orange.shade800,
                            frozenPaneLineColor: Colors.grey.shade400,
                            headerColor: Colors.transparent,
                            sortIconColor: Colors.orange.shade800,
                          ),
                          child: SfDataGrid(
                            source: _loglistDataSource,
                            onFilterChanged: (details) => {
                              setState(() {
                                isStatusFilter = true;
                              })
                            },
                            columnWidthMode: ColumnWidthMode.auto,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.multiple,
                            allowFiltering: false,
                            allowSorting: true,
                            columns: <GridColumn>[
                              GridColumn(
                                  columnName: 'ngay',
                                  maximumWidth: 100,
                                  label: const buildTitleDataColumn(
                                      name_title1: "NGÀY",
                                      name_title2: '(DATE)')),
                              GridColumn(
                                  minimumWidth: 100,
                                  columnName: 'thoi_gian',
                                  allowFiltering: false,
                                  allowSorting: false,
                                  label: const buildTitleDataColumn(
                                      name_title1: "GIỜ QUÉT",
                                      name_title2: '(SCAN TIME)')),
                              GridColumn(
                                  columnName: 'ten_may',
                                  allowFiltering: false,
                                  allowSorting: false,
                                  label: const buildTitleDataColumn(
                                      name_title1: "TÊN MÁY",
                                      name_title2: '(DEVICE NAME)')),
                            ],
                            //   frozenColumnsCount: 1,
                          ),
                        ),
                      ),
          ),
          if (isStatusFilter)
            MaterialButton(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text('Xóa bộ lọc',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange.shade800)),
                onPressed: () {
                  _loglistDataSource.clearFilters();

                  setState(() {
                    isStatusFilter = false; // Ẩn nút sau khi xóa
                  });
                }),
        ],
      ),
    );
  }
}

class LoglistDataSource extends DataGridSource {
  List<DataGridRow> _loglistRows = [];

  LoglistDataSource(List<LogListMonthModel> loglists) {
    _loglistRows = loglists.map<DataGridRow>((loglist) {
      return DataGridRow(cells: [
        DataGridCell<DateTime>(
            columnName: 'ngay',
            value: loglist.dATECHECK != null
                ? DateTime.parse(loglist.dATECHECK!)
                : DateTime(0)),
        DataGridCell<String>(
            columnName: 'thoi_gian',
            value: loglist.tIMECHECK != null &&
                    DateFormat('HH:mm:ss')
                            .format(DateTime.parse(loglist.tIMETEMP!)) !=
                        '00:00:00'
                ? DateFormat('HH:mm:ss')
                    .format(DateTime.parse(loglist.tIMETEMP!))
                : '-'),
        DataGridCell<String>(columnName: 'ten_may', value: loglist.nM ?? '-'),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _loglistRows;
  // Phương thức cần triển khai cho DataGridSource
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          alignment: Alignment.center,
          child: Text(
            dataGridCell.columnName == 'ngay'
                ? DateFormat('dd/MM/yyyy').format(dataGridCell.value)
                : dataGridCell.value.toString(),
          ),
        );
      }).toList(),
    );
  }
}

// ------------------ form bảng chấm công tháng -----------------------
class TimekeepPage extends StatefulWidget {
  final String emp_code;
  const TimekeepPage({super.key, required this.emp_code});

  @override
  State<TimekeepPage> createState() => _TimekeepPageState();
}

class _TimekeepPageState extends State<TimekeepPage> {
  final ApiServices apiServices = ApiServices();
  String? title2_appbar;
  List<TimeKeepModel> _Lists = [];
  bool isLoadingData = false;
  bool isFilterApplied = false;
  late TimekeepDataSource _timekeepDataSource;
  String? selectedMonth;
  String? selectedYear;
  final List<String> items_month = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
  ];
  final List<String> items_year = [];
  final int startYear = 2019;
  final int currentYear = DateTime.now().year;

  void list_year() {
    for (int year = startYear; year <= currentYear; year++) {
      items_year.add(year.toString());
    }
  }

  // Lấy dữ liệu từ model
  Future<void> getDataTimeKeep(
      String empCode, String month, String year) async {
    setState(() {
      isLoadingData = true;
    });
    try {
      List<TimeKeepModel> timekeeps =
          await apiServices.fetchTimeKeep(empCode, month, year);
      setState(() {
        _Lists = timekeeps;
        _timekeepDataSource = TimekeepDataSource(timekeeps);
        title2_appbar = formatCycleText(month);
        isLoadingData = false;
      });
    } catch (e) {
      setState(() {
        isLoadingData = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    list_year();

    _timekeepDataSource = TimekeepDataSource([]);
  }

  void _showCustomDialog() {
    String? tempSelectedMonth = selectedMonth;
    String? tempSelectedYear = selectedYear;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Tìm Kiếm",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff6849ef),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      menuMaxHeight: 200,
                      decoration: InputDecoration(
                        labelText: 'Tháng',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: const Color(0xff6849ef).withOpacity(0.8),
                            width: 0.5,
                          ),
                        ),
                      ),
                      value: tempSelectedMonth,
                      items: items_month.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          tempSelectedMonth = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      menuMaxHeight: 200,
                      decoration: InputDecoration(
                        labelText: 'Năm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: const Color(0xff6849ef).withOpacity(0.8),
                            width: 0.5,
                          ),
                        ),
                      ),
                      value: tempSelectedYear,
                      items: items_year.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          tempSelectedYear = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Hủy"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedMonth = tempSelectedMonth;
                        selectedYear = tempSelectedYear;
                      });
                      getDataTimeKeep(
                          widget.emp_code, selectedMonth!, selectedYear!);
                      Navigator.pop(context); // Đóng Dialog
                    },
                    child: const Text("Chọn"),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  String formatCycleText(String selectedMonth) {
    int selectedMonthInt = int.parse(selectedMonth);
    int previousMonthInt = selectedMonthInt - 1;
    if (previousMonthInt == 0) {
      previousMonthInt = 12;
    }
    String formattedPreviousMonth =
        previousMonthInt < 10 ? '0$previousMonthInt' : '$previousMonthInt';
    String formattedCurrentMonth =
        selectedMonthInt < 10 ? '0$selectedMonthInt' : '$selectedMonthInt';
    return '(Chu Kì 26/$formattedPreviousMonth - 25/$formattedCurrentMonth)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          AppBarForm(
              title_: 'Bảng Công Tháng',
              title_1: title2_appbar,
              width_: 110,
              icon_: Ionicons.search_sharp,
              onTapLeftBtn: () {
                _showCustomDialog();
              }),
          Expanded(
            child: isLoadingData
                ? const Center(child: CircularProgressIndicator())
                : _Lists.isEmpty
                    ? const Center(
                        child: Text('Không có dữ liệu.',
                            style: TextStyle(fontSize: 15)))
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SfDataGridTheme(
                          data: SfDataGridThemeData(
                              filterIconColor: Colors.orange.shade800,
                              // filterIconHoverColor: Colors.purple,
                              frozenPaneLineColor: Colors.grey.shade400,
                              headerColor: Colors.transparent,
                              sortIconColor: Colors.orange.shade800),
                          child: SfDataGrid(
                            //    columnWidthMode: ColumnWidthMode.fill,
                            // gridLinesVisibility: GridLinesVisibility.horizontal,
                            // headerGridLinesVisibility: GridLinesVisibility.horizontal,
                            selectionMode: SelectionMode.multiple,
                            columnWidthMode: ColumnWidthMode.auto,
                            allowFiltering: true,
                            allowSorting: true,

                            source: _timekeepDataSource,

                            onFilterChanged: (details) => {
                              setState(() {
                                isFilterApplied = true;
                              })
                            },
                            columns: <GridColumn>[
                              GridColumn(
                                  autoFitPadding:
                                      const EdgeInsets.only(left: 25),
                                  filterPopupMenuOptions:
                                      const FilterPopupMenuOptions(
                                          filterMode:
                                              FilterMode.checkboxFilter),
                                  columnName: 'ngay',
                                  maximumWidth: 120,
                                  label: const buildTitleDataColumn(
                                      name_title1: "NGÀY",
                                      name_title2: '(DATE)')),
                              GridColumn(
                                  columnName: 'thu',
                                  allowFiltering: false,
                                  allowSorting: false,
                                  label: const buildTitleDataColumn(
                                      name_title1: "THỨ",
                                      name_title2: '(DAY)')),
                              GridColumn(
                                  columnName: 'gio_vao',
                                  allowFiltering: false,
                                  allowSorting: false,
                                  minimumWidth: 90,
                                  label: const buildTitleDataColumn(
                                      name_title1: "GIỜ VÀO",
                                      name_title2: '(CHECK-IN)')),
                              GridColumn(
                                  columnName: 'gio_ra',
                                  allowFiltering: false,
                                  allowSorting: false,
                                  minimumWidth: 100,
                                  label: const buildTitleDataColumn(
                                      name_title1: "GIỜ RA",
                                      name_title2: '(CHECK-OUT)')),
                              GridColumn(
                                  columnName: 'so_gio',
                                  allowFiltering: false,
                                  allowSorting: false,
                                  label: const buildTitleDataColumn(
                                      name_title1: "SỐ GIỜ",
                                      name_title2: '(HOUR)')),
                              GridColumn(
                                  columnName: 'tc_150',
                                  allowFiltering: false,
                                  allowSorting: false,
                                  label: const buildTitleDataColumn(
                                      name_title1: "TC 150",
                                      name_title2: 'OT 150')),
                              GridColumn(
                                  columnName: 'ghi_chu',
                                  allowFiltering: false,
                                  allowSorting: false,
                                  label: const buildTitleDataColumn(
                                      name_title1: "GHI CHÚ",
                                      name_title2: 'REMARK')),
                            ],
                            frozenColumnsCount: 1, // Cố định cột đầu tiên
                          ),
                        ),
                      ),
          ),
          if (isFilterApplied)
            MaterialButton(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text('Xóa bộ lọc',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange.shade800)),
                onPressed: () {
                  _timekeepDataSource.clearFilters();

                  setState(() {
                    isFilterApplied = false; // Ẩn nút sau khi xóa
                  });
                }),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   mini: true,
      //   onPressed: _showCustomDialog,
      //   tooltip: 'Search',
      //   child: const Icon(Icons.search),
      // ),
    );
  }
}

class TimekeepDataSource extends DataGridSource {
  List<DataGridRow> _timekeepRows = [];

  TimekeepDataSource(List<TimeKeepModel> timekeeps) {
    _timekeepRows = timekeeps.map<DataGridRow>((timekeep) {
      return DataGridRow(cells: [
        DataGridCell<DateTime>(
            columnName: 'ngay',
            value: timekeep.dATEOFMONTH != null
                ? DateTime.parse(timekeep.dATEOFMONTH!)
                : DateTime(0)),
        DataGridCell<String>(
            columnName: 'thu', value: timekeep.dATENAME ?? '-'),
        DataGridCell<String>(
            columnName: 'gio_vao',
            value: timekeep.tIMECHECKIN != null &&
                    DateFormat('HH:mm:ss')
                            .format(DateTime.parse(timekeep.tIMECHECKIN!)) !=
                        '00:00:00'
                ? DateFormat('HH:mm:ss')
                    .format(DateTime.parse(timekeep.tIMECHECKIN!))
                : '-'),
        DataGridCell<String>(
            columnName: 'gio_ra',
            value: timekeep.tIMECHECKOUT != null &&
                    DateFormat('HH:mm:ss')
                            .format(DateTime.parse(timekeep.tIMECHECKOUT!)) !=
                        '00:00:00'
                ? DateFormat('HH:mm:ss')
                    .format(DateTime.parse(timekeep.tIMECHECKOUT!))
                : '-'),
        DataGridCell<String>(
            columnName: 'so_gio',
            value: timekeep.hOURWORK.toString() != "0.0"
                ? timekeep.hOURWORK.toString()
                : '-'),
        DataGridCell<String>(
            columnName: 'tc_150',
            value: timekeep.oTWORK.toString() != "0.0"
                ? timekeep.oTWORK.toString()
                : '-'),
        DataGridCell<String>(
            columnName: 'ghi_chu',
            value: timekeep.rEMARK.toString().isEmpty
                ? '-'
                : timekeep.rEMARK ?? '-'),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _timekeepRows;

  // Phương thức cần triển khai cho DataGridSource
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    var dayName =
        row.getCells().firstWhere((cell) => cell.columnName == 'thu').value;
    Color rowColor = (dayName == 'SUN')
        ? Colors.grey.withOpacity(0.3) // Màu nền cho hàng 'SUN'
        : Colors.transparent; // Màu nền mặc định

    return DataGridRowAdapter(
      color: rowColor,
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          alignment: Alignment.center,
          child: Text(
            dataGridCell.columnName == 'ngay'
                ? DateFormat('dd/MM/yyyy').format(dataGridCell.value)
                : dataGridCell.value.toString(),
          ),
        );
      }).toList(),
    );
  }
}
