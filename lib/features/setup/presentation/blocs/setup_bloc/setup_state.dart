import 'package:equatable/equatable.dart';
import 'package:modbus_app/core/state_error/custom_state_error.dart';
import 'package:usb_serial/usb_serial.dart';

import '../../../../../core/values/connection_values.dart';

class SetupState extends Equatable {
  final UsbPort? port;
  final int? connectionMode;
  final int? baudRate;
  final int? dataBits;
  final int? parity;
  final double? stopBits;
  final int? slaveId;
  final String? alias;
  final bool isConnected;
  final bool isLoading;
  final CustomStateError error;

  const SetupState({
    required this.port,
    required this.connectionMode,
    required this.baudRate,
    required this.dataBits,
    required this.parity,
    required this.stopBits,
    required this.slaveId,
    required this.alias,
    required this.isConnected,
    required this.isLoading,
    required this.error,
  });

  factory SetupState.initial() {
    return SetupState(
      port: null,
      connectionMode: ConnectionMode.rtu.index,
      baudRate: 9600,
      dataBits: 8,
      parity: Parity.none.index,
      stopBits: StopBits.one.index.toDouble(),
      slaveId: null,
      alias: null,
      isConnected: false,
      isLoading: false,
      error: const CustomStateError(hasError: false),
    );
  }

  SetupState copyWith({
    UsbPort? port,
    int? connectionMode,
    int? baudRate,
    int? dataBits,
    int? parity,
    double? stopBits,
    int? slaveId,
    String? alias,
    bool? isConnected,
    bool? isLoading,
    CustomStateError? error,
  }) {
    return SetupState(
      port: port ?? this.port,
      connectionMode: connectionMode ?? this.connectionMode,
      baudRate: baudRate ?? this.baudRate,
      dataBits: dataBits ?? this.dataBits,
      parity: parity ?? this.parity,
      stopBits: stopBits ?? this.stopBits,
      slaveId: slaveId ?? this.slaveId,
      alias: alias ?? this.alias,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? false,
      error: error ?? const CustomStateError(hasError: false),
    );
  }

  @override
  List<Object?> get props => [
        port,
        connectionMode,
        baudRate,
        dataBits,
        parity,
        stopBits,
        slaveId,
        alias,
        isConnected,
        isLoading,
        error,
      ];
}
