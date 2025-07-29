import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'language_provider.dart';
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    final currentLocale = provider.locale;
    final theme = Theme.of(context);

    final languageOptions = {
      'en': '🇺🇸 English',
      'pt': '🇧🇷 Português',
      'es': '🇪🇸 Español',
    };

    return DropdownButton<String>(
      value: currentLocale.languageCode,
      underline: const SizedBox(),
      borderRadius: BorderRadius.circular(12),
      style: const TextStyle(fontSize: 16, color: Colors.black),
      dropdownColor: Theme.of(context).cardColor,
      onChanged: (String? newLangCode) {
        if (newLangCode != null) {
          provider.setLocale(Locale(newLangCode));
        }
      },
      items: languageOptions.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(
            entry.value,
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
          ),
          ),
        );
      }).toList(),
    );
  }
}