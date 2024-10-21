import 'package:flutter/material.dart';

import '../../../../resources/size_config/size_config.dart';

class ParameterLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const ParameterLabel(
    this.label,
    this.isRequired, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(fontSize: getHeight(15), color: Colors.black),
          ),
          TextSpan(
            text: isRequired ? " *" : "",
            style: TextStyle(fontSize: getHeight(15), color: Colors.red),
          ),
        ],
      ),
    );
  }
}
