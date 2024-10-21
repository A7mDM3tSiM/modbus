import 'package:flutter/material.dart';
import 'package:modbus_app/resources/size_config/size_config.dart';

class NumberPicker extends StatelessWidget {
  final TextEditingController controller;
  final double h;
  final double w;

  const NumberPicker({
    super.key,
    required this.controller,
    required this.h,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h,
      width: w,
      child: TextField(
        controller: controller,
        cursorHeight: getHeight(20),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: getHeight(17)),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: getWidth(10)),
          border: const OutlineInputBorder(),
          hintText: "0",
          hintStyle: TextStyle(fontSize: getHeight(17), color: Colors.grey),
        ),
      ),
    );
  }
}
