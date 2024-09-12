import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ForwardButton extends StatelessWidget {
  final Function() onTop;
  const ForwardButton({super.key, required this.onTop});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTop,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(Ionicons.chevron_forward_outline),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String title_;
  final Function() onTap_;
  const MyButton({super.key, required this.title_, required this.onTap_});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap_,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Container(
          //margin: const EdgeInsets.only(top: 15),
          //  padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xff6849ef),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title_,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ArrowRightBtn extends StatelessWidget {
  final Function() onTap_;
  const ArrowRightBtn({
    super.key, required this.onTap_,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap_,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(Ionicons.chevron_forward_outline),
      ),
    );
  }
}
