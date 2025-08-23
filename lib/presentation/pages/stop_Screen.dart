import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_final_academy/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../controllers/geolocator_Controller.dart';

import '../states/stop_State.dart';

final citiesKey = GlobalKey();


class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {


  @override
  Widget build(BuildContext context) {
    final int tripId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      key: citiesKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.stopScreenTitle),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 40,
              child: TextFormField(
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    context.read<StopState>().fetchSuggestions(value);
                  } else {
                    context.read<StopState>().clear();
                  }
                },
              autocorrect: false,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchBar,
                prefixIcon: Icon(Icons.map),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              ),
            ),
          ),
          Consumer<StopState>(
            builder: (context, state, _) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.placeList.length,
                itemBuilder: (context, index) {
                  final place = state.placeList[index];
                  return ListTile(
                    title: Text(state.placeList[index]['description']),
                    onTap: () {
                      state.fetchPlaceDetails(placeId: place['place_id'],
                        context: context,
                        stopId: tripId,
                      );
                    },
                  );
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
                onTap: (markers){
                },
              ),
            );
          }),
        ],
      )
    );
  }
}