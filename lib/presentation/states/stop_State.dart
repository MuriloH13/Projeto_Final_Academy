import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:projeto_final_academy/domain/entities/stop.dart';
import 'package:projeto_final_academy/presentation/controllers/geolocator_Controller.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/data/tables/stop_Table.dart';
import '../utils/stop_Details.dart';

class StopState extends ChangeNotifier {
  StopState() {
    load();
  }
  List<dynamic> placeList = [];
  String? name;
  String? address;
  String? photo;
  double? latitude;
  double? longitude;
  DateTime? departure;
  DateTime? arrival;
  final controllerDatabase = StopController();
  final _citiesList = <Stop>[];

  List<Stop> get citiesList => _citiesList;

  final String _apiKey = dotenv.env['ANDROID_MAPS_APIKEY'] ?? '';
  Uuid _sessionToken = new Uuid();

  void updatePlaceList(List<dynamic> newList) {
    placeList = newList;
    notifyListeners();
  }

  void setStopDetails({
    required String name,
    required String address,
    required String photo,
    required double latitude,
    required double longitude,
  }) {
    this.name = name;
    this.address = address;
    this.photo = photo;
    this.latitude = latitude;
    this.longitude = longitude;
    notifyListeners();
  }

  void setStopDates({
    required DateTime departure,
    required DateTime arrival,
}) {
    this.departure = departure;
    this.arrival = arrival;
    notifyListeners();
  }

  Stop toStop(int tripId) {
    return Stop(
      name: name!,
      address: address!,
      photo: photo ?? '',
      latitude: latitude!,
      longitude: longitude!,
      tripId: tripId,
    );
  }

  void clear() {
    placeList = [];
    name = null;
    address = null;
    photo = null;
    latitude = null;
    longitude = null;
    notifyListeners();
  }

  Future<void> insert(int tripId) async {
    final stop = Stop(
      name: name!,
      address: address!,
      latitude: latitude!,
      longitude: longitude!,
      departure: departure!,
      arrival: arrival!,
      photo: photo ?? '',
      tripId: tripId,
    );
    await controllerDatabase.insert(stop);
    clear(); // Clean the data after the insert
  }

  Future<void> load() async {
    final list = await controllerDatabase.select();
    _citiesList
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  Future<void> fetchSuggestions(String input) async {
    final baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final request = '$baseURL?input=$input&key=$_apiKey&sessiontoken=$_sessionToken';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final predictions = json.decode(response.body)['predictions'];
      updatePlaceList(predictions);
    } else {
      throw Exception('Falha ao buscar sugestões');
    }
  }

  /// Search for details about the selected city
  Future<void> fetchPlaceDetails({
    required String placeId,
    required BuildContext context,
    required int stopId,
  }) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,geometry,formatted_address,photos&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    final jsonBody = jsonDecode(response.body);

    if (jsonBody['status'] == 'OK') {
      final result = jsonBody['result'];
      final name = result['name'];
      final address = result['formatted_address'];
      final location = result['geometry']['location'];
      final lat = location['lat'];
      final long = location['lng'];

      String photoUrl = '';
      if (result['photos'] != null && result['photos'].isNotEmpty) {
        final photoReference = result['photos'][0]['photo_reference'];
        photoUrl =
        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=$photoReference&key=$_apiKey';
      }

      setStopDetails(
        name: name,
        address: address,
        photo: photoUrl,
        latitude: lat,
        longitude: long,
      );

      context.read<MapsController>().updatePosition(lat, long);

      showModalBottomSheet(
        context: context,
        builder: (_) => StopDetails(stop: toStop(stopId), stopId: stopId),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      );
    } else {
      throw Exception('Dados de localização não encontrados na resposta da API.');
    }
  }
}