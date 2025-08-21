import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/controllers/geolocator_Controller.dart';
import 'package:projeto_final_academy/presentation/providers/language_provider.dart';
import 'package:projeto_final_academy/presentation/states/stop_State.dart';
import 'package:projeto_final_academy/presentation/states/experience_State.dart';
import 'package:projeto_final_academy/presentation/states/trip_State.dart';
import 'package:projeto_final_academy/presentation/states/participant_State.dart';
import 'package:projeto_final_academy/presentation/states/transport_State.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/routes/app_Routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TripState()),
        ChangeNotifierProvider(create: (context) => ParticipantState()),
        ChangeNotifierProvider(create: (context) => TransportState()),
        ChangeNotifierProvider(create: (context) => ExperienceState()),
        ChangeNotifierProvider(create: (context) => StopState()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => MapsController()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return MaterialApp(
      locale: languageProvider.locale,
      supportedLocales: context.read<LanguageProvider>().supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: AppLocalizations.of(context)!.tripPlannerScreenTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      initialRoute: AppRoutes.homeScreen,
      routes: AppRoutes.routes,
    );
  }
}