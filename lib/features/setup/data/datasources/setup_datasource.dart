import 'package:usb_serial/usb_serial.dart';

import '../../../../resources/modbus_helpers/modbus_setup_helper.dart';

class SetupDatasource {
  Future<UsbPort?> setup(int baudRate, int dataBits, int parity,
      double stopBits, int slaveId, String alias) {
    // Get the list of connected USB devices (prabably only one)
    return UsbSerial.listDevices().then((devices) async {
      if (devices.isNotEmpty) {
        UsbPort? port = await devices[0].create();

        if (port == null) {
          throw Exception("Failed to open port");
        }

        // Open the port and set the parameters
        if (await port.open()) {
          await port.setPortParameters(
            baudRate,
            ModbusSetupHelper.getDataBits(dataBits),
            ModbusSetupHelper.getStopBits(stopBits),
            ModbusSetupHelper.getParity(parity),
          );

          return port;
        }
      }

      return null;
    });
  }
}
