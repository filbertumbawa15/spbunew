import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bon/services/bluetooth_service.dart';
import 'package:bon/widgets/print_preview_dialog.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img; // Import the image package

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
  String? formattedDate;
  String? _selectedOptionKeterangan = '';

  final BluetoothPrinterService _bluetoothPrinterService =
      BluetoothPrinterService();

  @override
  void initState() {
    super.initState();
    _bluetoothPrinterService.loadConnectedDevice();
    formattedDate = _dateFormat.format(_waktu);
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
                          DateTime.now().second,
                        );
                        formattedDate = _dateFormat.format(_waktu);
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

              //Keterangan
              const Text(
                'Pilih jenis keterangan yang ingin digunakan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text(
                  'Anda menggunakan subsidi BBM dari negara : Biosolar Rp 4.965/liter dan Pertalite Rp 1.512/liter untuk tidak disalahgunakan. '
                  'Mari gunakan Pertamax series dan Dex series. Subsidi hanya untuk yang berhak menerimanya.',
                ),
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedOptionKeterangan,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedOptionKeterangan = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  'Subsidi Februari 2024 : Bio Solar Rp 5.233/Liter dan Pertalite Rp 1.301/Liter\n'
                  'Mari gunakan Pertamax Series Dan Dex Series\n'
                  'Subsidi hanya untuk yang berhak menerimanya. TERIMA KASIH',
                ),
                leading: Radio<String>(
                  value: '2',
                  groupValue: _selectedOptionKeterangan,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedOptionKeterangan = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Fetch connected device from BluetoothPrinterService and print
                    if (_bluetoothPrinterService.connectedDevice != null) {
                      printReceipt(flag: "Preview");
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
                child: const Text('Preview Print'),
              ),

              const SizedBox(height: 16),

              // Print Button
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
  void printReceipt({String? flag}) async {
    BluetoothDevice? device = _bluetoothPrinterService.connectedDevice;
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final generator = Generator(paper, profile);
    final List<int> bytes = [];

    Uint8List imageBytes =
        await _bluetoothPrinterService.loadImageAsBytes('assets/Pertamina.png');

    if (flag == "Preview") {
    } else {
      if (device != null) {
        _bluetoothPrinterService.printer.printNewLine();
        _bluetoothPrinterService.printer.printImageBytes(imageBytes);
        bytes.addAll(generator.text(_transactionNumberController.text,
            styles: const PosStyles(
                align: PosAlign.center,
                height: PosTextSize.size2,
                width: PosTextSize.size2,
                bold: true)));
        _bluetoothPrinterService.printer.writeBytes(Uint8List.fromList(bytes));

        _bluetoothPrinterService.printer
            .printCustom("SPBU ${_spbuController.text}", 0, 1);
        _bluetoothPrinterService.printer
            .printCustom(_alamatSpbuController.text, 0, 1);
        _bluetoothPrinterService.printer.printCustom(
          "Shift: $_shift    No. Trans: ${_noTransController.text}",
          0,
          1,
        );
        _bluetoothPrinterService.printer
            .printCustom(" Waktu: $formattedDate", 0, 0);
        _bluetoothPrinterService.printer
            .printCustom("--------------------------------", 0, 1);

        // Print dynamic input data from the form
        _bluetoothPrinterService.printer
            .printCustom("Pulau/Pompa: ${_pompaController.text}", 0, 0);
        _bluetoothPrinterService.printer
            .printCustom("Nama Produk: ${_produk.toUpperCase()}", 0, 0);
        _bluetoothPrinterService.printer.printCustom(
            "Harga/Liter: Rp. ${_hargaPerLiterController.text}", 0, 0);
        _bluetoothPrinterService.printer
            .printCustom("Volume     : (L) ${_volumeController.text}", 0, 0);
        _bluetoothPrinterService.printer.printCustom(
            "Total Harga: Rp. ${_totalHargaController.text}", 0, 0);
        _bluetoothPrinterService.printer
            .printCustom("Operator   : ${_operatorController.text}", 0, 0);

        _bluetoothPrinterService.printer
            .printCustom("--------------------------------", 0, 1);
        _bluetoothPrinterService.printer.printCustom("CASH", 0, 0);
        _bluetoothPrinterService.printer
            .printCustom(_cashController.text, 0, 2);
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
        if (_selectedOptionKeterangan == '1') {
          _bluetoothPrinterService.printer
              .printCustom("Anda menggunakan subsidi BBM dar", 0, 1);
          _bluetoothPrinterService.printer
              .printCustom("i negara : Biosolar Rp 4.965/lit", 0, 1);
          _bluetoothPrinterService.printer
              .printCustom("er dan Pertalite Rp 1.512/liter ", 0, 1);
          _bluetoothPrinterService.printer
              .printCustom("untuk tidak disalahgunakan. Mari", 0, 1);
          _bluetoothPrinterService.printer
              .printCustom(" gunakan Pertamax series dan Dex", 0, 1);
          _bluetoothPrinterService.printer
              .printCustom(" series. subsidi hanya untuk yan", 0, 1);
          _bluetoothPrinterService.printer.printCustom("g", 0, 1);
          _bluetoothPrinterService.printer
              .printCustom("berhak menerimanya.", 0, 1);
        } else if (_selectedOptionKeterangan == '2') {
          _bluetoothPrinterService.printer
              .printCustom("Subsidi Februari 2024 : Bio Sol ", 0, 1);
          _bluetoothPrinterService.printer
              .printCustom("ar Rp 5.233/Liter dan Pertalite ", 0, 1);
          _bluetoothPrinterService.printer.printCustom("Rp 1.301/Liter", 0, 1);
          _bluetoothPrinterService.printer
              .printCustom("Mari gunakan Pertamax Series Dan", 0, 1);
          _bluetoothPrinterService.printer.printCustom("Dex Series", 0, 1);
          _bluetoothPrinterService.printer
              .printCustom("Subsidi hanya untuk yang berhak ", 0, 1);
          _bluetoothPrinterService.printer
              .printCustom("menerimanya. TERIMA KASIH", 0, 1);
        }

        _bluetoothPrinterService.printer.printNewLine();
        _bluetoothPrinterService.printer.printNewLine();
        _bluetoothPrinterService.printer.paperCut();
      }
    }
  }
}
