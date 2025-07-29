import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/controllers/geolocator_Controller.dart';
import 'package:projeto_final_academy/presentation/providers/language_provider.dart';
import 'package:projeto_final_academy/presentation/states/group_State.dart';
import 'package:projeto_final_academy/presentation/states/participant_State.dart';
import 'package:projeto_final_academy/presentation/states/transport_State.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_Routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

import 'l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GroupState()),
        ChangeNotifierProvider(create: (context) => TransportState()),
        ChangeNotifierProvider(create: (context) => ParticipantState()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => GeolocatorController()), // no context here),
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