import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_final_academy/domain/repositories/cities_Repository.dart';
import 'package:projeto_final_academy/presentation/pages/city_Screen.dart';

import '../widgets/city_Details.dart';

class MapsController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String error = '';
  Set <Marker> markers = Set<Marker>();

  late GoogleMapController _mapsController;

  get mapsController => _mapsController;

  onMapCreated(GoogleMapController googleMapController) async {
     _mapsController = googleMapController;
     getPosition();
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
            showModalBottomSheet(context: citiesKey.currentState!.context, builder: (context) => CityDetails(city: city),);
          },
      ),
      );
    });
    notifyListeners();
  }

  void getPosition() async {
    try {
      Position position = await _actualPosition();
      lat = position.latitude;
      long = position.longitude;
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<Position> _actualPosition() async {
    LocationPermission permission;
    bool activated = await Geolocator.isLocationServiceEnabled();

    if (!activated) {
      return Future.error("Localization disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Localization permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("You need to activate the localization");
    }

    return await Geolocator.getCurrentPosition();
  }
}