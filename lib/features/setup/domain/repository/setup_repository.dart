import 'package:modbus_app/resources/datastate/datastate.dart';
import 'package:usb_serial/usb_serial.dart';

abstract class SetupRepository {
  Future<DataState<UsbPort>> setup(
    int baudRate,
    int dataBits,
    int parity,
    double stopBits,
    int slaveId,
    String alias,
  );
}
