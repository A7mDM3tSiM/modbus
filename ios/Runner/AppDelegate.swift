import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let modbusChannel = FlutterMethodChannel(name: "com.example.modbus/serial",
                                            binaryMessenger: controller.binaryMessenger)
    
    modbusChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        switch call.method {
        case "initSerialPort":
            guard let args = call.arguments as? [String: Any],
                let portName = args["portName"] as? String,
                let baudRate = args["baudRate"] as? Int else {
                    result(FlutterError(code: "BAD_ARGUMENTS", message: "Invalid arguments", details: nil))
                    return
                }
            let modbusSerial = ModbusSerial(port: portName, baudRate: baudRate)
            do {
                try modbusSerial.open()
                result("Serial port initialized")
            } catch {
                result(FlutterError(code: "UNAVAILABLE", message: "Failed to initialize serial port", details: error.localizedDescription))
            }
        case "readHoldingRegisters":
            guard let args = call.arguments as? [String: Any],
                let startAddress = args["startAddress"] as? Int,
                let quantity = args["quantity"] as? Int else {
                    result(FlutterError(code: "BAD_ARGUMENTS", message: "Invalid arguments", details: nil))
                    return
                }
            if let modbusSerial = modbusSerial,
            let registers = modbusSerial.readHoldingRegisters(startAddress: startAddress, quantity: quantity) {
                result(registers)
            } else {
                result(FlutterError(code: "UNAVAILABLE", message: "Failed to read data", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
