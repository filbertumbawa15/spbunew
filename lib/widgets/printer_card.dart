import 'package:flutter/material.dart';

class PrinterCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const PrinterCard({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
