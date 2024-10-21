import 'package:modbus_app/core/usecase/usecase.dart';

import '../../../../resources/datastate/datastate.dart';
import '../../data/models/modbus_request_model.dart';
import '../entites/modbus_request_entity.dart';
import '../repositories/history_repository.dart';

class UpdateRequestUsecase extends Usecase<DataState<int>, ModbusRequest> {
  final HistoryRepository repository;
  const UpdateRequestUsecase(this.repository);

  @override
  Future<DataState<int>> call({ModbusRequest? params}) async {
    final request = ModbusRequestModel.fromEntity(params!);
    return repository.updateRequest(request.toMap());
  }
}
