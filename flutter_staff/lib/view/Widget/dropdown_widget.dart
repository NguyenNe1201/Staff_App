import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  final String title_;
  final List<String> item_list_;
  final String? selectedValue_;
  final Function(String?) onChanged_;
  bool isDropdownOpened; // kiểm soát trạng thái của dropdown
  final Function(bool) onMenuStateChange;
  final double? width_;
  final double? height_;
  MyDropdown(
      {super.key,
      required this.title_,
      required this.item_list_,
      this.selectedValue_,
      required this.onChanged_,
      required this.isDropdownOpened,
      required this.onMenuStateChange,
      this.width_,
      this.height_});

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                widget.title_,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: widget.item_list_
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: widget.selectedValue_,
        onChanged: (value) {
          widget.onChanged_(value);
          setState(() {
            widget.isDropdownOpened =
                false; // Đặt lại trạng thái khi thay đổi giá trị
          });
        },
        onMenuStateChange: (isOpen) {
          widget
              .onMenuStateChange(isOpen); // Cập nhật trạng thái dropdown cụ thể
        },
        buttonStyleData: ButtonStyleData(
          height: widget.height_,
          width: widget.width_,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xff6849ef).withOpacity(0.8),
            ),
            color: Colors.white,
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            widget.isDropdownOpened
                ? Icons.keyboard_arrow_up_outlined
                : Icons.keyboard_arrow_down_outlined,
          ),
          iconSize: 20,
          // iconEnabledColor: Colors.black87,
          //  iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          // offset: const Offset(-20, 0),
          // scrollbarTheme: ScrollbarThemeData(
          //   radius: const Radius.circular(40),
          //   thickness: MaterialStateProperty.all<double>(6),
          //   thumbVisibility: MaterialStateProperty.all<bool>(true),
          // ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}

class DropdownLanguage extends StatefulWidget {
  final String? selectedValue_;
  final Function(String?) onChanged_;
  bool isDropdownOpened; // kiểm soát trạng thái của dropdown
  final Function(bool) onMenuStateChange;

  final double? width_;
  final double? height_;
  DropdownLanguage({
    super.key,
    this.selectedValue_,
    required this.onChanged_,
    required this.isDropdownOpened,
    required this.onMenuStateChange,
    this.width_,
    this.height_,
  });

  @override
  State<DropdownLanguage> createState() => _DropdownLanguageState();
}

class _DropdownLanguageState extends State<DropdownLanguage> {
  final List<String> itemsLanguage = ['Tiếng việt', 'English'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        value: widget.selectedValue_, // Đảm bảo rằng giá trị này nhận từ cha
        hint: Row(
          children: [
            // const SizedBox(width: 4),
            Expanded(
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      widget.selectedValue_ == "English"
                          ? 'assets/images/us.png'
                          : 'assets/images/vietnam.png', // Hiển thị ảnh tương ứng
                      height: 18,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.selectedValue_ ??
                        "Tiếng việt", // Hiển thị giá trị đã chọn
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        items: itemsLanguage
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          item == "English"
                              ? 'assets/images/us.png'
                              : 'assets/images/vietnam.png', // Hiển thị ảnh tương ứng
                          height: 18,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ))
            .toList(),
        onChanged: (value) {
          widget.onChanged_(value); // Gọi hàm onChanged khi giá trị thay đổi
          setState(() {
            widget.isDropdownOpened = false;
          });
        },
        onMenuStateChange: (isOpen) {
          widget.onMenuStateChange(isOpen);
        },
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: widget.selectedValue_ == "English" ? 110 : 120,
          padding: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
            //  borderRadius: BorderRadius.circular(10),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xff6849ef).withOpacity(0.5),
                width: 1.0,
              ),
            ),
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            widget.isDropdownOpened
                ? Icons.keyboard_arrow_up_outlined
                : Icons.keyboard_arrow_down_outlined,
          ),
          iconSize: 20,
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
          width: 120,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 10, right: 5),
        ),
      ),
    );
  }
}
