import 'package:flutter/material.dart';

class CustomDropDownMenu<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final T? initialSelection;
  final Function(T?) onSelected;

  const CustomDropDownMenu({
    super.key,
    required this.dropdownMenuEntries,
    this.initialSelection,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: DropdownMenu<T>(
        width: double.infinity,
        hintText: "Select a choice",
        onSelected: onSelected,
        dropdownMenuEntries: dropdownMenuEntries,
        initialSelection: initialSelection,
        inputDecorationTheme:
            const InputDecorationTheme(border: InputBorder.none),
      ),
    );
  }
}
