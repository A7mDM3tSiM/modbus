import Foundation
import SwiftSerial

@objc class ModbusSerial: NSObject {
    private var serialPort: SerialPort

    @objc init(port: String, baudRate: Int) {
        serialPort = SerialPort(path: port)
        serialPort.setSettings(receiveRate: .baud9600, transmitRate: .baud9600, minimumBytesToRead: 1)
    }

    @objc func open() throws {
        try serialPort.openPort()
    }

    @objc func close() {
        serialPort.closePort()
    }

    @objc func readHoldingRegisters(startAddress: Int, quantity: Int) -> [Int]? {
        let request = constructRequest(startAddress: startAddress, quantity: quantity)
        try? serialPort.writeData(request)
        var response = [UInt8](repeating: 0, count: 5 + 2 * quantity)
        _ = try? serialPort.readData(into: &response)
        return parseModbusResponse(response: response, length: response.count)
    }

    private func constructRequest(startAddress: Int, quantity: Int) -> [UInt8] {
        var request = [UInt8](repeating: 0, count: 8)
        request[0] = 1 // Slave address
        request[1] = 3 // Function code
        request[2] = UInt8(startAddress >> 8)
        request[3] = UInt8(startAddress & 0xFF)
        request[4] = UInt8(quantity >> 8)
        request[5] = UInt8(quantity & 0xFF)
        let crc = calculateCRC(data: request, length: 6)
        request[6] = crc[0]
        request[7] = crc[1]
        return request
    }

    private func calculateCRC(data: [UInt8], length: Int) -> [UInt8] {
        var crc: UInt16 = 0xFFFF
        for index in 0..<length {
            crc ^= UInt16(data[index])
            for _ in 0..<8 {
                if (crc & 0x0001) != 0 {
                    crc >>= 1
                    crc ^= 0xA001
                } else {
                    crc >>= 1
                }
            }
        }
        return [UInt8(crc & 0xFF), UInt8(crc >> 8)]
    }

    private func parseModbusResponse(response: [UInt8], length: Int) -> [Int]? {
        guard length >= 5 else { return nil }
        var values = [Int]()
        for index in stride(from: 3, to: length - 2, by: 2) {
            let value = Int(response[index]) << 8 | Int(response[index + 1])
            values.append(value)
        }
        return values
    }
}
