import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final double? width_;
  const MyInputField(
      {super.key, required this.hint, this.controller, this.widget, this.width_});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: width_,
      height: 45,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 10,right: 1),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border: Border.all(
            color: const Color(0xff6849ef).withOpacity(0.8),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            readOnly: widget == null ? false : true,
            autofocus: false,
            controller: controller,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700]),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700]),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: const Color(0xff6849ef).withOpacity(0.8),
                width: 0,
              )),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: const Color(0xff6849ef).withOpacity(0.8),
                width: 0,
              )),
            ),
          ),
          ),
          widget==null?Container():Container(child: widget,)
        ],
      ),
    );
  }
}
