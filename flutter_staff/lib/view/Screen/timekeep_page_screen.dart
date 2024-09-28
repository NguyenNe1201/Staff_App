import 'dart:ui';
//import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/timeKeeps.dart';
import 'package:flutter_staff/view/Widget/dropdown_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_staff/view/Widget/datatable_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import '../../models/logListMonths.dart';
import 'package:ionicons/ionicons.dart';

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
  Future<void> getDataLogList(String code,String month,String year) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<LogListMonthModel> loglists =
          await apiHandler.fetchLogListEmpByMonth(code,month,year);
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
    list_year();
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
                      getDataLogList(widget.emp_code.toString(),tempSelectedMonth.toString(),tempSelectedYear.toString());
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
              onTapLeftBtn: () {_showCustomDialog();}),
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
                          ? const Center(child: Text('Không có dữ liệu.',
                            style: TextStyle(fontSize: 15)))
                          : DataTable(
                              headingRowHeight: 60,
                              columnSpacing: 20,
                              columns: const <DataColumn>[
                                DataColumn(
                                    label: buildTitleDataColumn(
                                        name_title1: "NGÀY",
                                        name_title2: "(DATE)")),
                                DataColumn(
                                    label: buildTitleDataColumn(
                                        name_title1: "GIỜ QUÉT",
                                        name_title2: "(SCAN TIME)")),
                                DataColumn(
                                    label: buildTitleDataColumn(
                                        name_title1: "TÊN MÁY",
                                        name_title2: "(DEVICE NAME)")),
                              ],
                              
                              rows: _lists.asMap().entries.map((entry) {
                                int index = entry.key;
                                var loglists = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      buildContentDataCell(
                                        content: loglists.dATECHECK != null
                                            ? DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                    loglists.dATECHECK!))
                                            : '-',
                                      ),
                                    ),
                                    DataCell(buildContentDataCell(
                                        content: (loglists.tIMECHECK ?? "-"))),
                                    DataCell(Container(
                                      alignment: Alignment.topCenter,
                                      width: 100,
                                      child: buildContentDataCell(
                                          content: loglists.nM ?? '-'),
                                    )),
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
                        child: SfDataGrid(
                          //    columnWidthMode: ColumnWidthMode.fill,
                          // gridLinesVisibility: GridLinesVisibility.horizontal,
                          // headerGridLinesVisibility: GridLinesVisibility.horizontal,
                          selectionMode: SelectionMode.multiple,
                          columnWidthMode: ColumnWidthMode.auto,
                          allowFiltering: true,
                          source: _timekeepDataSource,
                          columns: <GridColumn>[
                            GridColumn(
                                //filterIconPadding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                filterPopupMenuOptions:
                                    const FilterPopupMenuOptions(
                                        filterMode: FilterMode.checkboxFilter),
                                columnName: 'ngay',
                                allowSorting: true,
                                label: const buildTitleDataColumn(
                                    name_title1: "NGÀY",
                                    name_title2: '(DATE)')),
                            GridColumn(
                                columnName: 'thu',
                                allowFiltering: false,
                                label: const buildTitleDataColumn(
                                    name_title1: "THỨ", name_title2: '(DAY)')),
                            GridColumn(
                                columnName: 'gio_vao',
                                allowFiltering: false,
                                label: const buildTitleDataColumn(
                                    name_title1: "GIỜ VÀO",
                                    name_title2: '(CHECK-IN)')),
                            GridColumn(
                                columnName: 'gio_ra',
                                allowFiltering: false,
                                minimumWidth: 100,
                                label: const buildTitleDataColumn(
                                    name_title1: "GIỜ RA",
                                    name_title2: '(CHECK-OUT)')),
                            GridColumn(
                                columnName: 'so_gio',
                                allowFiltering: false,
                                label: const buildTitleDataColumn(
                                    name_title1: "SỐ GIỜ",
                                    name_title2: '(HOUR)')),
                            GridColumn(
                                columnName: 'tc_150',
                                allowFiltering: false,
                                label: const buildTitleDataColumn(
                                    name_title1: "TC 150",
                                    name_title2: 'OT 150')),
                            GridColumn(
                                columnName: 'ghi_chu',
                                allowFiltering: false,
                                label: const buildTitleDataColumn(
                                    name_title1: "GHI CHÚ",
                                    name_title2: 'REMARK')),
                          ],
                          frozenColumnsCount: 1, // Cố định cột đầu tiên
                        ),
                      ),
          ),
          // _Lists.isEmpty
          //     ? const Center(child: null)
          //     : MaterialButton(
          //         child: Text('Xóa bộ lọc',
          //             style: TextStyle(
          //                 fontSize: 15,
          //                 fontWeight: FontWeight.w700,
          //                 color: Colors.orange.shade800)),
          //         onPressed: () {
          //           _timekeepDataSource.clearFilters();
          //         }),
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
        DataGridCell<String>(
            columnName: 'ngay',
            value: timekeep.dATEOFMONTH != null
                ? DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(timekeep.dATEOFMONTH!))
                : '-'),
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
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          alignment: Alignment.center,
          child: Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
}
