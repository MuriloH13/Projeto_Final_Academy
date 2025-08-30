import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../l10n/app_localizations.dart';

Widget LocalizationPermissionDialog({
  required BuildContext context,
}) {
  return Dialog(
    child: SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.locationNeedAccessMessage),
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.generalCancelButton),
                ),
                TextButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                    Navigator.of(context).pop(true);

                  },
                  child: Text(AppLocalizations.of(context)!.generalConfirmButton),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}