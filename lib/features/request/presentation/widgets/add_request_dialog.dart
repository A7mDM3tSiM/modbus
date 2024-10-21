import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:modbus_app/features/history/domain/entites/modbus_request_entity.dart';

import '../../../../core/constants/modbus_functions.dart';
import '../../../../core/values/connection_values.dart';
import '../../../../resources/size_config/size_config.dart';
import '../blocs/request_bloc/request_bloc.dart';
import '../blocs/request_bloc/request_event.dart';
import '../blocs/request_bloc/request_state.dart';
import '../../../setup/presentation/widgets/custom_drop_down_menu.dart';
import '../../../setup/presentation/widgets/custom_text_field.dart';
import '../../../setup/presentation/widgets/custom_toggle_buttons.dart';

class AddRequestDialog extends StatefulWidget {
  final ModbusRequest? request;
  const AddRequestDialog({super.key, this.request});

  @override
  State<AddRequestDialog> createState() => _AddRequestDialogState();
}

class _AddRequestDialogState extends State<AddRequestDialog> {
  final startAddressCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final gainCtrl = TextEditingController();
  final valuesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if request is not null then we are updating the request
      // so we need to set the values of the request
      if (widget.request != null) {
        // set the values of the request
        // set tag
        context.read<RequestBloc>().add(
              SetRequestTag(
                tag: widget.request!.tag,
              ),
            );

        // set function code
        context.read<RequestBloc>().add(
              SetFunctionCode(
                functionCode: widget.request!.functionCode,
              ),
            );

        // set start address
        startAddressCtrl.text = widget.request!.startAddress.toString();
        context.read<RequestBloc>().add(
              SetStartAddress(
                startAddress: widget.request!.startAddress,
              ),
            );

        // set quantity
        quantityCtrl.text = widget.request!.quantity.toString();
        context.read<RequestBloc>().add(
              SetQuantity(
                quantity: widget.request!.quantity,
              ),
            );

        // set data type
        context.read<RequestBloc>().add(
              SetDataType(
                dataType: DataType.values.where(
                      (type) {
                        return type.index == widget.request!.dataType;
                      },
                    ).firstOrNull ??
                    DataType.number,
              ),
            );

        // set gain
        gainCtrl.text = widget.request!.gain.toString();
        context.read<RequestBloc>().add(
              SetGain(gain: widget.request!.gain),
            );

        // set values
        valuesCtrl.text = widget.request!.values.join(',');
        context.read<RequestBloc>().add(
              SetValues(values: widget.request!.values),
            );

        // set save request type
        context.read<RequestBloc>().add(
              const SetSaveRequestTypeEvent(
                type: SaveRequestType.doNothing,
              ),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => Get.back(),
          child: Scaffold(
            backgroundColor: Colors.grey.shade100.withOpacity(0.1),
            body: Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(getHeight(10)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth(20),
                    vertical: getHeight(20),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: getWidth(20),
                    vertical: getHeight(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.request != null
                              ? widget.request!.tag
                              : 'Add Request',
                          style: TextStyle(
                            fontSize: getHeight(16),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: getHeight(20)),
                        Visibility(
                          visible: widget.request == null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Tag"),
                              SizedBox(height: getHeight(5)),
                              CustomTextField(
                                hint: "Enter request tag",
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  context
                                      .read<RequestBloc>()
                                      .add(SetRequestTag(tag: value));
                                },
                              ),
                              SizedBox(height: getHeight(15)),
                            ],
                          ),
                        ),
                        CustomDropDownMenu<int>(
                          dropdownMenuEntries: List.generate(
                            ModbusFunctions.functions.length,
                            (i) {
                              return DropdownMenuEntry(
                                value: ModbusFunctions.functions[i].code,
                                label: ModbusFunctions.functions[i].name,
                              );
                            },
                          ),
                          onSelected: (value) {
                            if (value == null) {
                              return;
                            }

                            context
                                .read<RequestBloc>()
                                .add(SetFunctionCode(functionCode: value));
                          },
                          initialSelection: widget.request?.functionCode,
                        ),
                        SizedBox(height: getHeight(15)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: getWidth(150),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Start address"),
                                  SizedBox(height: getHeight(5)),
                                  CustomTextField(
                                    hint: "Enter start address",
                                    controller: startAddressCtrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      context.read<RequestBloc>().add(
                                            SetStartAddress(
                                              startAddress:
                                                  int.tryParse(value) ?? 0,
                                            ),
                                          );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: getWidth(120),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Quantity"),
                                  SizedBox(height: getHeight(5)),
                                  CustomTextField(
                                    hint: "Enter quantity",
                                    keyboardType: TextInputType.number,
                                    controller: quantityCtrl,
                                    onChanged: (value) {
                                      context.read<RequestBloc>().add(
                                            SetQuantity(
                                              quantity:
                                                  int.tryParse(value) ?? 1,
                                            ),
                                          );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: getHeight(15)),
                        Visibility(
                          visible: state.isDataTypeRequired,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Data type"),
                              SizedBox(height: getHeight(5)),
                              CustomToggleButtons<DataType>(
                                List.generate(
                                  DataType.values.length,
                                  (i) => DataType.values[i],
                                ),
                                state.dataType?.index ?? -1,
                                onChanged: (index) {
                                  if (index == -1) {
                                    return;
                                  }

                                  context.read<RequestBloc>().add(
                                        SetDataType(
                                          dataType: DataType.values[index],
                                        ),
                                      );
                                },
                              ),
                              SizedBox(height: getHeight(15)),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: state.isGainRequired,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: getWidth(120),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Gain"),
                                        SizedBox(height: getHeight(5)),
                                        CustomTextField(
                                          hint: "Gain",
                                          keyboardType: TextInputType.number,
                                          controller: gainCtrl,
                                          onChanged: (value) {
                                            context.read<RequestBloc>().add(
                                                  SetGain(
                                                    gain: double.tryParse(
                                                            value) ??
                                                        1,
                                                  ),
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: getWidth(10)),
                                  Expanded(
                                    child: Text(
                                      "Gain is the value that will be multiplied to the read value",
                                      style: TextStyle(
                                        fontSize: getHeight(12),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: getHeight(15)),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: state.isValuesRequired,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Values"),
                              SizedBox(height: getHeight(5)),
                              CustomTextField(
                                hint: "Enter values seperated by comma (,)",
                                keyboardType: TextInputType.number,
                                controller: valuesCtrl,
                                onChanged: (value) {
                                  context.read<RequestBloc>().add(
                                        SetValues(
                                          values: value
                                              .split(',')
                                              .map((e) => int.tryParse(e) ?? 0)
                                              .toList(),
                                        ),
                                      );
                                },
                              ),
                              SizedBox(height: getHeight(20)),
                            ],
                          ),
                        ),
                        // check box to save request
                        Visibility(
                          visible: widget.request == null,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text("Save request"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: state.shouldSaveRequest,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              context.read<RequestBloc>().add(
                                    SetShouldSaveRequest(value: value),
                                  );
                            },
                          ),
                        ),
                        // radio buttons for update the request or save new request or do nothing
                        Visibility(
                          visible: widget.request != null &&
                              !state.shouldSaveRequest,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Save request as"),
                              SizedBox(height: getHeight(5)),
                              CustomToggleButtons<SaveRequestType>(
                                SaveRequestType.values,
                                state.saveRequestType.index,
                                onChanged: (index) {
                                  context.read<RequestBloc>().add(
                                        SetSaveRequestTypeEvent(
                                          type: SaveRequestType.values[index],
                                        ),
                                      );
                                },
                              ),
                              SizedBox(height: getHeight(20)),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // check fields first
                              if (state.slaveId == null ||
                                  state.baudRate == null ||
                                  state.tag == null ||
                                  state.functionCode == null ||
                                  state.startAddress == null ||
                                  state.quantity == null ||
                                  (state.isDataTypeRequired &&
                                      state.dataType == null) ||
                                  (state.isGainRequired &&
                                      state.gain == null) ||
                                  (state.isValuesRequired &&
                                      state.values == null)) {
                                Get.snackbar(
                                  "Error",
                                  "Please fill all fields",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red.shade400,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  animationDuration:
                                      const Duration(milliseconds: 0),
                                  duration: const Duration(milliseconds: 2000),
                                );
                                return;
                              }

                              // terminate the previous request
                              context.read<RequestBloc>().add(
                                    const SetShouldResendRequestEvent(
                                      value: false,
                                    ),
                                  );

                              // create request
                              final request = ModbusRequest(
                                id: null,
                                tag: state.tag ?? "",
                                type: state.functionCode! <= 4 ||
                                        state.functionCode == 23
                                    ? ModbusRequestType.read
                                    : ModbusRequestType.write,
                                slaveId: state.slaveId!,
                                functionCode: state.functionCode!,
                                startAddress: state.startAddress ?? 0,
                                quantity: state.quantity ?? 1,
                                dataType: state.dataType?.index ?? 0,
                                gain: state.gain ?? 1,
                                values: state.values ?? [],
                              );

                              // send request read or write
                              if (request.type == ModbusRequestType.read) {
                                context.read<RequestBloc>().add(
                                      ReadRequestEvent(
                                        id: widget.request?.id,
                                        request: request,
                                      ),
                                    );
                              } else {
                                context.read<RequestBloc>().add(
                                      WriteRequestEvent(
                                        id: widget.request?.id,
                                        request: request,
                                      ),
                                    );
                              }

                              // close the dialog
                              Get.back();

                              // request != null means the request is being updated
                              // so we need to navigate back from the history page
                              if (widget.request != null) {
                                Get.back();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.primary,
                              ),
                              fixedSize: WidgetStatePropertyAll(
                                Size(getWidth(100), getHeight(40)),
                              ),
                            ),
                            child: Text(
                              'Connect',
                              style: TextStyle(
                                fontSize: getHeight(14),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
