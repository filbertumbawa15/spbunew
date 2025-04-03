import 'package:blue_thermal_printer/blue_thermal_printer.dart'; // Import the blue_thermal_printer package
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothPrinterService {
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _connectedDevice;

  ValueNotifier<List<BluetoothDevice>> devicesNotifier = ValueNotifier([]);

  // Start scanning for Bluetooth devices
  void startScan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? isAvailable = await printer.isAvailable;
      if (isAvailable!) {
        _devicesList = await printer.getBondedDevices();
        String? deviceAddress = prefs.getString('connected_device');
        if (deviceAddress != null) {
          _connectedDevice = _devicesList.firstWhere(
            (device) => device.address == deviceAddress,
          );
        }
        devicesNotifier.value = List.from(_devicesList);
      }
    } catch (e) {
      print("Error scanning devices: $e");
    }
  }

// For Remove scanner from bondedDevices
  // void stopScan() async {

  // }

  // Connect to the selected Bluetooth printer
  Future<void> connectToPrinter(BluetoothDevice device) async {
    try {
      await printer.connect(device);
      _connectedDevice = device;
      _saveConnectedDevice(device);
      devicesNotifier.value = List.from(_devicesList);
    } catch (e) {
      print("Failed to connect to ${device.name}: $e");
    }
  }

  // Disconnect from the current Bluetooth printer
  Future<void> disconnectPrinter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceAddress = prefs.getString('connected_device');
    if (_connectedDevice != null) {
      _removeConnectedDevice();
      await printer.disconnect();
      _connectedDevice = null;
      devicesNotifier.value =
          List.from(_devicesList); // Update UI after disconnection
    } else if (deviceAddress != null && _connectedDevice == null) {
      _removeConnectedDevice();
    }
  }

  Future<void> _saveConnectedDevice(BluetoothDevice device) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'connected_device', device.address!); // Save the device address
  }

  Future<void> _removeConnectedDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('connected_device');
  }

  Future<void> loadConnectedDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceAddress = prefs.getString('connected_device');
    _devicesList = await printer.getBondedDevices();
    if (deviceAddress != null) {
      BluetoothDevice? device = _devicesList.firstWhere(
        (device) => device.address == deviceAddress,
      );
      _connectedDevice = device;
    }
  }

  Future<Uint8List> loadImageAsBytes(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    Uint8List bytes = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytes);
    // Resize image (adjust width to match printer's resolution)
    int targetWidth = 300; // Change this based on your printer specs
    img.Image resizedImage = img.copyResize(image!, width: targetWidth);

    img.Image grayscaleImage = img.grayscale(
      resizedImage,
    ); // Convert to grayscale
    return Uint8List.fromList(img.encodeBmp(grayscaleImage)); // Encode to BMP
  }

  // Get the list of devices
  List<BluetoothDevice> get devices => _devicesList;

  BluetoothDevice? get connectedDevice => _connectedDevice;
}
