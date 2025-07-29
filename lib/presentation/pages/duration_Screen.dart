import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class DurationScreen extends StatelessWidget {
  const DurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.durationScreenTitle)),
      body: Column(
          children: [
          ]
      ),
    );
  }
}
