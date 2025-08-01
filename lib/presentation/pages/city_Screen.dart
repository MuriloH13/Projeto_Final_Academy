import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/geolocator_Controller.dart';

final citiesKey = GlobalKey();

class CityScreen extends StatelessWidget {
  const CityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _apiKey = dotenv.env['ANDROID_MAPS_APIKEY'] ?? '';
    WidgetsFlutterBinding.ensureInitialized();

    return Scaffold(
      key: citiesKey,
      appBar: AppBar(
        title: Text('Stops'),
      ),
      body: ChangeNotifierProvider<MapsController>(
        create: (context) => MapsController(),
        child: Builder(builder: (context) {
          final local = context.watch<MapsController>();
          
          return GoogleMap(initialCameraPosition: CameraPosition(
            target: LatLng(local.lat, local.long),
            zoom: 13,
          ),
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            onMapCreated: local.onMapCreated,
            markers: local.markers,
          );
        }),
      )
    );
  }
}
