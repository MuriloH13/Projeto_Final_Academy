import 'package:flutter/material.dart';

import '../../core/routes/app_Routes.dart';
import '../../l10n/app_localizations.dart';

class EditTripDialog extends StatelessWidget {
  const EditTripDialog({super.key, required this.tripId});

  final int tripId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 150,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(AppLocalizations.of(context)!.tripEditMessage),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.generalCancelButton,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Sim'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
