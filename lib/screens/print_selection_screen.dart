import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bon/services/bluetooth_service.dart';

class PrinterSelectionScreen extends StatefulWidget {
  const PrinterSelectionScreen({super.key});

  @override
  State<PrinterSelectionScreen> createState() => _PrinterSelectionScreenState();
}

class _PrinterSelectionScreenState extends State<PrinterSelectionScreen> {
  final BluetoothPrinterService _bluetoothPrinterService =
      BluetoothPrinterService();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _bluetoothPrinterService.startScan();
    // _bluetoothPrinterService.loadConnectedDevice();
  }

  // Toggle scanning state
  void _toggleScan() {
    _bluetoothPrinterService.startScan();

    setState(() {
      _isScanning = !_isScanning;
    });
  }

  // Connect to the selected printer
  void _connectToPrinter(BluetoothDevice device) {
    _bluetoothPrinterService.connectToPrinter(device);
  }

  // Disconnect the current printer
  void _disconnectPrinter() {
    _bluetoothPrinterService.disconnectPrinter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Printer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ValueListenableBuilder<List<BluetoothDevice>>(
              valueListenable: _bluetoothPrinterService.devicesNotifier,
              builder: (context, devices, _) {
                return Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Available Printers:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            BluetoothDevice device = devices[index];
                            bool isConnected =
                                _bluetoothPrinterService.connectedDevice ==
                                    device;
                            return ListTile(
                              title: Text(device.name!.isEmpty
                                  ? 'Unknown device'
                                  : device.name!),
                              subtitle: Text(device.address!),
                              trailing: isConnected
                                  ? const Icon(Icons.check_circle,
                                      color:
                                          Colors.green) // Mark connected device
                                  : const Icon(Icons.bluetooth),
                              onTap: () {
                                if (!isConnected) {
                                  _connectToPrinter(
                                      device); // Connect when tapped
                                }
                              },
                            );
                          },
                        ),
                      ),
                      if (_bluetoothPrinterService.connectedDevice != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            onPressed: _disconnectPrinter,
                            child: const Text('Disconnect Printer'),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: _toggleScan,
              child: Text(_isScanning ? 'Stop Scanning' : 'Start Scanning'),
            ),
          ],
        ),
      ),
    );
  }
}
