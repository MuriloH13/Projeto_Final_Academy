import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget dateFormField({
  required BuildContext context,
  required ValueNotifier<DateTime?>  controller,
  required Locale locale,
  required String label,
}) {

  // Define the exhibition format based on the locale
  late DateFormat displayFormat;
  switch (locale.languageCode) {
    case 'pt': // BR
    case 'es': // ES
      displayFormat = DateFormat("dd/MM/yyyy");
      break;
    case 'en': // US
    default:
      displayFormat = DateFormat("MM/dd/yyyy");
      break;
  }

  return Expanded(
      child: ValueListenableBuilder<DateTime?>(
        valueListenable: controller,
        builder: (context, value, _)
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)
          ),
        ),
        controller: TextEditingController(
          text: value != null ? displayFormat.format(value) : '',
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            // Turn the starting date to today at the time that you click
            initialDate: value ?? DateTime.now(),
            // Turn the minimum date to today at the time that you click
            firstDate: DateTime(2000),
            // Turn the maximum date to a specific year(can be changed based on app specifications)
            lastDate: DateTime(2050),
            // Receive the app locale to specific data format
            locale: locale,
          );
          if (picked != null) {
            controller.value = picked;
          }
        },
      ),
    );
}
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