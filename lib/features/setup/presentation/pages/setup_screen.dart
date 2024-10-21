import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:modbus_app/core/values/connection_values.dart';
import 'package:modbus_app/features/setup/presentation/blocs/setup_bloc/setup_bloc.dart';
import 'package:modbus_app/features/setup/presentation/blocs/setup_bloc/setup_state.dart';

import '../../../../core/constants/modbus_functions.dart';
import '../../../../resources/size_config/size_config.dart';
import '../blocs/setup_bloc/setup_event.dart';
import '../widgets/custom_drop_down_menu.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_toggle_buttons.dart';
import '../widgets/parameter_label.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final slaveIdCtrl = TextEditingController();
  final startAddressCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();

  bool? setValue;
  ModbusFunction? selectedFunction;

  bool _checkParams(SetupState state) {
    if (state.connectionMode == null) {
      Get.snackbar(
        "Error",
        "Connection mode is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 0),
        duration: const Duration(milliseconds: 2000),
      );
      return false;
    }

    if (state.baudRate == null) {
      Get.snackbar(
        "Error",
        "Baud rate is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 0),
        duration: const Duration(milliseconds: 2000),
      );
      return false;
    }

    if (state.dataBits == null) {
      Get.snackbar(
        "Error",
        "Data bits is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 0),
        duration: const Duration(milliseconds: 2000),
      );
      return false;
    }

    if (state.parity == null) {
      Get.snackbar(
        "Error",
        "Parity is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 0),
        duration: const Duration(milliseconds: 2000),
      );
      return false;
    }

    if (state.stopBits == null) {
      Get.snackbar(
        "Error",
        "Stop bits is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 0),
        duration: const Duration(milliseconds: 2000),
      );
      return false;
    }

    if (state.slaveId == null) {
      Get.snackbar(
        "Error",
        "Slave ID is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 0),
        duration: const Duration(milliseconds: 2000),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetupBloc, SetupState>(
      listener: (context, state) {
        if (state.error.hasError) {
          Get.snackbar(
            "Error",
            state.error.message ?? "An error occurred",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(10),
            animationDuration: const Duration(milliseconds: 0),
            duration: const Duration(milliseconds: 2000),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getHeight(20)),
              child: ListView(
                padding: EdgeInsets.only(top: getHeight(40)),
                children: [
                  Text(
                    "Welcome to Modbus",
                    style: TextStyle(
                      fontSize: getHeight(25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: getHeight(5)),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Setup Connection Parameters  ",
                          style: TextStyle(
                              fontSize: getHeight(15), color: Colors.black),
                        ),
                        TextSpan(
                          text: "(",
                          style: TextStyle(
                              fontSize: getHeight(13), color: Colors.grey),
                        ),
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                              fontSize: getHeight(13), color: Colors.red),
                        ),
                        TextSpan(
                          text: " Required)",
                          style: TextStyle(
                              fontSize: getHeight(13), color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getHeight(10)),
                  const ParameterLabel("Connection mode", true),
                  SizedBox(height: getHeight(7.5)),
                  CustomToggleButtons(
                    ConnectionMode.values,
                    ConnectionMode.values
                        .where((e) => e.index == state.connectionMode)
                        .firstOrNull
                        ?.index,
                    onChanged: (index) {
                      context.read<SetupBloc>().add(
                            ChangeConnectionMode(
                              ConnectionMode.values[index],
                            ),
                          );
                    },
                  ),
                  SizedBox(height: getHeight(20)),
                  const ParameterLabel("Baud rate", true),
                  SizedBox(height: getHeight(7.5)),
                  CustomDropDownMenu<int>(
                    dropdownMenuEntries: baudRateValues,
                    initialSelection: state.baudRate,
                    onSelected: (baudRate) {
                      if (baudRate == null) {
                        return;
                      }

                      context.read<SetupBloc>().add(
                            ChangeBaudRate(baudRate),
                          );
                    },
                  ),
                  SizedBox(height: getHeight(20)),
                  const ParameterLabel("Data bits", true),
                  SizedBox(height: getHeight(7.5)),
                  CustomDropDownMenu<int>(
                    dropdownMenuEntries: dataBitsValues,
                    initialSelection: state.dataBits,
                    onSelected: (dataBits) {
                      if (dataBits == null) {
                        return;
                      }

                      context.read<SetupBloc>().add(
                            ChangeDataBits(dataBits),
                          );
                    },
                  ),
                  SizedBox(height: getHeight(20)),
                  const ParameterLabel(
                    "Parity",
                    true,
                  ),
                  SizedBox(height: getHeight(7.5)),
                  CustomToggleButtons(
                    Parity.values,
                    Parity.values
                        .where((e) => e.index == state.parity)
                        .firstOrNull
                        ?.index,
                    onChanged: (index) {
                      context.read<SetupBloc>().add(
                            ChangeParity(
                              Parity.values[index],
                            ),
                          );
                    },
                  ),
                  SizedBox(height: getHeight(20)),
                  const ParameterLabel("Stop bits", true),
                  SizedBox(height: getHeight(7.5)),
                  CustomToggleButtons(
                    StopBits.values,
                    StopBits.values
                        .where((e) => e.index == state.stopBits)
                        .firstOrNull
                        ?.index,
                    onChanged: (index) {
                      context.read<SetupBloc>().add(
                            ChangeStopBits(
                              StopBits.values[index],
                            ),
                          );
                    },
                  ),
                  SizedBox(height: getHeight(20)),
                  const ParameterLabel("Slave id", true),
                  SizedBox(height: getHeight(7.5)),
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    hint: "Enter slave ID",
                    onChanged: (value) {
                      context.read<SetupBloc>().add(
                            ChangeSlaveId(int.tryParse(value) ?? -1),
                          );
                    },
                  ),
                  SizedBox(height: getHeight(20)),
                  const ParameterLabel("Alias", false),
                  SizedBox(height: getHeight(7.5)),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    hint: "Enter alias",
                    onChanged: (value) {
                      context.read<SetupBloc>().add(
                            ChangeAlias(value),
                          );
                    },
                  ),
                  // const ParameterLabel("Request time out (ms)", false),
                  // SizedBox(height: getHeight(7.5)),
                  // CustomToggleButtons(
                  //   RequestTimeOut.values,
                  // RequestTimeOut.values
                  //     .where(
                  //       (e) => e.index == state.requestTimeout,
                  //     )
                  //     .firstOrNull
                  //     ?.index,
                  //   onChanged: (index) {
                  //     context.read<SetupBloc>().add(
                  //           ChangeRequestTimeout(
                  //             RequestTimeOut.values[index],
                  //           ),
                  //         );
                  //   },
                  // ),
                  SizedBox(height: getHeight(20)),
                  Text(
                    "* Make sure to connect to the device before proceeding",
                    style: TextStyle(
                      fontSize: getHeight(13),
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: getHeight(5)),
                  state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColor,
                            ),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                            textStyle: WidgetStatePropertyAll(
                              TextStyle(fontSize: getHeight(16)),
                            ),
                            fixedSize: WidgetStateProperty.all(
                              Size(getWidth(360), getHeight(50)),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (!_checkParams(state)) {
                              return;
                            }
                            context.read<SetupBloc>().add(Setup());
                          },
                          child: const Text('Ready to connect'),
                        ),
                  SizedBox(height: getHeight(20)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
