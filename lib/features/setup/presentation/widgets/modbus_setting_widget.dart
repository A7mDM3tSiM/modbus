import 'package:flutter/material.dart';

import '../../../../resources/size_config/size_config.dart';
import '../../../request/presentation/widgets/number_picker.dart';

class ModbusSetting extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  const ModbusSetting({
    super.key,
    required this.label,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: getHeight(17)),
        ),
        SizedBox(width: getWidth(10)),
        NumberPicker(
          controller: ctrl,
          h: getHeight(30),
          w: getWidth(40),
        ),
      ],
    );
  }
}
