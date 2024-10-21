import 'package:modbus_app/core/usecase/usecase.dart';
import 'package:modbus_app/resources/datastate/datastate.dart';

import '../repositories/history_repository.dart';

class DeleteRequestUsecase extends Usecase<DataState<int>, int> {
  final HistoryRepository repository;
  const DeleteRequestUsecase(this.repository);

  @override
  Future<DataState<int>> call({int? params}) async {
    return repository.deleteRequest(params!);
  }
}
