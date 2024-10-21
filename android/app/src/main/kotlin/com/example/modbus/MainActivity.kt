package com.example.modbus

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val ACTION_USB_PERMISSION = "com.example.USB_PERMISSION"

    private fun requestUsbPermission(device: UsbDevice) {
        val usbManager = getSystemService(USB_SERVICE) as UsbManager
        val permissionIntent = PendingIntent.getBroadcast(this, 0, Intent(ACTION_USB_PERMISSION), 0)
        usbManager.requestPermission(device, permissionIntent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.usb/permissions")
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "requestUsbPermission" -> {
                            // Get the UsbManager and the connected devices
                            val usbManager = getSystemService(Context.USB_SERVICE) as UsbManager
                            val deviceList: HashMap<String, UsbDevice>? = usbManager.deviceList
                            val device: UsbDevice? = deviceList?.values?.firstOrNull()

                            device?.let {
                                requestUsbPermission(it)
                                result.success("Permission Requested")
                            }
                                    ?: run {
                                        result.error("NO_DEVICE", "No USB device found", null)
                                    }
                        }
                        else -> result.notImplemented()
                    }
                }
    }
}
