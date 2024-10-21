import 'package:equatable/equatable.dart';
import 'package:modbus_app/core/state_error/custom_state_error.dart';
import 'package:modbus_app/features/request/presentation/blocs/request_bloc/request_event.dart';
import 'package:usb_serial/usb_serial.dart';

import '../../../../../core/values/connection_values.dart';
import '../../../../history/domain/entites/modbus_request_entity.dart';

class RequestState extends Equatable {
  // request parameters
  final UsbPort? port;
  final int? slaveId;
  final int? baudRate;
  final String? tag;
  final int? functionCode;
  final int? startAddress;
  final int? quantity;
  final DataType? dataType;
  final double? gain;
  final List<int>? values;

  // request under processing
  final ModbusRequest? request;

  // flags
  final bool isDataTypeRequired;
  final bool isGainRequired;
  final bool isValuesRequired;
  final bool shouldSaveRequest;
  final bool shouldResendRequest;
  final SaveRequestType saveRequestType;

  // presentation
  final PresentationType presentationType;

  // request and response
  final List<ModbusRequest> requests;
  final List<int> response;

  // loading and error
  final bool isLoading;
  final CustomStateError error;

  const RequestState({
    required this.tag,
    required this.port,
    required this.slaveId,
    required this.baudRate,
    required this.functionCode,
    required this.startAddress,
    required this.quantity,
    required this.dataType,
    required this.gain,
    required this.values,
    required this.request,
    required this.isDataTypeRequired,
    required this.isGainRequired,
    required this.isValuesRequired,
    required this.shouldSaveRequest,
    required this.shouldResendRequest,
    required this.saveRequestType,
    required this.presentationType,
    required this.requests,
    required this.response,
    required this.isLoading,
    required this.error,
  });

  factory RequestState.initial() {
    return const RequestState(
      port: null,
      slaveId: null,
      baudRate: null,
      tag: "",
      functionCode: null,
      startAddress: null,
      quantity: null,
      dataType: null,
      gain: null,
      values: null,
      request: null,
      isDataTypeRequired: false,
      isGainRequired: false,
      isValuesRequired: false,
      shouldSaveRequest: false,
      shouldResendRequest: false,
      saveRequestType: SaveRequestType.doNothing,
      presentationType: PresentationType.table,
      requests: [],
      response: [],
      isLoading: false,
      error: CustomStateError(hasError: false),
    );
  }

  RequestState copyWith({
    UsbPort? port,
    int? slaveId,
    int? baudRate,
    String? tag,
    int? functionCode,
    int? startAddress,
    int? quantity,
    DataType? dataType,
    double? gain,
    List<int>? values,
    ModbusRequest? request,
    bool? isDataTypeRequired,
    bool? isGainRequired,
    bool? isValuesRequired,
    bool? shouldSaveRequest,
    bool? shouldResendRequest,
    SaveRequestType? saveRequestType,
    PresentationType? presentationType,
    List<int>? response,
    List<ModbusRequest>? requests,
    bool? isLoading,
    CustomStateError? error,
  }) {
    return RequestState(
      port: port ?? this.port,
      slaveId: slaveId ?? this.slaveId,
      baudRate: baudRate ?? this.baudRate,
      tag: tag ?? this.tag,
      functionCode: functionCode ?? this.functionCode,
      startAddress: startAddress ?? this.startAddress,
      quantity: quantity ?? this.quantity,
      dataType: dataType ?? this.dataType,
      gain: gain ?? this.gain,
      values: values ?? this.values,
      request: request ?? this.request,
      isDataTypeRequired: isDataTypeRequired ?? this.isDataTypeRequired,
      isGainRequired: isGainRequired ?? this.isGainRequired,
      isValuesRequired: isValuesRequired ?? this.isValuesRequired,
      shouldSaveRequest: shouldSaveRequest ?? this.shouldSaveRequest,
      shouldResendRequest: shouldResendRequest ?? this.shouldResendRequest,
      saveRequestType: saveRequestType ?? this.saveRequestType,
      presentationType: presentationType ?? this.presentationType,
      response: response ?? this.response,
      requests: requests ?? this.requests,
      isLoading: isLoading ?? false,
      error: error ?? const CustomStateError(hasError: false),
    );
  }

  @override
  List<Object?> get props => [
        tag,
        port,
        slaveId,
        baudRate,
        functionCode,
        startAddress,
        quantity,
        dataType,
        gain,
        values,
        request,
        isDataTypeRequired,
        isGainRequired,
        isValuesRequired,
        shouldSaveRequest,
        shouldResendRequest,
        saveRequestType,
        presentationType,
        response,
        requests,
        isLoading,
        error,
      ];
}
