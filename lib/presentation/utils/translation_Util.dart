import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class TranslationUtil {
  static String translate(BuildContext context, String key) {
    final loc = AppLocalizations.of(context)!;
    switch (key) {
      case "Car": return loc.transportCar;
      case "Motorcycle": return loc.transportMotorcycle;
      case "Bus": return loc.transportBus;
      case "Airplane": return loc.transportAirPlane;
      case "Cruise": return loc.transportCruise;
      case "Immersion in a different culture": return loc.experienceCulturalImmersion;
      case "Explore alternative cuisine": return loc.experienceAlternativeCuisine;
      case "Historical sites tour": return loc.experienceHistoricalSites;
      case "Visit local establishments": return loc.experienceLocalEstablishments;
      case "Contact with nature": return loc.experienceContactWithNature;
      default: return key;
    }
  }
  static String translateDropDownMenu(BuildContext context, String key) {
    final loc = AppLocalizations.of(context)!;

    // Use the .arb
    switch (key) {
    // Transports cases
      case 'Car':
        return loc.transportCar;
      case 'Bus':
        return loc.transportBus;
      case 'Airplane':
        return loc.transportAirPlane;
      case 'Motorcycle':
        return loc.transportMotorcycle;
      case 'Cruise':
        return loc.transportCruise;

    // Experiences cases
      case 'Immersion in a different culture':
        return loc.experienceCulturalImmersion;
      case 'Explore alternative cuisine':
        return loc.experienceAlternativeCuisine;
      case 'Historical sites tour':
        return loc.experienceHistoricalSites;
      case 'Visit local establishments':
        return loc.experienceLocalEstablishments;
      case 'Contact with nature':
        return loc.experienceContactWithNature;

      default:
        return key; // fallback if case do not have arb
    }
  }
}