package com.example.modbus

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.util.Log

class UsbBroadcastReceiver : BroadcastReceiver() {
    companion object {
        const val ACTION_USB_PERMISSION = "com.example.USB_PERMISSION"
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.action
        if (ACTION_USB_PERMISSION == action) {
            synchronized(this) {
                val device: UsbDevice? = intent.getParcelableExtra(UsbManager.EXTRA_DEVICE)

                if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                    device?.let {
                        // Call method to set up device communication
                        Log.d("USB", "Permission granted for device $device")
                    }
                } else {
                    Log.d("USB", "Permission denied for device $device")
                }
            }
        }
    }
}
