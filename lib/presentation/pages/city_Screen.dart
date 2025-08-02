import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_final_academy/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../controllers/geolocator_Controller.dart';
import 'package:http/http.dart';

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
      _onChanged;
    });
  }

  void _onChanged() {
    if(_sessionToken == null) {
      setState(() {
        _sessionToken == uuid.v4();
      });
    }
    getLocationResults(_controller.text);
  }

  void getLocationResults(String input) async {
    String _apiKey = dotenv.env['ANDROID_MAPS_APIKEY'] ?? '';
    String type = '(regions)';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$_apiKey&sessiontoken=$_sessionToken';
    var response = await http.get(request as Uri);
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
    WidgetsFlutterBinding.ensureInitialized();

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
              // autofillHints: _placeList,
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
              return ListTile(
                title: Text(_placeList[index]["formatted_address"]),
              );
            },
          ),
          ChangeNotifierProvider<MapsController>(
            create: (context) => MapsController(),
            child: Builder(builder: (context) {
              final local = context.watch<MapsController>();

              return Flexible(
                flex: 10,
                child: GoogleMap(initialCameraPosition: CameraPosition(
                  target: LatLng(local.lat, local.long),
                  zoom: 13,
                ),
                  zoomControlsEnabled: true,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (context) => local.onMapCreated,
                  // markers: local.markers,
                ),
              );
            }),
          ),
        ],
      )
    );
  }
}


