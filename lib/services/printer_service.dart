import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class PrinterService {
  final String macAddress = "86:67:7A:B5:A1:12";
  final flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? writeCharacteristic;

  /// Scan, connect, and print a receipt
  Future<void> connectAndPrint() async {
    try {
      await _scanAndConnect();
      if (writeCharacteristic != null) {
        await _printReceipt();
      } else {
        print("Write characteristic not found!");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  /// Scan for Bluetooth devices and connect to the target printer
  Future<void> _scanAndConnect() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    await Future.delayed(const Duration(seconds: 5));

    final a = await FlutterBluePlus.scanResults;

    print(a);

    for (ScanResult result in await FlutterBluePlus.scanResults.first) {
      if (result.device.remoteId.str == macAddress) {
        targetDevice = result.device;
        break;
      }
    }

    FlutterBluePlus.stopScan();

    if (targetDevice == null) {
      print("Printer not found!");
      return;
    }

    await targetDevice!.connect();
    List<BluetoothService> services = await targetDevice!.discoverServices();

    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          writeCharacteristic = characteristic;
          break;
        }
      }
    }
  }

  /// Generate ESC/POS commands and print a receipt
  Future<void> _printReceipt() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.text('RECEIPT',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text('----------------------');
    bytes += generator.text('Item 1     \$5.00');
    bytes += generator.text('Item 2     \$3.00');
    bytes += generator.text('Total:     \$8.00', styles: PosStyles(bold: true));
    bytes += generator.feed(2);
    bytes += generator.qrcode('https://example.com');
    bytes += generator.feed(2);
    bytes += generator.cut();

    await writeCharacteristic!.write(Uint8List.fromList(bytes));
    print("Printing done!");
  }

  //   Uint8List? imageData = await _generateImageFromText("Hello In Consolas");
  // if (imageData != null) {
  //   img.Image? imageNya = img.decodeImage(imageData);
  //   bytes.addAll(generator.image(imageNya!));
  //   bytes.addAll(generator.feed(2));
  //   bytes.addAll(generator.cut());
  //   _bluetoothPrinterService.printer.writeBytes(Uint8List.fromList(bytes));
  //   // ui.decodeImageFromList(imageData, (ui.Image uiImg) {
  //   //   // Convert the ui.Image to an image package Image
  //   //   img.Image imagePackageImg = _convertUiImageToImagePackageImage(uiImg);
  //   // });
  // }

  // It can be connected by using Flutter Blue Thermal Printer package
}
