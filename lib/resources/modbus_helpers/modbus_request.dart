import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

class ModbusRequestHelper {
  static List<int> recivedData = [];
  static UsbPort port = UsbPort("");
  static int functionCode = 0;
  static int quantity = 0;

  set setPort(UsbPort p) {
    port = p;
  }

  set setFunctionCode(int code) {
    functionCode = code;
  }

  set setQuantity(int q) {
    quantity = q;
  }

  static Future<void> readModbusData({
    required UsbPort? port,
    required int slaveId,
    required int functionCode,
    required int startAddress,
    required int quantity,
  }) async {
    if (port == null) {
      print("Port is not open.");
      return;
    }

    // Build the Modbus request
    Uint8List request = _buildModbusReadRequest(
      slaveId,
      functionCode,
      startAddress,
      quantity,
    );
    await port.write(request);
  }

  static Future<void> writeModbusData({
    required UsbPort? port,
    required int slaveId,
    required int functionCode,
    required int startAddress,
    required List<int> values,
  }) async {
    if (port == null) {
      print("Port is not open.");
      return;
    }

    // Build the Modbus write request
    Uint8List request = _buildModbusWriteRequest(
      slaveId,
      functionCode,
      startAddress,
      values,
    );
    await port.write(request);
  }

  static clearRecivedData() {
    recivedData.clear();
  }

  static List<int>? handleAndReturnResponse(Uint8List data) {
    print("Received valid response: $data");

    // Add the received data to the list
    for (final i in data) {
      recivedData.add(i);
    }

    // Check if the response is complete
    if (data.length < 4) {
      return null;
    }

    // Calculate expected byte count based on function code
    int byteCount = data[2];
    int expectedByteCount = functionCode == 0x01 || functionCode == 0x02
        ? (quantity + 7) ~/ 8 // Coils or Discrete Inputs
        : quantity * 2; // Holding Registers or Input Registers

    if (byteCount != expectedByteCount) {
      // Response is not complete yet
      return null;
    } else {
      // Response is complete
      return _readResponse(
        data: data,
        functionCode: functionCode,
        quantity: quantity,
      );
    }
  }

  static List<int> _readResponse({
    required Uint8List data,
    required int functionCode,
    required int quantity,
  }) {
    print("Start processing response: $data");

    // Parse the values based on function code
    List<int> values = [];

    for (int i = 0; i < quantity; i++) {
      int value;
      if (functionCode == 0x01 || functionCode == 0x02) {
        // For coils or discrete inputs
        int byteIndex = 3 + (i ~/ 8);
        int bitIndex = i % 8;
        value = (data[byteIndex] & (1 << bitIndex)) != 0 ? 1 : 0;
      } else {
        // For holding registers or input registers
        int byteIndex = 3 + i * 2;
        value = (data[byteIndex] << 8) | data[byteIndex + 1];
      }
      values.add(value);
    }

    // Clear the received data
    recivedData.clear();

    print("Values: $values");
    return values;
  }

  static Uint8List _buildModbusReadRequest(
      int slaveId, int functionCode, int startAddress, int quantity) {
    List<int> frame = [];

    frame.add(slaveId); // Slave ID
    frame.add(functionCode); // Function code

    // Start address
    frame.add((startAddress >> 8) & 0xFF); // High byte of the start address
    frame.add(startAddress & 0xFF); // Low byte of the start address

    // Quantity of addresses to read
    frame.add((quantity >> 8) & 0xFF); // High byte of the quantity
    frame.add(quantity & 0xFF); // Low byte of the quantity

    // Calculate CRC
    int crc = _calculateCRC16(Uint8List.fromList(frame));
    frame.add(crc & 0xFF); // CRC low byte
    frame.add((crc >> 8) & 0xFF); // CRC high byte

    return Uint8List.fromList(frame);
  }

  static Uint8List _buildModbusWriteRequest(
      int slaveId, int functionCode, int startAddress, List<int> values) {
    List<int> frame = [];

    frame.add(slaveId); // Slave ID
    frame.add(functionCode); // Function code

    // Start address
    frame.add((startAddress >> 8) & 0xFF); // High byte of the start address
    frame.add(startAddress & 0xFF); // Low byte of the start address

    if (functionCode == 0x05 || functionCode == 0x06) {
      // Single coil or single register
      int value = values[0];
      frame.add((value >> 8) & 0xFF); // High byte of the value
      frame.add(value & 0xFF); // Low byte of the value
    } else if (functionCode == 0x0F || functionCode == 0x10) {
      // Multiple coils or multiple registers
      int quantity = values.length;
      frame.add((quantity >> 8) & 0xFF); // High byte of the quantity
      frame.add(quantity & 0xFF); // Low byte of the quantity

      // Byte count
      int byteCount = functionCode == 0x0F ? (quantity + 7) ~/ 8 : quantity * 2;
      frame.add(byteCount);

      // Values
      for (int value in values) {
        if (functionCode == 0x0F) {
          frame.add(value); // Coils are already bits, no shifting needed
        } else {
          frame.add((value >> 8) & 0xFF); // High byte of the register value
          frame.add(value & 0xFF); // Low byte of the register value
        }
      }
    }

    // Calculate CRC
    int crc = _calculateCRC16(Uint8List.fromList(frame));
    frame.add(crc & 0xFF); // CRC low byte
    frame.add((crc >> 8) & 0xFF); // CRC high byte

    return Uint8List.fromList(frame);
  }

  static int _calculateCRC16(Uint8List data) {
    int crc = 0xFFFF;

    for (int i = 0; i < data.length; i++) {
      crc ^= data[i];
      for (int j = 0; j < 8; j++) {
        if ((crc & 0x0001) != 0) {
          crc >>= 1;
          crc ^= 0xA001;
        } else {
          crc >>= 1;
        }
      }
    }

    return crc;
  }
}
