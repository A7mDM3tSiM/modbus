import 'package:get_it/get_it.dart';
import 'package:modbus_app/features/history/data/repositories/history_repoistory_impl.dart';
import 'package:modbus_app/features/history/domain/repositories/history_repository.dart';
import 'package:modbus_app/features/history/domain/usecases/fetch_requests_usecase.dart';
import 'package:modbus_app/features/history/domain/usecases/save_request_usecase.dart';
import 'package:modbus_app/features/history/presentation/blocs/history_bloc.dart';
import 'package:modbus_app/features/setup/data/repository/setup_repository.dart';
import 'package:modbus_app/features/setup/domain/repository/setup_repository.dart';
import 'package:modbus_app/features/setup/presentation/blocs/setup_bloc/setup_bloc.dart';

import 'features/history/data/datasources/history_local_datasource.dart';
import 'features/history/domain/usecases/delete_request_usecase.dart';
import 'features/history/domain/usecases/update_request_usecase.dart';
import 'features/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'features/setup/data/datasources/setup_datasource.dart';
import 'features/setup/domain/usecases/setup_usecase.dart';
import 'resources/sqflite_helper/sqflite_helper.dart';

final sl = GetIt.instance;

void setup() {
  sl.registerLazySingleton(() => DatabaseHelper());

  // Data sources
  sl.registerLazySingleton(() => HistoryLocalDatasource(sl()));
  sl.registerLazySingleton(() => SetupDatasource());

  // Repository
  sl.registerLazySingleton<SetupRepository>(() => SetupRepositoryImpl(sl()));
  sl.registerLazySingleton<HistoryRepository>(
      () => HistoryRepoistoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => SaveRequestUsecase(sl()));
  sl.registerLazySingleton(() => UpdateRequestUsecase(sl()));
  sl.registerLazySingleton(() => DeleteRequestUsecase(sl()));
  sl.registerLazySingleton(() => FetchRequestsUsecase(sl()));
  sl.registerLazySingleton(() => SetupUsecase(sl()));

  // Bloc
  sl.registerLazySingleton(() => SetupBloc(sl()));
  sl.registerLazySingleton(() => RequestBloc());
  sl.registerLazySingleton(() => HistoryBloc(sl(), sl(), sl(), sl()));
}
