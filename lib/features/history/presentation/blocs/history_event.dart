import 'package:equatable/equatable.dart';
import 'package:modbus_app/features/history/domain/entites/modbus_request_entity.dart';

class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class SaveRequestEvent extends HistoryEvent {}

class UpdateRequestEvent extends HistoryEvent {
  final ModbusRequest request;

  const UpdateRequestEvent(this.request);

  @override
  List<Object> get props => [request];
}

class DeleteRequestEvent extends HistoryEvent {
  final int id;

  const DeleteRequestEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FetchRequestsEvent extends HistoryEvent {}
