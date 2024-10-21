import 'package:modbus_app/core/usecase/usecase.dart';
import 'package:modbus_app/features/history/data/models/modbus_request_model.dart';
import 'package:modbus_app/features/history/domain/entites/modbus_request_entity.dart';
import 'package:modbus_app/resources/datastate/datastate.dart';

import '../repositories/history_repository.dart';

class SaveRequestUsecase extends Usecase<DataState<int>, ModbusRequest> {
  final HistoryRepository repository;
  const SaveRequestUsecase(this.repository);

  @override
  Future<DataState<int>> call({ModbusRequest? params}) async {
    final request = ModbusRequestModel.fromEntity(params!);
    return repository.saveRequest(request.toMap());
  }
}
