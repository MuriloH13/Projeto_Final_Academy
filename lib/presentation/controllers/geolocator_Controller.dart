import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:projeto_final_academy/domain/repositories/stops_Repository.dart';
import 'package:projeto_final_academy/presentation/pages/stop_Screen.dart';
import 'package:projeto_final_academy/presentation/utils/localizationPermission_Dialog.dart';
import '../utils/stop_Details.dart';
import '../../l10n/app_localizations.dart';

class MapsController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String error = '';
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  bool _isMapReady = true;
  Set<Marker> markers = <Marker>{};
  GoogleMapController? _mapsController;

  get mapsController => _mapsController;

  // 🔹 Called when GoogleMap is created
  Future<void> onMapCreated(BuildContext context, GoogleMapController controller) async {
    _mapsController = controller;
    if (!_controllerCompleter.isCompleted) _controllerCompleter.complete(controller);
    await getPosition(context);
    _mapsController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 15),
      ),
    );
    loadCities();
  }

  // 🔹 Load all stops as markers on the map
  void loadCities() {
    final stops = StopsRepository().cities;
    markers.clear();
    for (final stop in stops) {
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
    }
    notifyListeners();
  }

  // 🔹 Update map camera to a new position
  void updatePosition(double newLat, double newLong) {
    lat = newLat;
    long = newLong;

    markers = {
      Marker(markerId: MarkerId("selected-location"), position: LatLng(lat, long))
    };
    if (_isMapReady && _mapsController != null) {
      _mapsController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, long), 15),
      );
    }
    loadCities();
    notifyListeners();
  }

  // 🔹 Get current device position
  Future<void> getPosition(BuildContext context) async {
    try {
      Position? position;
      String? hasPosition;
      (position, hasPosition) = await _actualPosition(context);

      if (position == null) {
        await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (context) => LocalizationPermissionDialog(context: context),
        );
        (position, hasPosition) = await _actualPosition(context);
      }

      if (position != null) {
        lat = position.latitude;
        long = position.longitude;
        _mapsController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
      }
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<(Position?, String?)> _actualPosition(BuildContext context) async {
    final permission = await Geolocator.checkPermission();
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return (null, AppLocalizations.of(context)!.locationDisabledLocationMessage);
    }

    LocationPermission updatedPermission = permission;
    if (permission == LocationPermission.denied || permission == LocationPermission.unableToDetermine) {
      updatedPermission = await Geolocator.requestPermission();
    }

    if (updatedPermission == LocationPermission.deniedForever) {
      return (null, AppLocalizations.of(context)!.locationNeedAccessMessage);
    }

    if (updatedPermission == LocationPermission.denied) {
      return (null, AppLocalizations.of(context)!.locationDisabledLocationMessage);
    }

    final pos = await Geolocator.getCurrentPosition();
    return (pos, null);
  }

  // 🔹 Generate a static map image using Google Maps Static API
  Future<File> generateStaticMapImage(List<LatLng> stops, String fileName) async {
    if (stops.isEmpty) throw Exception("No stops provided to generate the map");

    final apiKey = "SUA_CHAVE_API"; // Replace with your valid API key
    final markersParam = stops
        .map((stop) => "markers=color:red%7Clabel:%7C${stop.latitude},${stop.longitude}")
        .join("&");
    final pathParam = "path=color:0x0000ff|weight:4|" +
        stops.map((stop) => "${stop.latitude},${stop.longitude}").join("|");

    final url = "https://maps.googleapis.com/maps/api/staticmap?size=800x600&$markersParam&$pathParam&key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Failed to generate static map: ${response.body}");
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/$fileName.png");
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  // 🔹 Wait until the map controller is ready
  Future<void> waitMapReady() async {
    if (_mapsController == null) {
      _mapsController = await _controllerCompleter.future;
    }
  }

  // 🔹 Generate a snapshot of the current map (markers + camera)
  Future<File> takeMapSnapshot(String fileName) async {
    await waitMapReady();

    if (_mapsController == null) {
      throw Exception("GoogleMapController not initialized");
    }

    final bitmap = await _mapsController!.takeSnapshot();

    if (bitmap == null) {
      throw Exception("Failed to capture map snapshot");
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.png');
    await file.writeAsBytes(bitmap);

    return file;
  }
}
