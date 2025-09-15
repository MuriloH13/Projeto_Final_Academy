import 'package:flutter/material.dart';
import 'package:projeto_final_academy/domain/entities/stop.dart';
import 'package:projeto_final_academy/l10n/app_localizations.dart';
import 'package:projeto_final_academy/presentation/providers/language_provider.dart';
import 'package:projeto_final_academy/presentation/states/stop_State.dart';
import 'package:projeto_final_academy/presentation/utils/date_FormField.dart';
import 'package:provider/provider.dart';

class StopDetails extends StatelessWidget {
  final Stop stop;
  final int stopId;
  final controllerStopDepartureDate = ValueNotifier<DateTime?>(null);
  final controllerStopArrivalDate = ValueNotifier<DateTime?>(null);

  StopDetails({super.key, required this.stop, required this.stopId});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    return ChangeNotifierProvider(
      create: (_) => StopState(),
      builder: (context, child) {
        return Consumer<StopState>(
          builder: (context, state, child) {
            return Container(
              child: Wrap(
                children: [
                  stop.photo!.isNotEmpty
                      ? Image.network(
                          stop.photo!,
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/notAvailable.jpg',
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                  Padding(
                    padding: EdgeInsets.only(top: 24, left: 24),
                    child: Text(stop.name),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 60, left: 24),
                    child: Text(stop.address),
                  ),
                  Row(
                    children: [
                      dateFormField(
                        context: context,
                        controller: controllerStopDepartureDate,
                        locale: languageProvider.locale,
                        label: AppLocalizations.of(context)!.tripDepartureDate,
                      ),
                      dateFormField(
                        context: context,
                        controller: controllerStopArrivalDate,
                        locale: languageProvider.locale,
                        label: AppLocalizations.of(context)!.tripArrivalDate,
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          final departure = controllerStopDepartureDate.value;
                          final arrival = controllerStopArrivalDate.value;

                          if (departure != null && arrival != null) {
                            final stopToInsert = Stop(
                              name: stop.name,
                              address: stop.address,
                              latitude: stop.latitude,
                              longitude: stop.longitude,
                              departure: departure,
                              arrival: arrival,
                              photo: stop.photo,
                              tripId: stopId,
                            );

                            await state.insert(stopToInsert);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Selecione datas válidas'),
                              ),
                            );
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.stopAddDestination),
                      )
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
