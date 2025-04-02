import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bon/services/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PertaminaFormScreen extends StatefulWidget {
  const PertaminaFormScreen({super.key});

  @override
  State<PertaminaFormScreen> createState() => _PertaminaFormScreenState();
}

class _PertaminaFormScreenState extends State<PertaminaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _transactionNumberController =
      TextEditingController();
  final TextEditingController _spbuController = TextEditingController();
  final TextEditingController _noTransController = TextEditingController();
  final TextEditingController _alamatSpbuController = TextEditingController();
  final TextEditingController _pompaController = TextEditingController();
  final TextEditingController _hargaPerLiterController =
      TextEditingController(text: '10000');
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _totalHargaController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _changeController = TextEditingController();
  final TextEditingController _noPlatController = TextEditingController();
  final TextEditingController _operatorController = TextEditingController();

  bool useChange = false;

  String _shift = '1';
  String _produk = 'Pertalite';
  DateTime _waktu = DateTime.now();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

  final BluetoothPrinterService _bluetoothPrinterService =
      BluetoothPrinterService();

  @override
  void initState() {
    super.initState();
    _bluetoothPrinterService.loadConnectedDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pertamina Fuel Receipt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Pertamina Fuel Receipt',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Transaction Number
              TextFormField(
                controller: _transactionNumberController,
                decoration: const InputDecoration(
                  labelText: 'No. Transaksi',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter transaction number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // SPBU
              TextFormField(
                controller: _spbuController,
                decoration: const InputDecoration(
                  labelText: 'SPBU',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter SPBU';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Alamat SPBU
              TextFormField(
                controller: _alamatSpbuController,
                decoration: const InputDecoration(
                  labelText: 'Alamat SPBU',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              const SizedBox(height: 16),

              // Shift
              DropdownButtonFormField<String>(
                value: _shift,
                decoration: const InputDecoration(
                  labelText: 'Shift',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _shift = newValue!;
                  });
                },
                items: ['1', '2']
                    .map((value) =>
                        DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // No Trans
              TextFormField(
                controller: _noTransController,
                decoration: const InputDecoration(
                  labelText: 'No. Trans',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter No Trans';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Waktu
              TextFormField(
                controller:
                    TextEditingController(text: _dateFormat.format(_waktu)),
                decoration: const InputDecoration(
                  labelText: 'Waktu',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onTap: () async {
                  // Open the date picker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _waktu,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    // Open time picker to pick time with hour and minute
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_waktu),
                    );

                    if (pickedTime != null) {
                      // // After selecting time, pick seconds using Dropdown
                      setState(() {
                        _waktu = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                          int.parse(DateTime.now()
                              .second
                              .toString()
                              .padLeft(2, '0')), // Include the seconds
                        );
                      });
                    }
                  }
                },
                readOnly: true, // Make the field readonly to trigger picker
              ),
              const SizedBox(height: 16),

              // Pompa
              TextFormField(
                controller: _pompaController,
                decoration: const InputDecoration(
                  labelText: 'Pulau/Pompa',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              const SizedBox(height: 16),

              // Produk
              DropdownButtonFormField<String>(
                value: _produk,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _produk = newValue!;
                  });
                },
                items: ['Pertalite', 'Pertamax', 'Dex']
                    .map((value) =>
                        DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Harga per Liter
              TextFormField(
                controller: _hargaPerLiterController,
                decoration: const InputDecoration(
                  labelText: 'Harga/Liter (Rp)',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Volume
              TextFormField(
                controller: _volumeController,
                decoration: const InputDecoration(
                  labelText: 'Volume (Liter)',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Total Harga
              TextFormField(
                controller: _totalHargaController,
                decoration: const InputDecoration(
                  labelText: 'Total Harga (Rp)',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Operator
              TextFormField(
                controller: _operatorController,
                decoration: const InputDecoration(
                  labelText: 'Operator',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              const SizedBox(height: 20),

              // Cash
              TextFormField(
                controller: _cashController,
                decoration: const InputDecoration(
                  labelText: 'Cash (Rp)',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                keyboardType: TextInputType.number,
              ),
              // Checkbox for using CHANGE
              Row(
                children: [
                  Checkbox(
                    value: useChange,
                    onChanged: (value) {
                      setState(() {
                        useChange = value!;
                      });
                    },
                  ),
                  const Text("Gunakan CHANGE"),
                ],
              ),
              if (useChange)
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: TextField(
                    controller: _changeController,
                    decoration: const InputDecoration(
                      labelText: 'Change',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),

              // No Plat
              TextFormField(
                controller: _noPlatController,
                decoration: const InputDecoration(
                  labelText: 'No. Plat',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Fetch connected device from BluetoothPrinterService and print
                    if (_bluetoothPrinterService.connectedDevice != null) {
                      printReceipt();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Printer not connected')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Print Receipt'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to print the receipt
  void printReceipt() async {
    BluetoothDevice? device = _bluetoothPrinterService.connectedDevice;
    print(device);
    if (device != null) {
      _bluetoothPrinterService.printer
          .printCustom(_transactionNumberController.text, 4, 1);
      _bluetoothPrinterService.printer
          .printCustom("SPBU ${_spbuController.text}", 0, 1);
      _bluetoothPrinterService.printer
          .printCustom(_alamatSpbuController.text, 0, 1);
      _bluetoothPrinterService.printer.printCustom(
        "Shift: $_shift    No. Trans: ${_noTransController.text}",
        0,
        1,
      );
      _bluetoothPrinterService.printer.printCustom("Waktu: $_waktu", 0, 0);
      _bluetoothPrinterService.printer
          .printCustom("--------------------------------", 0, 1);

      // Print dynamic input data from the form
      _bluetoothPrinterService.printer
          .printCustom("Pulau/Pompa: ${_pompaController.text}", 0, 0);
      _bluetoothPrinterService.printer
          .printCustom("Nama Produk: $_produk", 0, 0);
      _bluetoothPrinterService.printer.printCustom(
          "Harga/Liter: Rp. ${_hargaPerLiterController.text}", 0, 0);
      _bluetoothPrinterService.printer
          .printCustom("Volume     : (L) ${_volumeController.text}", 0, 0);
      _bluetoothPrinterService.printer
          .printCustom("Total Harga: (L) ${_totalHargaController.text}", 0, 0);
      _bluetoothPrinterService.printer
          .printCustom("Operator   : ${_operatorController.text}", 0, 0);

      _bluetoothPrinterService.printer
          .printCustom("--------------------------------", 0, 1);
      _bluetoothPrinterService.printer.printCustom("CASH", 0, 0);
      _bluetoothPrinterService.printer.printCustom(_cashController.text, 0, 2);
      if (useChange && _changeController.text.isNotEmpty) {
        _bluetoothPrinterService.printer.printCustom("CHANGE", 0, 0);
        _bluetoothPrinterService.printer
            .printCustom(_changeController.text, 0, 2);
      }
      _bluetoothPrinterService.printer
          .printCustom("--------------------------------", 0, 1);
      _bluetoothPrinterService.printer
          .printCustom("No. Plat   : ${_noPlatController.text}", 0, 0);
      _bluetoothPrinterService.printer
          .printCustom("--------------------------------", 0, 1);

      _bluetoothPrinterService.printer.printNewLine();
      _bluetoothPrinterService.printer.printNewLine();
      _bluetoothPrinterService.printer.paperCut();
      // _bluetoothPrinterService.printer.printCustom("142011157", 4, 1);
    }
  }
}
