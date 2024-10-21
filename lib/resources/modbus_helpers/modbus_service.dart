import 'dart:async';
import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

class ModbusService {
  final UsbPort? _port;
  final int _slaveId;

  int _functionCode = -1;
  int _quantity = -1;

  set functionCode(int code) {
    _functionCode = code;
  }

  set quantity(int q) {
    _quantity = q;
  }

  void closePort() {
    _port?.close();
    _functionCode = -1;
    _quantity = -1;
  }

  final List<int> _receivedData = [];
  Completer<List<int>> _responseCompleter = Completer();

  ModbusService({
    required UsbPort port,
    required int slaveId,
  })  : _port = port,
        _slaveId = slaveId {
    // Start listening to the port's input stream when the class is instantiated
    _listenToPort();
  }

  void _listenToPort() async {
    if (_port?.inputStream != null) {
      await for (final data in _port!.inputStream!) {
        print(data);
        // Append incoming data to the buffer
        _receivedData.addAll(data);

        // Check if the data is complete (based on expected byte count)
        int expectedByteCount =
            _calculateExpectedByteCount(_functionCode, _quantity);
        if (_receivedData.length >= expectedByteCount) {
          // Complete the response when full data is received
          _responseCompleter.complete(_receivedData);
        }
      }
    }
  }

  int _calculateExpectedByteCount(int functionCode, int quantity) {
    // 3 bytes header, 2 bytes per register, 2 bytes CRC
    return 3 + quantity * 2 + 2;
  }

  Future<List<int>> readModbusData({
    required int functionCode,
    required int startAddress,
    required int quantity,
  }) async {
    if (_port == null) {
      print("Port is not open.");
      return [];
    }

    _functionCode = functionCode;
    _quantity = quantity;

    // Clear any previous received data
    _receivedData.clear();
    _responseCompleter = Completer(); // Reset completer for new response

    // Build and write the Modbus request
    Uint8List request = _buildModbusReadRequest(_slaveId, startAddress);
    await _port.write(request);

    // Wait for the response (set a timeout to avoid hanging indefinitely)
    try {
      List<int> response =
          await _responseCompleter.future.timeout(const Duration(seconds: 2));
      List<int> processedResponse = _readResponse(
        Uint8List.fromList(response),
        functionCode,
        quantity,
      );

      _receivedData.clear(); // Clear the buffer after processing
      return processedResponse;
    } on TimeoutException {
      print("Modbus response timeout");
      return [];
    }
  }

  Future<void> writeModbusData({
    required int functionCode,
    required int startAddress,
    required List<int> values,
  }) async {
    if (_port == null) {
      print("Port is not open.");
      return;
    }

    _functionCode = functionCode;

    // Build the Modbus write request
    Uint8List request = _buildModbusWriteRequest(
      _slaveId,
      functionCode,
      startAddress,
      values,
    );
    await _port.write(request);
  }

  List<int> _readResponse(Uint8List data, int functionCode, int quantity) {
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

    return values;
  }

  Uint8List _buildModbusReadRequest(int slaveId, int startAddress) {
    List<int> frame = [];

    frame.add(slaveId); // Slave ID
    frame.add(_functionCode); // Function code

    // Start address
    frame.add((startAddress >> 8) & 0xFF); // High byte of the start address
    frame.add(startAddress & 0xFF); // Low byte of the start address

    // Quantity of addresses to read
    frame.add((_quantity >> 8) & 0xFF); // High byte of the quantity
    frame.add(_quantity & 0xFF); // Low byte of the quantity

    // Calculate CRC
    int crc = _calculateCRC16(Uint8List.fromList(frame));
    frame.add(crc & 0xFF); // CRC low byte
    frame.add((crc >> 8) & 0xFF); // CRC high byte

    return Uint8List.fromList(frame);
  }

  Uint8List _buildModbusWriteRequest(
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

  int _calculateCRC16(Uint8List data) {
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
