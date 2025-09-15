import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_Routes.dart';
import '../../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../states/trip_State.dart';
import '../utils/date_FormField.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();

    return ChangeNotifierProvider(
      create: (_) => TripState()..load(),
      child: Consumer<TripState>(
        builder: (context, state, child) {
          if(state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.tripScreenTitle),
          ),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: state.controllerGroupName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: AppLocalizations.of(context)!.tripName,
                        prefixIcon: Icon(Icons.archive),
                      ),
                    ),
                    Row(
                      children: [
                        dateFormField(
                          context: context,
                          controller: state.controllerTripDepartureDate,
                          locale: languageProvider.locale,
                          label: AppLocalizations.of(context)!.tripDepartureDate,
                        ),
                        dateFormField(
                          context: context,
                          controller: state.controllerTripArrivalDate,
                          locale: languageProvider.locale,
                          label: AppLocalizations.of(context)!.tripArrivalDate,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {

                    final arrivalDate = state.controllerTripArrivalDate.value;
                    if (arrivalDate == null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.invalidDate)));
                      return;
                    }

                    final now = DateTime.now();
                    final int isFuture = arrivalDate.isAfter(now) ? 1 : 0;
                    state.groupStatus = isFuture;
                    final groupId = await state.insert();


                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.participantScreen,
                      arguments: groupId,
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.generalConfirmButton),
                ),
              ),
            ],
          ),
        );
          }
      ),
    );
  }
}
