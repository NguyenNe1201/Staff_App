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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                      fontSize: 16, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
