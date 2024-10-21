import 'package:modbus_app/core/usecase/usecase.dart';
import 'package:modbus_app/features/setup/domain/repository/setup_repository.dart';
import 'package:modbus_app/resources/datastate/datastate.dart';
import 'package:usb_serial/usb_serial.dart';

class SetupUsecase extends Usecase<DataState<UsbPort>, SetupParams> {
  final SetupRepository setupRepository;
  SetupUsecase(this.setupRepository);

  @override
  Future<DataState<UsbPort>> call({SetupParams? params}) {
    return setupRepository.setup(
      params!.baudRate,
      params.dataBits,
      params.parity,
      params.stopBits,
      params.slaveId,
      params.alias,
    );
  }
}

class SetupParams {
  final int baudRate;
  final int dataBits;
  final int parity;
  final double stopBits;
  final int slaveId;
  final String alias;

  SetupParams({
    required this.baudRate,
    required this.dataBits,
    required this.parity,
    required this.stopBits,
    required this.slaveId,
    required this.alias,
  });
}
