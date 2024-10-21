import 'package:equatable/equatable.dart';
import 'package:modbus_app/features/history/domain/entites/modbus_request_entity.dart';

import '../../../../../core/values/connection_values.dart';

enum SaveRequestType implements ToggleButtonsUser {
  saveNew("Save new"),
  update("Update"),
  doNothing("Do nothing");

  const SaveRequestType(this.name);

  @override
  final String name;
}

enum PresentationType implements ToggleButtonsUser {
  table("Table"),
  graph("Graph");

  const PresentationType(this.name);

  @override
  final String name;
}

abstract class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}

class SetStaticParamsEvent extends RequestEvent {
  const SetStaticParamsEvent();

  @override
  List<Object> get props => [];
}

class ReadRequestEvent extends RequestEvent {
  final int? id;
  final ModbusRequest request;

  const ReadRequestEvent({this.id, required this.request});

  @override
  List<Object> get props => [id ?? -1, request];
}

class WriteRequestEvent extends RequestEvent {
  final int? id;
  final ModbusRequest request;

  const WriteRequestEvent({this.id, required this.request});

  @override
  List<Object> get props => [id ?? -1, request];
}

class SetRequestTag extends RequestEvent {
  final String tag;

  const SetRequestTag({required this.tag});

  @override
  List<Object> get props => [tag];
}

class SetFunctionCode extends RequestEvent {
  final int functionCode;

  const SetFunctionCode({required this.functionCode});

  @override
  List<Object> get props => [functionCode];
}

class SetStartAddress extends RequestEvent {
  final int startAddress;

  const SetStartAddress({required this.startAddress});

  @override
  List<Object> get props => [startAddress];
}

class SetQuantity extends RequestEvent {
  final int quantity;

  const SetQuantity({required this.quantity});

  @override
  List<Object> get props => [quantity];
}

class SetDataType extends RequestEvent {
  final DataType dataType;

  const SetDataType({required this.dataType});

  @override
  List<Object> get props => [dataType];
}

class SetGain extends RequestEvent {
  final double gain;

  const SetGain({required this.gain});

  @override
  List<Object> get props => [gain];
}

class SetValues extends RequestEvent {
  final List<int> values;

  const SetValues({required this.values});

  @override
  List<Object> get props => [values];
}

class SetShouldSaveRequest extends RequestEvent {
  final bool value;

  const SetShouldSaveRequest({required this.value});

  @override
  List<Object> get props => [value];
}

class SetShouldResendRequestEvent extends RequestEvent {
  final bool value;

  const SetShouldResendRequestEvent({required this.value});

  @override
  List<Object> get props => [value];
}

class SetSaveRequestTypeEvent extends RequestEvent {
  final SaveRequestType type;

  const SetSaveRequestTypeEvent({required this.type});

  @override
  List<Object> get props => [type];
}

class SetRequestEvent extends RequestEvent {
  final ModbusRequest request;

  const SetRequestEvent({required this.request});

  @override
  List<Object> get props => [request];
}

class SetPresentationTypeEvent extends RequestEvent {
  final PresentationType type;

  const SetPresentationTypeEvent({required this.type});

  @override
  List<Object> get props => [type];
}

class TerminateSessionEvent extends RequestEvent {
  const TerminateSessionEvent();

  @override
  List<Object> get props => [];
}
