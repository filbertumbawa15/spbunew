import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bon/services/bluetooth_service.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as imgnya;

class PertaminaFormScreenCustom extends StatefulWidget {
  const PertaminaFormScreenCustom({super.key});

  @override
  State<PertaminaFormScreenCustom> createState() =>
      _PertaminaFormScreenCustomState();
}

class _PertaminaFormScreenCustomState extends State<PertaminaFormScreenCustom> {
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
      appBar: AppBar(title: const Text('Pertamina Fuel Receipt Custom')),
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

  Future<Uint8List?> createTextImage(Map<String, dynamic> content) async {
    // Create a recorder and canvas to capture the drawing of the text
    final recorder = ui.PictureRecorder();
    double totalHeight = 0;
    double maxWidth = 0;
    List<TextPainter> textPainters = [];
    TextPainter textPainter;

    // Create TextPainters for each line of text and calculate the total height
    content.forEach((key, value) {
      // Determine font size based on key (conditional font size for 'SPBU';
      if (key == "header") {
        textPainter = TextPainter(
          text: TextSpan(
            text: "$value",
            style: const TextStyle(
              letterSpacing: -1.2,
              fontFamily: 'CustomFontTwo',
              fontSize: 27,
              color: Colors.black,
            ),
          ),
          textDirection: ui.TextDirection.ltr,
          textAlign: TextAlign.center,
        );
      } else if (key.contains("sepa")) {
        textPainter = TextPainter(
          text: TextSpan(
            text: "$value", // Key and value as string
            style: const TextStyle(
              letterSpacing: -1.5,
              fontFamily: 'CustomFontTwo',
              fontSize: 26,
              color: Colors.black,
            ),
          ),
          textDirection: ui.TextDirection.ltr,
          textAlign: TextAlign.center,
        );
      } else if (key.contains("spbuname") ||
          key.contains("jl") ||
          key.contains("shift") ||
          key.contains("waktu") ||
          key.contains("cash") ||
          key.contains("cashvalue") ||
          key.contains("ket")) {
        textPainter = TextPainter(
          text: TextSpan(
            text: "$value", // Key and value as string
            style: const TextStyle(
              letterSpacing: -1.5,
              fontFamily: 'CustomFontTwo',
              fontSize: 23,
              color: Colors.black,
            ),
          ),
          textDirection: ui.TextDirection.ltr,
          textAlign: TextAlign.center,
        );
      } else {
        textPainter = TextPainter(
          text: TextSpan(
            style: const TextStyle(
              fontFamily:
                  'CustomFontTwo', // Use Monospaced font for precise alignment
              fontSize: 23,
              color: Colors.black,
            ),
            children: [
              TextSpan(text: key.padRight(11)),
              const TextSpan(
                  text: ": "), // Ensure colon is always in the same spot
              TextSpan(text: value),
            ],
          ),
          textDirection: ui.TextDirection.ltr,
          textAlign: TextAlign.left,
        );
      }

      textPainter.layout(minWidth: 1000, maxWidth: 5000);
      textPainters.add(textPainter);
      totalHeight += textPainter.height;
      maxWidth = maxWidth > textPainter.width ? maxWidth : textPainter.width;
    });

    // Create a canvas with a size large enough to fit all the text
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(1000, 5000),
      ),
    );

    // Paint each TextPainter (line of text) onto the canvas
    double currentHeight = 0;
    for (var textPainter in textPainters) {
      // For SPBU, we center the text, otherwise, we align it left
      if (textPainter.text?.toPlainText().contains("14201167") ?? false) {
        // Calculate the offset to center the text
        double centerOffset = (maxWidth - textPainter.width) / 2 * 0.88;
        textPainter.paint(canvas, Offset(centerOffset, currentHeight));
        textPainter.paint(
            canvas, Offset(centerOffset + 0.5, currentHeight + 0.5));
      } else if (textPainter.text?.toPlainText().contains("SPBU") ?? false) {
        // Calculate the offset to center the text
        double centerOffset = (maxWidth - textPainter.width) / 2 * 0.7;
        textPainter.paint(canvas, Offset(centerOffset, currentHeight));
      } else if (textPainter.text?.toPlainText().contains("JL.") ?? false) {
        // Calculate the offset to center the text
        double centerOffset = (maxWidth - textPainter.width) / 2 * 0.3;
        textPainter.paint(canvas, Offset(centerOffset, currentHeight));
      } else if (textPainter.text?.toPlainText().contains("--") ?? false) {
        // Calculate the offset to center the text
        double centerOffset = (maxWidth - textPainter.width) / 2 * 0.3;
        textPainter.paint(canvas, Offset(centerOffset, currentHeight));
      } else if (textPainter.text?.toPlainText().startsWith("300,000") ??
          false) {
        double rightOffset = maxWidth - textPainter.width - (maxWidth * 0.01);
        textPainter.paint(canvas, Offset(rightOffset, currentHeight));
      } else {
        textPainter.paint(canvas, Offset(0, currentHeight));
      }
      currentHeight += textPainter.height;
    }

    // End recording and create a picture
    final picture = recorder.endRecording();

    // Convert the picture to an image
    final img = await picture.toImage(
      maxWidth.toInt(),
      totalHeight.toInt(),
    );

    // Convert the image to PNG bytes
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    // Return the bytes as a Uint8List
    return byteData?.buffer.asUint8List();
  }

  // Method to print the receipt
  void printReceipt({String? flag}) async {
    BluetoothDevice? device = _bluetoothPrinterService.connectedDevice;
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final generator = Generator(paper, profile);
    final List<int> bytes = [];
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    Uint8List imageBytes =
        await _bluetoothPrinterService.loadImageAsBytes('assets/Pertamina.png');

    Map<String, dynamic> content = {
      'header': '14201167',
      'spbuname': 'SPBU AH NASUTION/TRITURA',
      'jl': 'JL. AH NASUTION/TRITURA NO. 6A',
      'shift': 'Shift: 1     No. Trans: 5095616',
      'waktu': 'Waktu: 27/03/2025 07:39:03',
      'sepa1': '-----------------------------',
      'Pulau/Pompa': '2',
      'Nama Produk': 'PERTALITE',
      'Harga/Liter': 'Rp. 10,000',
      'Volume': '(L) 30.000',
      'Total Harga': 'Rp. 300,000',
      'Operator': 'ANDRI',
      'sepa2': '-----------------------------',
      'cash': 'CASH',
      'cashvalue': '300,000',
      'sepa3': '-----------------------------',
      'No. Plat': 'BK1606AEC',
      'sepa4': '-----------------------------',
      'ket':
          'Subsidi bulan November 2023: Bio\nsolar Rp 7,050/liter Dan Pertali\nte Rp 2,200/liter\nMari gunakan Pertamax series Dan\n  Dex series\nSubsidi hanya untuk yang berhak \nmenerimanya.'
    };

    final bytenya = await createTextImage(content);

    // textPainter.layout();
    // textPainter.paint(canvas, const Offset(0, 0));

    // final picture = recorder.endRecording();
    // final img = await picture.toImage(
    //     textPainter.width.toInt(), textPainter.height.toInt());
    // final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    // final bytenya = byteData?.buffer.asUint8List();

    if (bytenya != null) {
      // showGeneralDialog(
      //   context: context,
      //   barrierDismissible: true,
      //   barrierLabel: 'Close',
      //   transitionDuration: const Duration(milliseconds: 200),
      //   pageBuilder: (context, animation, secondaryAnimation) {
      //     return GestureDetector(
      //       onTap: () => Navigator.of(context).pop(),
      //       child: Material(
      //         color: Colors.white.withOpacity(0.9),
      //         child: Center(
      //           child: GestureDetector(
      //             onTap: () {}, // Prevent dismiss when tapping the image itself
      //             child: Image.memory(bytenya),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // );
      imgnya.Image? imageNya = imgnya.decodeImage(bytenya);
      _bluetoothPrinterService.printer.printImageBytes(imageBytes);
      bytes.addAll(generator.image(imageNya!));
      // bytes.addAll(generator.feed(2));
      // bytes.addAll(generator.cut());
      _bluetoothPrinterService.printer.writeBytes(Uint8List.fromList(bytes));
      // ui.decodeImageFromList(imageData, (ui.Image uiImg) {
      //   // Convert the ui.Image to an image package Image
      //   img.Image imagePackageImg = _convertUiImageToImagePackageImage(uiImg);
      // });
    }
  }
}
