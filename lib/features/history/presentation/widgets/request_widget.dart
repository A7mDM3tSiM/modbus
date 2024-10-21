import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modbus_app/features/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:modbus_app/features/request/presentation/blocs/request_bloc/request_event.dart';
import 'package:modbus_app/features/request/presentation/widgets/add_request_dialog.dart';

import '../../../../core/constants/modbus_functions.dart';
import '../../../../injector.dart';
import '../../../../resources/size_config/size_config.dart';
import '../../domain/entites/modbus_request_entity.dart';
import '../blocs/history_bloc.dart';
import '../blocs/history_event.dart';

class RequestWidget extends StatelessWidget {
  final ModbusRequest request;
  const RequestWidget({required this.request, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: getHeight(10),
        left: getWidth(20),
        right: getWidth(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: getWidth(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getHeight(10)),
          Text(
            request.tag,
            style: TextStyle(fontSize: getHeight(16)),
          ),
          SizedBox(height: getHeight(5)),
          Text(
            "Function: ${ModbusFunctions.functions[request.functionCode - 1].name}",
          ),
          SizedBox(height: getHeight(5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  // Terminate the previous request
                  sl<RequestBloc>().add(
                    const SetShouldResendRequestEvent(value: false),
                  );

                  // Send the request to the modbus device
                  if (request.functionCode == 3 || request.functionCode == 4) {
                    sl<RequestBloc>().add(ReadRequestEvent(request: request));
                  } else {
                    sl<RequestBloc>().add(WriteRequestEvent(request: request));
                  }

                  Get.back();
                },
                child: const Text("Connect"),
              ),
              Container(
                height: getHeight(15),
                width: 0.5,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {
                  // Show the dialog to update the request
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AddRequestDialog(request: request);
                    },
                  );
                },
                child: const Text("Update"),
              ),
              Container(
                height: getHeight(15),
                width: 0.5,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () async {
                  // Show a dialog to confirm the deletion
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Delete Request"),
                        titlePadding: EdgeInsets.symmetric(
                          horizontal: getWidth(20),
                          vertical: getHeight(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: getWidth(20),
                        ),
                        actionsPadding: EdgeInsets.symmetric(
                          horizontal: getWidth(20),
                        ),
                        content: const Text(
                            "Are you sure you want to delete this request?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );

                  // Delete the request if the user confirms
                  if (shouldDelete != null) {
                    if (shouldDelete) {
                      sl<HistoryBloc>()
                          .add(DeleteRequestEvent(request.id ?? -1));
                    }
                  }
                },
                child: const Text("Delete"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
