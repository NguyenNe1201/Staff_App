import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_staff/models/leaves.dart';
import 'package:flutter_staff/view/Widget/appBar_widget.dart';
import 'package:flutter_staff/view/Widget/boxCountLeave_widget.dart';
import 'package:flutter_staff/data_sources/api_services.dart';
import 'package:flutter_staff/view/Widget/button_widget.dart';
import 'package:flutter_staff/view/Widget/dialogNotification_widget.dart';
import 'package:flutter_staff/view/Widget/dropdown_widget.dart';
import 'package:flutter_staff/view/Widget/inputField_widget.dart';

// ------------------------------- form nghỉ phép ------------------------------
class LeavePage extends StatefulWidget {
  final String emp_code;
  final int emp_id;
  const LeavePage({super.key, required this.emp_code, required this.emp_id});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final ApiServices apiServices = ApiServices();
  bool showAll = false;
  double availableScreenWidth = 0;
  CalLeaveModel? CalLeave_model;
  CountWaitLeaveModel? CountWaitLeave_model;
  String year_current = DateFormat('yyyy').format(DateTime.now());
  void toggleShowAll() {
    setState(() {
      showAll = !showAll;
    });
  }

  Future<void> getCalLeaveByEmpID(int empID) async {
    try {
      var cal_leave = await apiServices.fetchGetCalLeave(empID);
      var countWaitLeave = await apiServices.fetchGetCountWaitingLeave(empID);
      if (cal_leave != null) {
        setState(() {
          CalLeave_model = cal_leave;
          CountWaitLeave_model = countWaitLeave;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to fetch employee data: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    getCalLeaveByEmpID(widget.emp_id);
  }

  @override
  Widget build(BuildContext context) {
    availableScreenWidth = MediaQuery.of(context).size.width - 50;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const AppBarForm(
              title_: 'Nghỉ Phép',
              width_: 100,
              icon_: Icons.contact_support_outlined),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              children: [
                Column(
                  children: [
                    //  Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phép năm - $year_current",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildBoxCountLeave(
                          title_: 'Tổng',
                          number_:
                              CalLeave_model?.aNUALLEAVEDAY.toString() ?? "0",
                          colors_: const Color(0xfff62d51).withOpacity(0.8),
                          availableScreenWidth_: availableScreenWidth,
                          with_: .31,
                        ),
                        const SizedBox(width: 10),
                        buildBoxCountLeave(
                            title_: 'Sử dụng',
                            number_: CalLeave_model?.tONGCONG.toString() ?? "0",
                            colors_: const Color(0xff55ce63).withOpacity(0.8),
                            availableScreenWidth_: availableScreenWidth,
                            with_: .31),
                        const SizedBox(width: 10),
                        buildBoxCountLeave(
                            title_: "Còn lại",
                            number_: CalLeave_model?.rEMAIN.toString() ?? "0",
                            colors_: Colors.orange.shade800.withOpacity(0.8),
                            availableScreenWidth_: availableScreenWidth,
                            with_: .31),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chi tiết',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        // GestureDetector(
                        //   onTap: toggleShowAll,
                        //   child: Text(
                        //     "Tất cả",
                        //     style: TextStyle(
                        //         fontSize: 17,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.blue.shade300),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewLeavePage(
                                      empId: widget.emp_id,
                                      empCode: widget.emp_code)),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xff886ff2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Ionicons.add,
                              color: Colors.white,
                              size: 30,
                              weight: 2,
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    buildBoxLeaveByMonth(
                        'Tháng 1',
                        CalLeave_model?.t1.toString() ?? "",
                        CountWaitLeave_model?.wAITINGLEAVET1.toString() ?? "",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaveDetailsPage(
                              month: 1,
                              emp_id: widget.emp_id,
                              emp_code: widget.emp_code),
                        ),
                      );
                    }),
                    buildBoxLeaveByMonth(
                        'Tháng 2',
                        CalLeave_model?.t2.toString() ?? "",
                        CountWaitLeave_model?.wAITINGLEAVET2.toString() ?? "",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaveDetailsPage(
                                month: 2,
                                emp_id: widget.emp_id,
                                emp_code: widget.emp_code)),
                      );
                    }),
                    buildBoxLeaveByMonth(
                        'Tháng 3',
                        CalLeave_model?.t3.toString() ?? "",
                        CountWaitLeave_model?.wAITINGLEAVET3.toString() ?? "",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaveDetailsPage(
                                month: 3,
                                emp_id: widget.emp_id,
                                emp_code: widget.emp_code)),
                      );
                    }),
                    buildBoxLeaveByMonth(
                        'Tháng 4',
                        CalLeave_model?.t4.toString() ?? "",
                        CountWaitLeave_model?.wAITINGLEAVET4.toString() ?? "",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaveDetailsPage(
                                month: 4,
                                emp_id: widget.emp_id,
                                emp_code: widget.emp_code)),
                      );
                    }),
                    buildBoxLeaveByMonth(
                        'Tháng 5',
                        CalLeave_model?.t5.toString() ?? "",
                        CountWaitLeave_model?.wAITINGLEAVET5.toString() ?? "",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaveDetailsPage(
                                month: 5,
                                emp_id: widget.emp_id,
                                emp_code: widget.emp_code)),
                      );
                    }),
                    if (showAll) ...[
                      buildBoxLeaveByMonth(
                          'Tháng 6',
                          CalLeave_model?.t6.toString() ?? "",
                          CountWaitLeave_model?.wAITINGLEAVET6.toString() ?? "",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeaveDetailsPage(
                                  month: 6,
                                  emp_id: widget.emp_id,
                                  emp_code: widget.emp_code)),
                        );
                      }),
                      buildBoxLeaveByMonth(
                          'Tháng 7',
                          CalLeave_model?.t7.toString() ?? "",
                          CountWaitLeave_model?.wAITINGLEAVET7.toString() ?? "",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeaveDetailsPage(
                                  month: 7,
                                  emp_id: widget.emp_id,
                                  emp_code: widget.emp_code)),
                        );
                      }),
                      buildBoxLeaveByMonth(
                          'Tháng 8',
                          CalLeave_model?.t8.toString() ?? "",
                          CountWaitLeave_model?.wAITINGLEAVET8.toString() ?? "",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeaveDetailsPage(
                                  month: 8,
                                  emp_id: widget.emp_id,
                                  emp_code: widget.emp_code)),
                        );
                      }),
                      buildBoxLeaveByMonth(
                          'Tháng 9',
                          CalLeave_model?.t9.toString() ?? "",
                          CountWaitLeave_model?.wAITINGLEAVET9.toString() ?? "",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeaveDetailsPage(
                                  month: 9,
                                  emp_id: widget.emp_id,
                                  emp_code: widget.emp_code)),
                        );
                      }),
                      buildBoxLeaveByMonth(
                          'Tháng 10',
                          CalLeave_model?.t10.toString() ?? "",
                          CountWaitLeave_model?.wAITINGLEAVET10.toString() ??
                              "", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeaveDetailsPage(
                                  month: 10,
                                  emp_id: widget.emp_id,
                                  emp_code: widget.emp_code)),
                        );
                      }),
                      buildBoxLeaveByMonth(
                          'Tháng 11',
                          CalLeave_model?.t11.toString() ?? "",
                          CountWaitLeave_model?.wAITINGLEAVET11.toString() ??
                              "", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeaveDetailsPage(
                                  month: 11,
                                  emp_id: widget.emp_id,
                                  emp_code: widget.emp_code)),
                        );
                      }),
                      buildBoxLeaveByMonth(
                          'Tháng 12',
                          CalLeave_model?.t12.toString() ?? "",
                          CountWaitLeave_model?.wAITINGLEAVET12.toString() ??
                              "", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeaveDetailsPage(
                                  month: 12,
                                  emp_id: widget.emp_id,
                                  emp_code: widget.emp_code)),
                        );
                      }),
                    ],
                    GestureDetector(
                      onTap: toggleShowAll,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xff886ff2).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              showAll == false
                                  ? Icons.arrow_circle_down
                                  : Icons.arrow_circle_up,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              showAll == true ? 'Rút gọn' : 'Nhiều hơn',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBoxLeaveByMonth(
      String foldername, String s_leave, String w_leave, VoidCallback _onTap) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 65,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 4.0,
                spreadRadius: .05,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    foldername,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (s_leave != "0.0" && s_leave != "" && s_leave != "0")
                    Container(
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xffcff6dd),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          s_leave,
                          style: const TextStyle(
                              color: Color(0xff1fa750),
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  if (s_leave != "0.0" && s_leave != "" && s_leave != "0")
                    const SizedBox(width: 10),
                  if (w_leave != "0" && w_leave != "")
                    Container(
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xfffde6d8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          w_leave,
                          style: const TextStyle(
                              color: Color(0xffF5803E),
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Expanded(
            //   flex: 4,
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Text(
            //       _value,
            //       style: const TextStyle(
            //         fontWeight: FontWeight.w600,
            //         color: Colors.black,
            //         fontSize: 15,
            //       ),
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //   ),
            // ),
            Expanded(
              //flex: 5,
              child: Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Ionicons.chevron_forward_outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBtnAddLeave() {
    return GestureDetector(
      child: Container(
        width: 140,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xff46C946),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_box,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Thêm mới",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------ form tạo phép nhân viên ------------------------------
class NewLeavePage extends StatefulWidget {
  final int? empId;
  final String? empCode;
  const NewLeavePage({super.key, required this.empId, required this.empCode});

  @override
  State<NewLeavePage> createState() => _NewLeavePageState();
}

class _NewLeavePageState extends State<NewLeavePage> {
  final ApiServices apiService = ApiServices();
  String? selectedLeaveType;
  String? selectedPeriod;
  int? selectedKindLeaveID;
  bool _isPeriodDropdownOpened = false;
  bool _isKindLeaveDropdownOpened = false;
  TextEditingController reasonController = TextEditingController();
  final List<String> items_LeavePeriod = ['8h', '4h'];
  String _selectedToDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String _selectedFromDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  List<KindLeaveModel> kindLeaveList = [];
  List<String> kindLeaveNames = [];
  List<int> kindLeaveID = [];
  Future<void> getDataAllKindLeave() async {
    try {
      List<KindLeaveModel> lists = await apiService.fetchAllKindLeave();
      setState(() {
        kindLeaveList = lists;
        kindLeaveNames = kindLeaveList.map((e) => e.nAMELEAVEVI ?? '').toList();
        kindLeaveID = kindLeaveList.map((e) => e.kINDLEAVEID ?? 0).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getDataAllKindLeave();
  }

  // Hàm để chọn ngày bắt đầu
  _getFromDate() async {
    DateTime? _pickerFromDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2100),
    );
    if (_pickerFromDate != null) {
      setState(() {
        _selectedFromDate = DateFormat('dd/MM/yyyy').format(_pickerFromDate);
        if (_pickerFromDate
            .isAfter(DateFormat('dd/MM/yyyy').parse(_selectedToDate))) {
          _selectedToDate = _selectedFromDate;
        }
      });
    }
  }

  // Hàm để chọn ngày kết thúc
  _getToDate() async {
    DateTime? _pickerToDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2100),
    );
    if (_pickerToDate != null) {
      if (_pickerToDate
          .isBefore(DateFormat('dd/MM/yyyy').parse(_selectedFromDate))) {
        const MyDialogNotification(
                title: 'Thông báo',
                content: "Ngày kết thúc không được nhỏ hơn ngày bắt đầu.")
            .showMyDialog(context);
      } else {
        setState(() {
          _selectedToDate = DateFormat('dd/MM/yyyy').format(_pickerToDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBarForm(
              title_: "Tạo Phép",
              width_: 100,
              icon_: Icons.contact_support_outlined),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Từ ngày',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          MyInputField(
                            hint: _selectedFromDate,
                            widget: IconButton(
                              icon: const Icon(Icons.calendar_month_outlined),
                              color: Colors.grey[600],
                              onPressed: () {
                                _getFromDate();
                              },
                            ),
                            width_: null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Đến ngày',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          MyInputField(
                            hint: _selectedToDate,
                            widget: IconButton(
                              icon: const Icon(Icons.calendar_month_outlined),
                              color: Colors.grey[600],
                              onPressed: () {
                                _getToDate();
                              },
                            ),
                            width_: null,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Loại phép/Thời gian',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: MyDropdown(
                        title_: "Loại phép",
                        item_list_: kindLeaveNames,
                        selectedValue_: selectedLeaveType,
                        onChanged_: (String? value) {
                          setState(() {
                            selectedLeaveType = value;
                            // Lấy ID tương ứng
                            int index = kindLeaveNames.indexOf(value!);
                            selectedKindLeaveID = kindLeaveID[index];
                          });
                        },
                        isDropdownOpened: _isKindLeaveDropdownOpened,
                        onMenuStateChange: (bool isOpen) {
                          setState(() {
                            _isKindLeaveDropdownOpened = isOpen;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      //flex: 5,
                      child: MyDropdown(
                        title_: "Thời gian",
                        item_list_: items_LeavePeriod,
                        selectedValue_: selectedPeriod,
                        onChanged_: (String? value) {
                          setState(() {
                            selectedPeriod = value;
                          });
                        },
                        isDropdownOpened: _isPeriodDropdownOpened,
                        onMenuStateChange: (bool isOpen) {
                          setState(() {
                            _isPeriodDropdownOpened = isOpen;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Lý do',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                MyInputField(
                    hint: "Nhập lý do chi tiết", controller: reasonController),
                const SizedBox(height: 20),
                MyButton(
                  title_: 'Thêm phép',
                  onTap_: () async {
                    int? hours = selectedPeriod == "4h"
                        ? 4
                        : (selectedPeriod == "8h" ? 8 : 0);
                    if (hours == 0 || selectedKindLeaveID == null) {
                      // print(selectedKindLeaveID.toString());
                      const MyDialogNotification(
                              content: "Vui lòng chọn đầy đủ thông tin.",
                              title: 'Thông báo')
                          .showMyDialog(context);
                    } else {
                      final result = await apiService.fetchAddLeave(
                          widget.empId!,
                          selectedKindLeaveID!,
                          hours,
                          _selectedFromDate,
                          _selectedToDate,
                          reasonController.text);
                      if (result['status'] == true) {
                        //  print("thêm thành công!");
                        const MyDialogNotification(
                                content: "Thêm phép thành công.",
                                title: 'Thông báo')
                            .showMyDialog(context);
                        setState(() {
                          _selectedToDate =
                              DateFormat('dd/MM/yyyy').format(DateTime.now());
                          _selectedFromDate =
                              DateFormat('dd/MM/yyyy').format(DateTime.now());
                          selectedPeriod = null;
                          selectedLeaveType = null;
                          selectedKindLeaveID = null;
                          reasonController.clear();
                        });
                      } else {
                        // thêm không thành công
                        MyDialogNotification(
                                content: result['message'].toString(),
                                title: 'Thông báo')
                            .showMyDialog(context);
                        //  print("Thêm không th ành công: ${result['message']}");
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- form Chi tiết phép nhân viên -----------------------
class LeaveDetailsPage extends StatefulWidget {
  final int month;
  final String emp_code;
  final int emp_id;
  const LeaveDetailsPage(
      {super.key,
      required this.month,
      required this.emp_id,
      required this.emp_code});

  @override
  State<LeaveDetailsPage> createState() => _LeaveDetailsPageState();
}

class _LeaveDetailsPageState extends State<LeaveDetailsPage> {
  final ApiServices apiService = ApiServices();
  bool isLoading = false;
  List<ListLeaveModel> _lists = [];
  Future<void> getDataListLeaveByMonth() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<ListLeaveModel> lists = await apiService.fetchListLeaveEmpIdByMonth(
          widget.emp_id, widget.month);
      setState(() {
        _lists = lists;
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataListLeaveByMonth();
  }

  TextStyle getStatusTextStyle(String status) {
    switch (status) {
      // active
      case "Approved":
        return const TextStyle(
          color: Color(0xff1fa750),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        );
      // deny
      case "Deny":
        return const TextStyle(
          color: Color(0xfffa6767),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        );
      // cancel  backgroundcolor: ac5a2b fde6d8
      case "Cancel":
        return const TextStyle(
          color: Color(0xffac5a2b),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        );
      // request  backgroundcolor: e4f4f9
      case "Request":
        return const TextStyle(
          color: Color(0xff2dadcf),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        );
      // awaiting
      default:
        return const TextStyle(
          color: Color(0xffcfa00c),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const AppBarForm(
              title_: "Chi Tiết Phép",
              width_: 100,
              icon_: Icons.contact_support_outlined),
          // const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: Color(0xff6849ef),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.calendar_month,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 15),
                Column(
                  children: [
                    //const SizedBox(height: 13),
                    Text(
                      "Tháng ${widget.month.toString()}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _lists.isEmpty
                  ? const Center(
                      child: Text(
                      'Không có dữ liệu',
                      style: TextStyle(fontSize: 20),
                    ))
                  : Expanded(
                      child: ListView(
                        children: _lists.asMap().entries.map((entry) {
                          int index = entry.key;
                          ListLeaveModel leave = entry.value;
                          String startDate = DateFormat('EEE, dd/MM/yyyy')
                              .format(DateTime.parse(leave.lEAVESTARTDATE!));
                          return buildBoxLeaveDetailsMonth(
                            leave.hOURS == 8
                                ? "Đơn Xin Cả Ngày"
                                : "Đơn Xin Nữa Ngày",
                            startDate,
                            leave.nAMELEAVEVI ?? "",
                            leave.sTATUSL == 1
                                ? "Approved"
                                : (leave.sTATUSL == 2
                                    ? "Deny"
                                    : (leave.sTATUSL == 3
                                        ? "Cancel"
                                        : (leave.sTATUSL == 4
                                            ? "Request"
                                            : "Awaiting"))),
                          );
                        }).toList(),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget buildBoxLeaveDetailsMonth(String title_leave, String day_leave,
      String annual_type, String status_) {
    return Container(
      margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      height: 95,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 4.0,
            spreadRadius: .05,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title_leave,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600])),
              Text(day_leave,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue.shade900)),
              Text(
                annual_type,
                style: TextStyle(
                  color: Colors.yellow.shade700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //const SizedBox(height: 5),
              Container(
                //     margin: EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 25,
                width: 100,
                decoration: BoxDecoration(
                  color: status_ == "Approved"
                      ? const Color(0xffcff6dd)
                      : (status_ == "Deny"
                          ? const Color(0xfffff0f0)
                          : (status_ == "Cancel"
                              ? const Color(0xfffde6d8)
                              : (status_ == "Request"
                                  ? const Color(0xffe4f4f9)
                                  : const Color(0xfffdf5dd)))),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    status_,
                    style: getStatusTextStyle(status_),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Ionicons.chevron_forward_outline,
                  size: 20,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
