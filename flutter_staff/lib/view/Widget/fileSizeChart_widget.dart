import 'package:flutter/cupertino.dart';

class buildFileSizeChart extends StatelessWidget {
  final Color? color_;
  final String title_;
  final double width_;
  final double availableScreenWidth ;
  buildFileSizeChart({super.key,required this.title_,required this.color_,required this.width_, required this.availableScreenWidth});

  @override
 // double availableScreenWidth = 0;
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: availableScreenWidth * width_,
          height: 4,
          color: color_,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          title_,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
