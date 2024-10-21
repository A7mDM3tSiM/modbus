import 'package:usb_serial/usb_serial.dart';

class ModbusSetupHelper {
  static int getDataBits(int dataBits) {
    switch (dataBits) {
      case 5:
        return UsbPort.DATABITS_5;
      case 6:
        return UsbPort.DATABITS_6;
      case 7:
        return UsbPort.DATABITS_7;
      case 8:
        return UsbPort.DATABITS_8;
      default:
        return UsbPort.DATABITS_8;
    }
  }

  static int getStopBits(double stopBits) {
    switch (stopBits) {
      case 1.0:
        return UsbPort.STOPBITS_1;
      case 1.5:
        return UsbPort.STOPBITS_1_5;
      case 2.0:
        return UsbPort.STOPBITS_2;
      default:
        return UsbPort.STOPBITS_1;
    }
  }

  static int getParity(int parity) {
    switch (parity) {
      case 0:
        return UsbPort.PARITY_NONE;
      case 1:
        return UsbPort.PARITY_ODD;
      case 2:
        return UsbPort.PARITY_EVEN;
      case 3:
        return UsbPort.PARITY_MARK;
      case 4:
        return UsbPort.PARITY_SPACE;
      default:
        return UsbPort.PARITY_NONE;
    }
  }
}
