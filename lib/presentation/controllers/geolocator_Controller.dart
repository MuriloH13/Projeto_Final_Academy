import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_final_academy/domain/repositories/cities_Repository.dart';
import 'package:projeto_final_academy/presentation/pages/city_Screen.dart';

import '../../l10n/app_localizations.dart';
import '../utils/city_Details.dart';

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
    _mapsController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long))));
    loadCities();
  }

  loadCities() {
    final cities = CitiesRepository().cities;
    cities.forEach((city) {
      markers.add(
        Marker(
          markerId: MarkerId(city.name),
          position: LatLng(city.latitude, city.longitude),
          onTap: () {
            showModalBottomSheet(
              context: citiesKey.currentState!.context,
              builder: (context) => CityDetails(city: city, groupId: city.groupId),
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
            return Dialog(
              child: SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(hasPosition ?? 'ççç'),
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
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                             await Geolocator.openLocationSettings();
                             Navigator.of(context).pop(true);

                            },
                            child: Text('Ok'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
         (position, hasPosition) = await _actualPosition(context);
      }


      print('ÇÇÇÇÇÇ788787');
      print(position?.latitude);
      print(position?.longitude);

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

    print('LLLÇÇÇÇÇÇ0001');
    print(permission);

    if (permission == LocationPermission.denied) {
      print('LLLÇÇÇÇÇÇ0002');
      permission = await Geolocator.requestPermission();
      print('LLLÇÇÇÇÇÇ0003');
      print(permission);

      if (permission == LocationPermission.deniedForever) {
        return (
          null,
          AppLocalizations.of(context)!.locationDisabledLocationMessage,
        );
      }
    }

    if (permission == LocationPermission.unableToDetermine) {
      print('LLLÇÇÇÇÇÇ0002');
      permission = await Geolocator.requestPermission();
      print('LLLÇÇÇÇÇÇ0003');
      print(permission);

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
