import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modbus_app/core/state_error/custom_state_error.dart';
import 'package:modbus_app/features/history/domain/entites/modbus_request_entity.dart';
import 'package:modbus_app/features/history/domain/usecases/delete_request_usecase.dart';
import 'package:modbus_app/features/history/domain/usecases/fetch_requests_usecase.dart';
import 'package:modbus_app/features/history/domain/usecases/save_request_usecase.dart';
import 'package:modbus_app/injector.dart';
import 'package:modbus_app/resources/datastate/datastate.dart';

import '../../../request/presentation/blocs/request_bloc/request_bloc.dart';
import '../../domain/usecases/update_request_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final SaveRequestUsecase saveRequestUsecase;
  final UpdateRequestUsecase updateRequestUsecase;
  final DeleteRequestUsecase deleteRequestUsecase;
  final FetchRequestsUsecase fetchRequestsUsecase;

  List<ModbusRequest> _deleteRequest(int id) {
    return state.requests.where((element) => element.id != id).toList();
  }

  HistoryBloc(
    this.saveRequestUsecase,
    this.updateRequestUsecase,
    this.deleteRequestUsecase,
    this.fetchRequestsUsecase,
  ) : super(HistoryInitial()) {
    on<SaveRequestEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      final request = sl<RequestBloc>().state.request;
      final dataState = await saveRequestUsecase(params: request);

      if (dataState is SuccessState) {
        emit(state.copyWith());
      } else if (dataState is FailedState) {
        emit(state.copyWith(
          error: CustomStateError(
            hasError: true,
            message: dataState.error?.message ?? "Failed to save requests",
          ),
        ));
      }
    });

    on<UpdateRequestEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      final dataState = await updateRequestUsecase(params: event.request);

      if (dataState is SuccessState) {
        emit(state.copyWith());
      } else if (dataState is FailedState) {
        emit(
          state.copyWith(
            error: CustomStateError(
              hasError: true,
              message: dataState.error?.message ?? "Failed to save requests",
            ),
          ),
        );
      }
    });

    on<DeleteRequestEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      final dataState = await deleteRequestUsecase(params: event.id);

      if (dataState is SuccessState) {
        final requests = _deleteRequest(dataState.data!);
        emit(state.copyWith(requests: requests));
      } else if (dataState is FailedState) {
        emit(state.copyWith(
          error: CustomStateError(
            hasError: true,
            message: dataState.error?.message ?? "Failed to delete requests",
          ),
        ));
      }
    });

    on<FetchRequestsEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      final dataState = await fetchRequestsUsecase();

      if (dataState is SuccessState) {
        emit(state.copyWith(requests: dataState.data));
      } else if (dataState is FailedState) {
        emit(state.copyWith(
          error: CustomStateError(
            hasError: true,
            message: dataState.error?.message ?? "Failed to fetch requests",
          ),
        ));
      }
    });
  }
}
