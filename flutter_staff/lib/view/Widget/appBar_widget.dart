import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ionicons/ionicons.dart';

//AppBar for all page
class AppBarForm extends StatelessWidget {
  final String title_;
  final String? title_1;
  final double width_;
  final Function()? onTapLeftBtn;
  final IconData icon_;
  const AppBarForm(
      {super.key,
      required this.title_,
      this.title_1,
      required this.width_,
      this.onTapLeftBtn,
      required this.icon_});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(color: Color(0xff886ff2)),
      height: width_,
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              if (title_1 != null)
                Text(
                  title_1 ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: onTapLeftBtn,
                icon: Icon(
                  // Icons.contact_support_outlined,
                  // Ionicons.search_sharp,
                  //  Iconsax.,
                  icon_,
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

// Appbar home page
class AppBarHomePage extends StatelessWidget {
  final String fullName;
  const AppBarHomePage({
    Key? key,
    required this.fullName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      height: 100,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5],
          colors: [
            Color(0xff886ff2),
            Color(0xff6849ef),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Xin Chào, \n $fullName",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff8a72f1),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }
}
