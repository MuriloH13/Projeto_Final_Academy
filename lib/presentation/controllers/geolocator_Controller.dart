import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_final_academy/domain/repositories/stops_Repository.dart';
import 'package:projeto_final_academy/presentation/pages/stop_Screen.dart';
import 'package:projeto_final_academy/presentation/utils/localizationPermission_Dialog.dart';

import '../../l10n/app_localizations.dart';
import '../utils/stop_Details.dart';

class MapsController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String error = '';
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  bool _isMapReady = true;
  Set<Marker> markers = Set<Marker>();

  GoogleMapController? _mapsController;

  get mapsController => _mapsController;

  onMapCreated(
    BuildContext context,
    GoogleMapController googleMapController,
  ) async {
    _mapsController = googleMapController;
    _controllerCompleter.complete(googleMapController);
    await getPosition(context);
    _mapsController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15)));
    loadCities();
  }

  loadCities() {
    final stops = StopsRepository().cities;
    stops.forEach((stop) {
      markers.add(
        Marker(
          markerId: MarkerId(stop.name),
          position: LatLng(stop.latitude, stop.longitude),
          onTap: () {
            showModalBottomSheet(
              context: citiesKey.currentState!.context,
              builder: (context) => StopDetails(stop: stop, stopId: stop.tripId),
            );
          },
        ),
      );
    });
    notifyListeners();
  }

  void updatePosition(double newLat, double newLong) {
    lat = newLat;
    long = newLong;

    markers = {
      Marker(
        markerId: MarkerId("selected-location"),
        position: LatLng(lat, long),
      )
    };
    if (_isMapReady && _mapsController != null) {
      _mapsController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, long), 15),
      );
    }
    loadCities();
    notifyListeners();
  }

  Future<void> getPosition(BuildContext context) async {
    try {
      Position? position;
      String? hasPosition;

      (position, hasPosition) = await _actualPosition(context);

      if (position == null) {
         await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return LocalizationPermissionDialog(context: context);
          },
        );
         (position, hasPosition) = await _actualPosition(context);
      }



      lat = position!.latitude;
      long = position.longitude;
      _mapsController!.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<(Position?, String?)> _actualPosition(BuildContext context) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    bool activated = await Geolocator.isLocationServiceEnabled();


    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        return (
          null,
          AppLocalizations.of(context)!.locationDisabledLocationMessage,
        );
      }
    }

    if (permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        return (
          null,
          AppLocalizations.of(context)!.locationDisabledLocationMessage,
        );
      }
    }

    if (!activated) {
      return Future.error(
        AppLocalizations.of(context)!.locationDisabledLocationMessage,
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error(
          AppLocalizations.of(context)!.locationDisabledLocationMessage,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        AppLocalizations.of(context)!.locationNeedAccessMessage,
      );
    }

    return (await Geolocator.getCurrentPosition(), null);
  }
}
