import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePreviewDialog extends StatelessWidget {
  final List<int> receiptBytes; // Menerima data gambar dalam bentuk List<int>

  const ImagePreviewDialog({super.key, required this.receiptBytes});

  @override
  Widget build(BuildContext context) {
    print(receiptBytes);
    return AlertDialog(
      title: const Text("Preview Receipt"),
      content: SingleChildScrollView(
        child: Image.memory(
            Uint8List.fromList(receiptBytes)), // Menampilkan gambar
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Menutup dialog
          },
          child: const Text("Tutup"),
        ),
      ],
    );
  }
}
