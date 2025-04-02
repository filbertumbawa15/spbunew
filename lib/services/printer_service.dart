import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class PrinterService {
  Future<void> printReceipt(String printerSize) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final connection = await printer.connect('Your Printer IP');
    if (connection == PosPrintResult.success) {
      if (printerSize == '58mm') {
        printer.setStyles(
            const PosStyles(align: PosAlign.left, height: PosTextSize.size2));
      } else {
        printer.setStyles(
            const PosStyles(align: PosAlign.center, height: PosTextSize.size3));
      }

      printer.text('This is a test receipt!');
      printer.cut();
      printer.disconnect();
    }
  }
}
