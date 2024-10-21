import 'package:equatable/equatable.dart';
import 'package:modbus_app/core/state_error/custom_state_error.dart';
import 'package:modbus_app/features/history/domain/entites/modbus_request_entity.dart';

class HistoryState extends Equatable {
  final List<ModbusRequest> requests;
  final bool loading;
  final CustomStateError error;

  const HistoryState({
    this.requests = const [],
    this.loading = false,
    this.error = const CustomStateError(hasError: false),
  });

  HistoryState copyWith({
    List<ModbusRequest>? requests,
    bool? loading,
    CustomStateError? error,
  }) {
    return HistoryState(
      requests: requests ?? this.requests,
      loading: loading ?? false,
      error: error ?? const CustomStateError(hasError: false),
    );
  }

  @override
  List<Object> get props => [requests, loading, error];
}

class HistoryInitial extends HistoryState {}
