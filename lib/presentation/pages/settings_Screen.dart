import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../../l10n/app_localizations.dart';
import '../providers/language_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appShellSettingsText),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.settingsThemeSwitchText),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.settingsDarkModeSwitch),
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Text(AppLocalizations.of(context)!.settingsLanguageSelection),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: LanguageSelector(),
            ),
            Text(AppLocalizations.of(context)!.appShellSettingsText),
          ],
        ),
      ),
    );
  }
}