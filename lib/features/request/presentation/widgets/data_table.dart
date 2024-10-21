import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modbus_app/resources/size_config/size_config.dart';

import '../../../../core/values/connection_values.dart';
import '../blocs/request_bloc/request_bloc.dart';
import '../blocs/request_bloc/request_state.dart';

class TableChart<T> extends StatelessWidget {
  final List<T> values;
  const TableChart({super.key, required this.values});

  String _getValue(dynamic value, DataType type, double gain) {
    switch (type) {
      case DataType.number:
        return (value * gain).toStringAsFixed(2);
      case DataType.string:
        return value.toString();
      case DataType.boolean:
        return value == 0 ? "true" : "false";
    }
  }

  DataType _getDataType(int index) {
    return DataType.values
            .where((element) => element.index == index)
            .firstOrNull ??
        DataType.number;
  }

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return SizedBox(
        height: getHeight(40),
        child: Center(
          child: Text(
            'No data',
            style: TextStyle(
              fontSize: getHeight(15),
              color: Colors.grey[800],
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: getHeight(520),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: values.length + 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              height: getHeight(40),
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Index',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getHeight(15),
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Value',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getHeight(15),
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Unit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getHeight(15),
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return BlocBuilder<RequestBloc, RequestState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: index % 2 == 0
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.white,
                ),
                height: getHeight(40),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$index', // Display index
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: getHeight(15),
                            color: index % 2 == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _getValue(
                            values[index - 1],
                            _getDataType(state.request?.dataType ?? 0),
                            state.request?.gain ?? 1.0,
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: getHeight(15),
                            color: index % 2 == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "-",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: getHeight(15),
                            color: index % 2 == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
