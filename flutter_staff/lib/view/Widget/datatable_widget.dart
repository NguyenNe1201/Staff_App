import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class buildContentDataCell extends StatelessWidget {
  final String content;
  const buildContentDataCell({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(content, style: TextStyle(fontSize: 12)));
  }
}

class buildTitleDataColumn extends StatelessWidget {
  final String name_title1;
  final String name_title2;
  const buildTitleDataColumn(
      {super.key, required this.name_title1, required this.name_title2});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      //  widthFactor: 1,
      child: Column(
        children: [
          const SizedBox(height: 3),
          Text(
            name_title1,
            style: TextStyle(
              // fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
              fontSize: 13,
            ),
          ),
          Text(
            name_title2,
            style: TextStyle(
              // fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
