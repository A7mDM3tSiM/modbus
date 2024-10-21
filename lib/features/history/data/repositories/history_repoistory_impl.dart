import 'package:modbus_app/features/history/data/models/modbus_request_model.dart';
import 'package:modbus_app/features/history/domain/entites/modbus_request_entity.dart';
import 'package:modbus_app/features/history/domain/repositories/history_repository.dart';
import 'package:modbus_app/resources/datastate/datastate.dart';

import '../datasources/history_local_datasource.dart';

class HistoryRepoistoryImpl implements HistoryRepository {
  final HistoryLocalDatasource localDatasource;
  const HistoryRepoistoryImpl(this.localDatasource);

  List<ModbusRequest> _castResponse(Map<String, dynamic> data) {
    final List<ModbusRequest> requests = [];

    // Iterate through the response and cast each request to the required type
    for (final request in data['requests']) {
      requests.add(ModbusRequestModel.fromMap(request));
    }

    return requests;
  }

  @override
  Future<DataState<int>> saveRequest(Map<String, dynamic> request) async {
    final response = await localDatasource.saveRequest(request);

    if (response == null) {
      return FailedState(
        const CustomError('Failed to save request'),
      );
    }

    return SuccessState(response, null);
  }

  @override
  Future<DataState<int>> updateRequest(Map<String, dynamic> request) async {
    final response = await localDatasource.updateRequest(request);

    if (response == null) {
      return FailedState(
        const CustomError('Failed to save request'),
      );
    }

    return SuccessState(response, null);
  }

  @override
  Future<DataState<int>> deleteRequest(int id) async {
    final response = await localDatasource.deleteRequest(id);

    if (response == null) {
      return FailedState(
        const CustomError('Failed to delete request'),
      );
    }

    return SuccessState(response, null);
  }

  @override
  Future<DataState<List<ModbusRequest>>> fetchRequests() async {
    final response = await localDatasource.fetchRequests();

    if (response == null) {
      return FailedState(
        const CustomError('Failed to fetch requests'),
      );
    }

    // Cast the response to the required type
    return SuccessState(_castResponse(response), null);
  }
}
