import 'package:flutter/material.dart';
import 'package:modbus_app/resources/size_config/size_config.dart';

class ToggleButtonsUser {
  final String name;
  ToggleButtonsUser(this.name);

  @override
  String toString() {
    return name;
  }
}

enum ConnectionMode implements ToggleButtonsUser {
  tcp("TCP"),
  rtu("RTU");

  const ConnectionMode(this.name);

  @override
  final String name;
}

enum Parity implements ToggleButtonsUser {
  none("None"),
  odd("Odd"),
  even("Even"),
  mark("Mark"),
  space("Space");

  const Parity(this.name);

  @override
  final String name;
}

enum StopBits implements ToggleButtonsUser {
  one("1"),
  onePointFive("1.5"),
  two("2");

  const StopBits(this.name);

  @override
  final String name;
}

enum RequestTimeOut implements ToggleButtonsUser {
  short("4000"),
  medium("7000"),
  long("10000");

  const RequestTimeOut(this.name);

  @override
  final String name;
}

enum DataType implements ToggleButtonsUser {
  number("Number"),
  string("String"),
  boolean("Boolean");

  const DataType(this.name);

  @override
  final String name;
}

final kButtonStyle = ButtonStyle(
  textStyle: WidgetStateProperty.all(
    TextStyle(
      fontSize: getHeight(15),
    ),
  ),
);

final baudRateValues = [
  DropdownMenuEntry(value: 9600, label: "9600", style: kButtonStyle),
  DropdownMenuEntry(value: 19200, label: "19200", style: kButtonStyle),
  DropdownMenuEntry(value: 38400, label: "38400", style: kButtonStyle),
  DropdownMenuEntry(value: 57600, label: "57600", style: kButtonStyle),
  DropdownMenuEntry(value: 115200, label: "115200", style: kButtonStyle),
];

final dataBitsValues = [
  DropdownMenuEntry(value: 5, label: "5", style: kButtonStyle),
  DropdownMenuEntry(value: 6, label: "6", style: kButtonStyle),
  DropdownMenuEntry(value: 7, label: "7", style: kButtonStyle),
  DropdownMenuEntry(value: 8, label: "8", style: kButtonStyle),
];
