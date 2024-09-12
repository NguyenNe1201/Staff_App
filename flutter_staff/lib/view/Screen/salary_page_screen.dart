import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/models/salarys.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:flutter_staff/view/Widget/dropdown_widget.dart';

class SalaryPage extends StatefulWidget {
  final String emp_code;
  const SalaryPage({super.key, required this.emp_code});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  final ApiServices apiService = ApiServices();
  SalaryModel? infoSalary;
  String? selectedMonth;
  String? selectedYear;
  bool _isButtonEnabled = false;
  bool _isMonthDropdownOpened = false;
  bool _isYearDropdownOpened = false;
  bool isLoadingData = false;
  String Salary_total_2 = "";
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

  @override
  void initState() {
    super.initState();
    list_year();
  }

  Future<void> getDataSalary(String code, String value) async {
    setState(() {
      isLoadingData = true;
    });
    try {
      SalaryModel? info_salary =
          await apiService.fetchGetSalaryEmp(widget.emp_code, value);
      setState(() {
        infoSalary = info_salary;
        setState(() {
          isLoadingData = false;
        });
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
      //   print(e);
      setState(() {
        isLoadingData = false;
      });
    }
  }

  void calculateSalaryTotal2() {
    if (infoSalary != null) {
      String salaryTotal2 = ((infoSalary!.eSOCIALPAY ?? 0) +
              (infoSalary!.eMEDICALPAY ?? 0) +
              (infoSalary!.eJOBPAY ?? 0))
          .toString();
      setState(() {
        Salary_total_2 = salaryTotal2;
      });
    }
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
    return '(CHU KÌ 26/$formattedPreviousMonth - 25/$formattedCurrentMonth)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const AppBarForm(title_: "Salary"),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDropdown(
                  'month',
                  items_month,
                  120,
                  selectedMonth,
                  (String? value) {
                    setState(() {
                      selectedMonth = value;
                      _isButtonEnabled =
                          selectedMonth != null && selectedYear != null;
                    });
                  },
                  _isMonthDropdownOpened, // Trạng thái mở/đóng cho tháng
                  (bool isOpen) {
                    setState(() {
                      _isMonthDropdownOpened = isOpen;
                    });
                  },
                ),
                const SizedBox(width: 10),
                buildDropdown(
                  'year',
                  items_year,
                  120,
                  selectedYear,
                  (String? value) {
                    setState(() {
                      selectedYear = value;
                      _isButtonEnabled =
                          selectedMonth != null && selectedYear != null;
                    });
                  },
                  _isYearDropdownOpened, // Trạng thái mở/đóng cho năm
                  (bool isOpen) {
                    setState(() {
                      _isYearDropdownOpened = isOpen;
                    });
                  },
                ),
                const SizedBox(width: 10),
                buildButtonSearch(
                    _isButtonEnabled,
                    Icons.search,
                    const Color(0xff886ff2).withOpacity(0.9),
                    selectedYear.toString() + selectedMonth.toString()),
              ],
            ),
          ),
          const Divider(thickness: 0.2),
          isLoadingData
              ? const Center(child: CircularProgressIndicator())
              : infoSalary == null
                  ? const Center(child: Text('No data found'))
                  : Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'THU NHẬP THÁNG ${selectedMonth}/${selectedYear}',
                                      style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text(
                                      formatCycleText(selectedMonth ?? '01'),
                                      style: const TextStyle(
                                          color: Colors.black87, fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              buildTBodySalary("Số Ngày Công (tiêu chuẩn)",
                                  infoSalary!.dAYWORK.toString()),
                              buildTBodySalary("Tổng Số Ngày Công",
                                  infoSalary!.tOTALDAY.toString()),
                              const Divider(thickness: 0.3),
                              buildTBodySalary("Lương Cơ Bản",
                                  infoSalary!.bASICSALARY.toString()),
                              buildTBodySalary("Phụ Cấp Theo HĐLĐ",
                                  infoSalary!.tOTALALL.toString()),
                              buildTBodySalary("Phụ Cấp Khác", "1.000.000"),
                              buildTBodySalary("Tăng Ca", "500.000"),
                              buildTbodyTotal('Tổng Thu Nhập (I)', '7.500.000'),
                              const Divider(thickness: 0.3),
                              buildTBodySalary("Bảo Hiểm Xã Hội (8%)",
                                  infoSalary!.eSOCIALPAY.toString()),
                              buildTBodySalary("Bảo Hiểm Y Tế (1.5%)",
                                  infoSalary!.eMEDICALPAY.toString()),
                              buildTBodySalary("Bảo Hiểm Thất Nghiệp (1%)",
                                  infoSalary!.eJOBPAY.toString()),
                              buildTbodyTotal(
                                  'Tổng Các Khoản Phải Nộp (II)',
                                  Salary_total_2.isNotEmpty
                                      ? Salary_total_2
                                      : ""),
                              const Divider(thickness: 0.3),
                              buildTbodyTotal('Phí Công Đoàn (III)',
                                  infoSalary!.uNIONPAY.toString()),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xffed8b34),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                    child: Column(
                                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Thực Lãnh/Net Income (I)-(II)-(III)',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "6.700.000 đ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ],
                                )),
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

  Widget buildTbodyTotal(String _title, String _content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _title,
            style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          Text(
            _content,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget buildTBodySalary(String _title, String _content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _title,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          Text(
            _content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildButtonSearch(
      bool _isbtn, IconData? _icon, Color _color, String _value) {
    return GestureDetector(
      onTap: _isbtn
          ? () async {
              // setState(() {
              //   isLoadingData = true;
              // });
              // SalaryModel? info_salary =
              //     await apiService.fetchGetSalaryEmp(widget.emp_code, _value);
              // setState(() {
              //   infoSalary = info_salary;
              //   setState(() {
              //     isLoadingData = false;
              //   });
              // });
              getDataSalary(widget.emp_code,_value);
            }
          : null,
      child: Container(
        width: 70,
        height: 40,
        decoration: BoxDecoration(
            color: _isbtn ? _color : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(_icon, color: _isbtn ? Colors.white : Colors.grey.shade400),
      ),
    );
  }

  Center buildDropdown(
    String _title,
    List<String> _item_list,
    double? _width,
    String? _selectedValue,
    Function(String?) _onChanged,
    bool isDropdownOpened, // Thêm biến này để kiểm soát trạng thái của dropdown
    Function(bool)
        onMenuStateChange, // Thêm biến này để cập nhật trạng thái dropdown
  ) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            children: [
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  _title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: _item_list
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: _selectedValue,
          onChanged: (value) {
            _onChanged(value);
            setState(() {
              isDropdownOpened =
                  false; // Đặt lại trạng thái khi thay đổi giá trị
            });
          },
          onMenuStateChange: (isOpen) {
            // Lắng nghe trạng thái menu để thay đổi icon
            onMenuStateChange(isOpen); // Cập nhật trạng thái dropdown cụ thể
          },
          buttonStyleData: ButtonStyleData(
            height: 40,
            width: _width,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xff6849ef).withOpacity(0.8),
              ),
              color: Colors.white,
            ),
            elevation: 2,
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              isDropdownOpened
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
            ),
            iconSize: 20,
            // iconEnabledColor: Colors.black87,
            // iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            // offset: const Offset(-20, 0),
            // scrollbarTheme: ScrollbarThemeData(
            //   radius: const Radius.circular(40),
            //   thickness: MaterialStateProperty.all<double>(6),
            //   thumbVisibility: MaterialStateProperty.all<bool>(true),
            // ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
