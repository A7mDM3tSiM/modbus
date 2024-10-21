import 'package:equatable/equatable.dart';

enum ModbusRequestType {
  read("read"),
  write("write");

  final String value;

  const ModbusRequestType(this.value);
}

class ModbusRequest extends Equatable {
  final int? id;
  final String tag;
  final ModbusRequestType type;
  final int slaveId;
  final int functionCode;
  final int startAddress;
  final int quantity;
  final int dataType;
  final double gain;
  final List<int> values;

  const ModbusRequest({
    required this.id,
    required this.tag,
    required this.type,
    required this.slaveId,
    required this.functionCode,
    required this.startAddress,
    required this.quantity,
    required this.dataType,
    required this.gain,
    required this.values,
  });

  @override
  List<Object?> get props => [
        id,
        tag,
        type,
        slaveId,
        functionCode,
        startAddress,
        quantity,
        dataType,
        gain,
        values,
      ];
}
