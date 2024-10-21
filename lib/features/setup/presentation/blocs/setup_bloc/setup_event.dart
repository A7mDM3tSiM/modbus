import 'package:equatable/equatable.dart';
import 'package:modbus_app/core/values/connection_values.dart';

class SetupEvent extends Equatable {
  const SetupEvent();

  @override
  List<Object> get props => [];
}

class ChangeConnectionMode extends SetupEvent {
  final ConnectionMode connectionMode;

  const ChangeConnectionMode(this.connectionMode);

  @override
  List<Object> get props => [connectionMode];
}

class ChangeBaudRate extends SetupEvent {
  final int baudRate;

  const ChangeBaudRate(this.baudRate);

  @override
  List<Object> get props => [baudRate];
}

class ChangeDataBits extends SetupEvent {
  final int dataBits;

  const ChangeDataBits(this.dataBits);

  @override
  List<Object> get props => [dataBits];
}

class ChangeParity extends SetupEvent {
  final Parity parity;

  const ChangeParity(this.parity);

  @override
  List<Object> get props => [parity];
}

class ChangeStopBits extends SetupEvent {
  final StopBits stopBits;

  const ChangeStopBits(this.stopBits);

  @override
  List<Object> get props => [stopBits];
}

class ChangeRequestTimeout extends SetupEvent {
  final RequestTimeOut requestTimeout;

  const ChangeRequestTimeout(this.requestTimeout);

  @override
  List<Object> get props => [requestTimeout];
}

class ChangeSlaveId extends SetupEvent {
  final int slaveId;

  const ChangeSlaveId(this.slaveId);

  @override
  List<Object> get props => [slaveId];
}

class ChangeAlias extends SetupEvent {
  final String alias;

  const ChangeAlias(this.alias);

  @override
  List<Object> get props => [alias];
}

class Setup extends SetupEvent {}
