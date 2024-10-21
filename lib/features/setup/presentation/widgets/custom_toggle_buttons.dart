import 'package:flutter/material.dart';

import '../../../../core/values/connection_values.dart';
import '../../../../resources/size_config/size_config.dart';

class CustomToggleButtons<T extends ToggleButtonsUser> extends StatelessWidget {
  final List<T> values;
  final int? selectedIndex;
  final double? height;
  final double? width;

  final Function(int)? onChanged;

  const CustomToggleButtons(
    this.values,
    this.selectedIndex, {
    super.key,
    this.onChanged,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: List.generate(
        values.length,
        (i) {
          return i == selectedIndex;
        },
      ),
      constraints: BoxConstraints(
        minHeight: height ?? getHeight(35),
        minWidth: width ?? getWidth(50),
      ),
      borderRadius: BorderRadius.circular(10),
      borderColor: Theme.of(context).colorScheme.primary,
      selectedBorderColor: Theme.of(context).colorScheme.primary,
      fillColor: Theme.of(context).colorScheme.primary,
      selectedColor: Colors.white,
      onPressed: onChanged,
      children: List.generate(
        values.length,
        (i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth(15)),
            child: Text(
              values[i].name,
              style: TextStyle(fontSize: getHeight(12)),
            ),
          );
        },
      ),
    );
  }
}
