import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_final_academy/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/city.dart';
import '../controllers/geolocator_Controller.dart';
import 'package:http/http.dart';

import '../utils/city_Details.dart';

final citiesKey = GlobalKey();


class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  var _controller = TextEditingController();
  var uuid = new Uuid();
  Uuid _sessionToken = new Uuid();
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  void _onChanged() {
    if(_sessionToken == null) {
      setState(() {
        _sessionToken = Uuid();
      });
    }
    getLocationResults(_controller.text);
  }

  Future<void> getPlaceDetails(String placeId) async {
    final String apiKey = dotenv.env['ANDROID_MAPS_APIKEY'] ?? '';
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,geometry,formatted_address,photos&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    if (json['status'] == 'OK') {
      final result = json['result'];
      final name = result['name'];
      final address = result['formatted_address'];
      final location = result['geometry']['location'];
      final lat = location['lat'];
      final long = location['lng'];

      String photoUrl = '';
      if (result['photos'] != null && result['photos'].isNotEmpty) {
        final photoReference = result['photos'][0]['photo_reference'];
        photoUrl =
        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=$photoReference&key=$apiKey';
      }

      context.read<MapsController>().updatePosition(lat, long);

      final selectedCity = City(
        name: name,
        address: address,
        photo: photoUrl,
        latitude: lat,
        longitude: long,
      );

      showModalBottomSheet(
        context: context,
        builder: (_) => CityDetails(city: selectedCity),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      );
    } else {
      throw Exception('Dados de localização não encontrados na resposta da API.');
    }
  }

  Future<void> getLocationResults(String input) async {
    String apiKey = dotenv.env['ANDROID_MAPS_APIKEY'] ?? '';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$apiKey&sessiontoken=$_sessionToken';

    final uri = Uri.parse(request);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: citiesKey,
      appBar: AppBar(
        title: Text('Stops'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 40,
              child: TextFormField(
                controller: _controller,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    getLocationResults(value);
                  } else {
                    setState(() {
                      _placeList = [];
                    });
                  }
                },
              autocorrect: false,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.tripPlannerSearchBar,
                prefixIcon: Icon(Icons.map),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              ),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _placeList.length,
            itemBuilder: (context, index) {
              final place = _placeList[index];
              return ListTile(
                title: Text(_placeList[index]['description']),
                onTap: () {
                  getPlaceDetails(place['place_id']);
                },
              );
            },
          ),
          Builder(builder: (context) {
            final local = context.watch<MapsController>();

            return Flexible(
              flex: 10,
              child: GoogleMap(initialCameraPosition: CameraPosition(
                target: LatLng(local.lat, local.long),
                zoom: 15,
              ),
                zoomControlsEnabled: true,
                myLocationEnabled: true,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  local.onMapCreated(context, controller);
                },
                markers: local.markers,
              ),
            );
          }),
        ],
      )
    );
  }
}


