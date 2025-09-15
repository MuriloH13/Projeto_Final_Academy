import 'package:flutter/material.dart';

import '../../domain/entities/trip.dart';
import '../../l10n/app_localizations.dart';

class DeleteTripDialog extends StatelessWidget {
  const DeleteTripDialog({super.key, required this.trip});

  final Trip trip;

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
                child: Text(AppLocalizations.of(context)!.tripDeleteMessage),
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
                    child: Text(AppLocalizations.of(context)!.generalYesButton),
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
