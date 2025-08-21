import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget dateFormField({
  required BuildContext context,
  required TextEditingController controller,
  required Locale locale,
  required String label,
}) {

  // Define the exhibition format based on the locale
  late DateFormat displayFormat;
  switch (locale.languageCode) {
    case 'en': // US
      displayFormat = DateFormat("MM/dd/yyyy");
      break;
    case 'es': // ES
      displayFormat = DateFormat("dd/MM/yyyy");
      break;
    case 'pt': // BR
    default:
      displayFormat = DateFormat("dd/MM/yyyy");
  }

  // Try parsing the actual data of the controller
  DateTime initialDate = DateTime.now();
  if (controller.text.isNotEmpty) {
    final parsed = tryParseDate(controller.text);
    if (parsed != null) {
      initialDate = parsed;
      // Formats accordingly to the locale
      controller.text = displayFormat.format(parsed);
    }
  }
  return Expanded(
      child: TextFormField(
        controller:  controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)
      ),
    ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            // Turn the starting date to today at the time that you click
            initialDate: initialDate,
            // Turn the minimum date to today at the time that you click
            firstDate: DateTime.now(),
            // Turn the maximum date to a specific year(can be changed based on app specifications)
            lastDate: DateTime(2050),
            // Receive the app locale to specific data format
            locale: locale,
          );
          if(picked != null) {
            controller.text = displayFormat.format(picked);
          }
        },
      ),
  );
}

DateTime? tryParseDate(String input) {
  final formats = [
    DateFormat("dd/MM/yyyy"), // BR/ES
    DateFormat("MM/dd/yyyy"), // US
    DateFormat("yyyy-MM-dd"), // ISO
  ];

  for (var format in formats) {
    try {
      return format.parseStrict(input.split(' ').first);
    } catch (_) {}
  }

  try {
    return DateTime.parse(input);
  } catch (_) {}

  return null;
}