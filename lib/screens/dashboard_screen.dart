import 'package:bon/screens/bon_option_screen.dart';
import 'package:bon/screens/print_selection_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/printer_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedSize;
  bool isConnected = false;

  List<String> bonOptions = ['Pertamina BON', 'Railway BON', 'Cafe BON'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Printer Size')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrinterCard(
                label: '58mm',
                onTap: () {
                  // Navigate to the BON options screen and pass the selected printer size
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BonOptionsScreen(printerSize: '58mm'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              PrinterCard(
                label: '80mm',
                onTap: () => setState(() => selectedSize = '80mm'),
              ),
              const SizedBox(height: 20),
              PrinterCard(
                label: 'Connect Printer',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrinterSelectionScreen(),
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}
