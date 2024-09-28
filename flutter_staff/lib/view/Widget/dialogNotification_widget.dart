import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialogNotification extends StatelessWidget {
  final String title;
  final String content;
  const MyDialogNotification(
      {super.key, required this.content, required this.title});
  // Phương thức hiển thị dialog
  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xff6849ef),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Trả về một widget bất kỳ, ví dụ Container rỗng
  }
}
// ================================= ===================================
// class DialogSearchMonthYear extends StatefulWidget {
//   final String title;
//   const DialogSearchMonthYear({super.key, required this.title});

//   @override
//   State<DialogSearchMonthYear> createState() => _DialogSearchMonthYearState();
// }

// class _DialogSearchMonthYearState extends State<DialogSearchMonthYear> {
//   void showMyDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             widget.title,
//             style: const TextStyle(
//               color: Color(0xff6849ef),
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       menuMaxHeight: 200,
//                       decoration: InputDecoration(
//                         labelText: 'Tháng',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14),
//                           borderSide: BorderSide(
//                             color: const Color(0xff6849ef).withOpacity(0.8),
//                             width: 0.5,
//                           ),
//                         ),
//                       ),
//                       value: tempSelectedMonth,
//                       items: items_month.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           tempSelectedMonth = newValue;
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       menuMaxHeight: 200,
//                       decoration: InputDecoration(
//                         labelText: 'Năm',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14),
//                           borderSide: BorderSide(
//                             color: const Color(0xff6849ef).withOpacity(0.8),
//                             width: 0.5,
//                           ),
//                         ),
//                       ),
//                       value: tempSelectedYear,
//                       items: items_year.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           tempSelectedYear = newValue;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 // crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("Hủy"),
//                   ),
//                   const SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         selectedMonth = tempSelectedMonth;
//                         selectedYear = tempSelectedYear;
//                       });
//                       getDataTimeKeep(
//                           widget.emp_code, selectedMonth!, selectedYear!);
//                       Navigator.pop(context); // Đóng Dialog
//                     },
//                     child: const Text("Chọn"),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(); 
//   }
// }
