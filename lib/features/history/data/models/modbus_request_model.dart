import '../../domain/entites/modbus_request_entity.dart';

class ModbusRequestModel extends ModbusRequest {
  const ModbusRequestModel({
    required super.id,
    required super.tag,
    required super.type,
    required super.slaveId,
    required super.functionCode,
    required super.startAddress,
    required super.quantity,
    required super.dataType,
    required super.gain,
    required super.values,
  });

  factory ModbusRequestModel.fromMap(Map<String, dynamic> json) {
    return ModbusRequestModel(
      id: json['id'],
      tag: json['tag'],
      type: ModbusRequestType.values
              .where((r) => (json['type'] == r.index))
              .firstOrNull ??
          ModbusRequestType.read,
      slaveId: json['slaveId'] ?? 1,
      functionCode: json['functionCode'],
      startAddress: json['startAddress'],
      quantity: json['quantity'],
      dataType: json['dataType'],
      gain: json['gain'],
      values: json['valuesList'].isEmpty
          ? []
          : json['valuesList'].split(',').map((e) => int.parse(e)).toList(),
    );
  }

  factory ModbusRequestModel.fromEntity(ModbusRequest entity) {
    return ModbusRequestModel(
      id: entity.id,
      tag: entity.tag,
      type: entity.type,
      slaveId: entity.slaveId,
      functionCode: entity.functionCode,
      startAddress: entity.startAddress,
      quantity: entity.quantity,
      dataType: entity.dataType,
      gain: entity.gain,
      values: entity.values,
    );
  }

  ModbusRequest toEntity() {
    return ModbusRequest(
      id: id,
      tag: tag,
      type: type,
      slaveId: slaveId,
      functionCode: functionCode,
      startAddress: startAddress,
      quantity: quantity,
      dataType: dataType,
      gain: gain,
      values: values,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...id != null ? {'id': id} : {},
      'tag': tag,
      'type': type.index,
      'slaveId': slaveId,
      'functionCode': functionCode,
      'startAddress': startAddress,
      'quantity': quantity,
      'dataType': dataType,
      'gain': gain,
      'valuesList': values.isNotEmpty ? values.join(',') : [],
    };
  }
}
