import 'package:modbus_app/core/usecase/usecase.dart';
import 'package:modbus_app/features/history/domain/entites/modbus_request_entity.dart';
import 'package:modbus_app/resources/datastate/datastate.dart';

import '../repositories/history_repository.dart';

class FetchRequestsUsecase
    extends Usecase<DataState<List<ModbusRequest>>, void> {
  final HistoryRepository repository;
  const FetchRequestsUsecase(this.repository);

  @override
  Future<DataState<List<ModbusRequest>>> call({void params}) async {
    final dataState = await repository.fetchRequests();
    return SuccessState(dataState.data?.reversed.toList() ?? [], null);
  }
}
