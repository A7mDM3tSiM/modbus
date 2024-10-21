import 'package:modbus_app/features/setup/domain/repository/setup_repository.dart';
import 'package:modbus_app/resources/datastate/datastate.dart';
import 'package:usb_serial/usb_serial.dart';

import '../datasources/setup_datasource.dart';

class SetupRepositoryImpl implements SetupRepository {
  final SetupDatasource setupDatasource;
  const SetupRepositoryImpl(this.setupDatasource);

  @override
  Future<DataState<UsbPort>> setup(
    int baudRate,
    int dataBits,
    int parity,
    double stopBits,
    int slaveId,
    String alias,
  ) async {
    final response = await setupDatasource.setup(
      baudRate,
      dataBits,
      parity,
      stopBits,
      slaveId,
      alias,
    );

    if (response == null) {
      return FailedState(const CustomError("Failed to open port"));
    }

    return SuccessState(response, null);
  }
}
