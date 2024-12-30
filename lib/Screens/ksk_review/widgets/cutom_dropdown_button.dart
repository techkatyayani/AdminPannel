import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatefulWidget {
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final String hint;
  final Color backgroundColor;
  final Color textColor;
  double? width;

  CustomDropDownMenu({
    super.key,
    required this.items,
    this.width,
    this.initialValue,
    required this.onChanged,
    this.hint = "Select an option",
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width / 6,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        hint: Text(
          widget.hint,
          style: TextStyle(color: widget.textColor),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: widget.textColor,
        ),
        value: selectedValue,
        isExpanded: true,
        underline: const SizedBox(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          widget.onChanged(value);
        },
        dropdownColor: widget.backgroundColor,
        items: _buildDropdownMenuItems(widget.items),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems(List<String> items) {
    return items.map((item) {
      return DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: widget.textColor),
        ),
      );
    }).toList();
  }
}
