import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projeto_final_academy/l10n/app_localizations.dart';

class GeolocatorController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String error = '';

  GeolocatorController();

  Future<void> getPosition(BuildContext context) async {
    try {
      Position position = await _actualPosition(context);
      lat = position.latitude;
      long = position.longitude;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<Position> _actualPosition(BuildContext context) async {
    LocationPermission permission;
    bool activated = await Geolocator.isLocationServiceEnabled();

    if (!activated) {
      return Future.error(AppLocalizations.of(context)!.locationDisabledLocationMessage);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error(AppLocalizations.of(context)!.locationDisabledLocationMessage);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(AppLocalizations.of(context)!.tripPlannerParticipantName);
    }

    return await Geolocator.getCurrentPosition();
  }
}