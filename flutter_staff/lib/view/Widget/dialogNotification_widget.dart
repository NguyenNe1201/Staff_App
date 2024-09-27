import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class MyDialogNotification extends StatelessWidget {
  final String title;
  final String content;
  const MyDialogNotification({super.key, required this.content, required this.title});
  // Phương thức hiển thị dialog
  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style:const TextStyle(
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
    return Container(
    ); // Trả về một widget bất kỳ, ví dụ Container rỗng
  }
}
