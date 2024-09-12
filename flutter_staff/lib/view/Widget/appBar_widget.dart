import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarForm extends StatelessWidget {
  final String title_;
  const AppBarForm({super.key, required this.title_});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(color: Color(0xff886ff2)),
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context, 'Data from HomePage');
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
           Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title_,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.contact_support_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
