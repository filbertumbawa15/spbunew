import 'package:bon/screens/58mm/pertamina_form_screen.dart';
import 'package:flutter/material.dart';

class BonOptionsScreen extends StatelessWidget {
  final String printerSize;
  final List<String> bonOptions = ['Pertamina BON', 'Railway BON', 'Cafe BON'];

  BonOptionsScreen({super.key, required this.printerSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$printerSize Printer Selected'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Select a BON to print with the $printerSize printer:',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ...bonOptions.map((bon) => ListTile(
                  title: Text(bon),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    if (bon == 'Pertamina BON') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PertaminaFormScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$bon selected')),
                      );
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
