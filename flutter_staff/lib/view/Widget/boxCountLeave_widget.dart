import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class buildBoxCountLeave extends StatelessWidget {
  const buildBoxCountLeave(
      {super.key, required this.title_, required this.number_, this.colors_, required this.availableScreenWidth_, required this.with_});
  final String title_;
  final String number_;
  final Color? colors_;
  final double with_;
  final double availableScreenWidth_ ;
  @override
  Widget build(BuildContext context) {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: availableScreenWidth_ * with_,
          //   height: 90,
          // decoration: BoxDecoration(
          //   color: Colors.white.withOpacity(.9),
          //   borderRadius: BorderRadius.circular(20),
          //    boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(.1),
          //     blurRadius: 4.0,
          //     spreadRadius: .05,
          //   )
          // ],
          // ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors_,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      number_,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Text(
                  title_,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
