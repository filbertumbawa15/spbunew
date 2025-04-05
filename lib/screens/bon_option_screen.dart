import 'package:bon/screens/58mm/pertamina_form_screen.dart';
import 'package:bon/screens/58mm/pertamina_form_screen_custom.dart';
import 'package:flutter/material.dart';

class BonOptionsScreen extends StatelessWidget {
  final String printerSize;
  final List<String> bonOptions = [
    'Pertamina BON Format 1 (Font Bawaan Printer)',
    'Pertamina BON Format 2 (Font Droid Sans)'
  ];

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
            ...bonOptions.map(
              (bon) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 5, // How much the shadow spreads
                          blurRadius: 10, // How blurry the shadow is
                          offset: const Offset(
                              0, 4), // Position of the shadow (x, y)
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(bon),
                      onTap: () {
                        if (bon ==
                            'Pertamina BON Format 1 (Font Bawaan Printer)') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PertaminaFormScreen(),
                            ),
                          );
                        } else if (bon ==
                            'Pertamina BON Format 2 (Font Droid Sans)') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PertaminaFormScreenCustom(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$bon selected')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
