import 'package:modbus_app/features/history/domain/entites/modbus_request_entity.dart';
import 'package:modbus_app/resources/datastate/datastate.dart';

abstract class HistoryRepository {
  Future<DataState<int>> saveRequest(Map<String, dynamic> request);

  Future<DataState<int>> updateRequest(Map<String, dynamic> request);

  Future<DataState<int>> deleteRequest(int id);

  Future<DataState<List<ModbusRequest>>> fetchRequests();
}
