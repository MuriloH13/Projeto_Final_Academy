import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/controllers/geolocator_Controller.dart';
import 'package:projeto_final_academy/presentation/providers/language_provider.dart';
import 'package:projeto_final_academy/presentation/states/trip_State.dart';
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),

        ChangeNotifierProvider(create: (_) => TripState()),

        ChangeNotifierProvider(create: (_) => MapsController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Provider.of<LanguageProvider>(context).locale,
      supportedLocales: context.read<LanguageProvider>().supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.tripPlannerScreenTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      initialRoute: AppRoutes.homeScreen,
      routes: AppRoutes.routes,
    );
  }
}