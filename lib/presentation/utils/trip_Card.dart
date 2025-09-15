import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import '../../core/data/tables/experience_Table.dart';
import '../../core/data/tables/participant_Table.dart';
import '../../core/data/tables/stop_Table.dart';
import '../../core/data/tables/transport_Table.dart';
import '../../core/data/tables/tripImages_Table.dart';
import '../../core/data/tables/trip_Table.dart';
import '../../domain/entities/experience.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/stop.dart';
import '../../domain/entities/transport.dart';
import '../../domain/entities/trip.dart';
import '../../domain/entities/tripImage.dart';
import '../../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../states/trip_State.dart';
import 'addStopImage_Dialog.dart';
import 'deleteTrip_Dialog.dart';
import 'editTrip_Dialog.dart';
import '../../core/routes/app_Routes.dart';
import '../utils/translation_Util.dart';

class TripCard extends StatefulWidget {
  final Trip trip;
  const TripCard({super.key, required this.trip});

  static List<Trip> getActiveTrips(List<Trip> trips) {
    return trips.where((trip) => trip.status == 1).toList();
  }

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  final tripController = TripController();
  final participantController = ParticipantController();
  final stopController = StopController();
  final transportController = TransportController();
  final experienceController = ExperienceController();
  final tripImagesController = TripImageController();

  List<Participant> participants = [];
  List<Stop> stops = [];
  List<Transport> transports = [];
  List<Experience> experiences = [];
  Map<int, List<TripImage>> stopImagesMap = {}; // stopId -> List<TripImage>

  bool isLoading = false;
  bool loadedOnce = false;

  Future<void> _loadDetails() async {
    if (loadedOnce) return;
    setState(() => isLoading = true);

    final p = await participantController.selectWhere(widget.trip.id!);
    final s = await stopController.selectWhere(widget.trip.id!);
    final t = await transportController.selectWhere(widget.trip.id!);
    final e = await experienceController.selectWhere(widget.trip.id!);

    // Load images for each stop
    Map<int, List<TripImage>> imagesMap = {};
    for (final stop in s) {
      final stopImages = await tripImagesController.selectWhere(stop.id!);
      imagesMap[stop.id!] = stopImages;
    }

    setState(() {
      participants = p;
      transports = t;
      experiences = e;
      stops = s;
      stopImagesMap = imagesMap;
      isLoading = false;
      loadedOnce = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayFormat = (() {
      switch (context.read<LanguageProvider>().locale.languageCode) {
        case 'en':
          return DateFormat('MM/dd/yyyy');
        case 'es':
        case 'pt':
        default:
          return DateFormat('dd/MM/yyyy');
      }
    })();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          if (expanded) _loadDetails();
        },
        leading: const Icon(Icons.flight_takeoff),
        title: Text(widget.trip.tripName),
        subtitle: Text(
          "${AppLocalizations.of(context)!.stopDeparture} ${displayFormat.format(widget.trip.departure!)}\n"
              "${AppLocalizations.of(context)!.stopArrival} ${displayFormat.format(widget.trip.arrival!)}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () async {
                final file = await generateTripPdfStaticMap(context, widget.trip, "AIzaSyAgT9pV0ONamMF8ByF008OT7lf4-1oAFd0");
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _onEditPressed(context, widget.trip),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final deleted = await _onDeletePressed(tripController, context, widget.trip);
                if (deleted == true && context.mounted) {
                  await context.read<TripState>().load();
                }
              },
            ),
          ],
        ),
        children: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (participants.isNotEmpty)
                  _buildSection(
                    AppLocalizations.of(context)!.participantsScreenTitle,
                    participants.map((p) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: p.photo != null ? FileImage(File(p.photo!)) : null,
                              child: p.photo == null || p.photo!.isEmpty ? const Icon(Icons.person) : null,
                            ),
                            const SizedBox(width: 10),
                            Text("${p.name} (${p.age})"),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                if (transports.isNotEmpty)
                  _buildSection(
                    AppLocalizations.of(context)!.transportScreenTitle,
                    transports.map((t) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.directions_bus, color: Colors.blueAccent),
                        title: Text(TranslationUtil.translate(context, t.transportName), style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                  ),
                if (experiences.isNotEmpty)
                  _buildSection(
                    AppLocalizations.of(context)!.experienceScreenTitle,
                    experiences.map((e) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.place, color: Colors.blueAccent),
                        title: Text(TranslationUtil.translate(context, e.type), style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                  ),
                if (stops.isNotEmpty)
                  _buildSection(
                    AppLocalizations.of(context)!.stopScreenTitle,
                    stops.map((s) {
                      final stopImages = stopImagesMap[s.id!] ?? [];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: (s.photo != null && s.photo!.isNotEmpty)
                                      ? (s.photo!.startsWith('http') ? NetworkImage(s.photo!) as ImageProvider : FileImage(File(s.photo!)))
                                      : const AssetImage('assets/notAvailable.jpg'),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      if (s.departure != null && s.arrival != null)
                                        Text(
                                          '${AppLocalizations.of(context)!.stopDeparture}: ${displayFormat.format(s.departure!)}\n'
                                              '${AppLocalizations.of(context)!.stopArrival}: ${displayFormat.format(s.arrival!)}',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_a_photo, color: Colors.blue),
                                  onPressed: () async {
                                    final participantId = participants.isNotEmpty ? participants.first.id : null;
                                    final stopId = s.id;
                                    if (stopId == null) return;

                                    final newImage = await showDialog<TripImage>(
                                      context: context,
                                      builder: (_) => AddStopImageDialog(
                                        participantId: participantId!,
                                        stopId: stopId,
                                        tripImagesController: tripImagesController,
                                      ),
                                    );

                                    if (newImage != null) {
                                      setState(() {
                                        if (stopImagesMap[stopId] == null) stopImagesMap[stopId] = [];
                                        stopImagesMap[stopId]!.add(newImage);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            if (stopImages.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 58, top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: stopImages.map((ti) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(radius: 20, backgroundImage: FileImage(File(ti.photo))),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(ti.report ?? "")),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Column(children: children),
        ],
      ),
    );
  }
}

// EDIT TRIP
Future<void> _onEditPressed(BuildContext context, Trip trip) async {
  final shouldNavigate = await showDialog<bool>(
    context: context,
    builder: (_) => EditTripDialog(tripId: trip.id!),
  );
  if (shouldNavigate != true) return;
  if (context.mounted) {
    Navigator.pushNamed(context, AppRoutes.editTripScreen, arguments: trip.id!);
  }
}

// DELETE TRIP
Future<bool> _onDeletePressed(TripController tripController, BuildContext context, Trip trip) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (_) => DeleteTripDialog(trip: trip),
  );
  if (shouldDelete == true && context.mounted) {
    await tripController.delete(trip);
    return true;
  }
  return false;
}

// GENERATE PDF
Future<File> generateTripPdfStaticMap(
    BuildContext context,
    Trip trip,
    String googleApiKey,
    ) async {
  final pdf = pw.Document();

  // 🔹 Load data
  final participants = await ParticipantController().selectWhere(trip.id!);
  final transports = await TransportController().selectWhere(trip.id!);
  final stops = await StopController().selectWhere(trip.id!);
  final experiences = await ExperienceController().selectWhere(trip.id!);
  final tripImagesController = TripImageController();

  // Load images by stop
  Map<int, List<TripImage>> stopImagesMap = {};
  for (final stop in stops) {
    final stopImages = await tripImagesController.selectWhere(stop.id!);
    stopImagesMap[stop.id!] = stopImages;
  }

  final dateFormat = DateFormat('dd/MM/yyyy');
  final transportName = transports.isNotEmpty ? transports.first.transportName : "Not defined";

  // 🔹 COVER PAGE
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5,
      build: (context) => pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(trip.tripName,
                style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('From ${dateFormat.format(trip.departure!)} to ${dateFormat.format(trip.arrival!)}'),
            pw.SizedBox(height: 16),
            pw.Text('Transport: $transportName'),
          ],
        ),
      ),
    ),
  );

  // 🔹 PARTICIPANTS PAGE
  if (participants.isNotEmpty) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Participants', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            ...participants.map((p) {
              return pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (p.photo != null && p.photo!.isNotEmpty)
                    pw.Container(
                      width: 50,
                      height: 50,
                      margin: const pw.EdgeInsets.only(right: 12),
                      child: pw.Image(
                        pw.MemoryImage(File(p.photo!).readAsBytesSync()),
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  pw.Text('${p.name} (${p.age})', style: pw.TextStyle(fontSize: 14)),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // 🔹 STOPS PAGES
  for (final stop in stops) {
    final stopExperiences = experiences.where((e) => e.tripId == stop.id).toList();
    final stopImages = stopImagesMap[stop.id!] ?? [];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(stop.name, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            if (stop.departure != null && stop.arrival != null)
              pw.Text(
                'From ${dateFormat.format(stop.departure!)} to ${dateFormat.format(stop.arrival!)}',
                style: pw.TextStyle(color: PdfColors.grey, fontSize: 12),
              ),
            pw.SizedBox(height: 12),

            if (stopExperiences.isNotEmpty)
              ...stopExperiences.map((exp) => pw.Text('Experience: ${exp.type}', style: pw.TextStyle(fontSize: 14))),
            if (stopExperiences.isNotEmpty) pw.SizedBox(height: 12),

            if (stopImages.isNotEmpty)
              ...stopImages.map((img) {
                final imageFile = File(img.photo);
                if (!imageFile.existsSync()) return pw.SizedBox();
                final bytes = imageFile.readAsBytesSync();
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain, width: PdfPageFormat.a5.width - 40),
                    if (img.report != null && img.report!.isNotEmpty)
                      pw.Text(img.report!, style: pw.TextStyle(fontSize: 12)),
                    pw.SizedBox(height: 12),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  // 🔹 FINAL PAGE
  Uint8List? logoBytes;
  try {
    final byteData = await rootBundle.load('assets/TravelMate.png');
    logoBytes = byteData.buffer.asUint8List();
  } catch (e) {
    print(AppLocalizations.of(context)!.errorLoadingLogo(e));
  }

  final finalMessage = AppLocalizations.of(context)!.finalMessage;

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5,
      build: (context) => pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (logoBytes != null)
            pw.Image(
              pw.MemoryImage(logoBytes),
              width: 250,
              height: 250,
              fit: pw.BoxFit.contain,
            ),
          pw.SizedBox(height: 20),
          pw.Text(
            finalMessage,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    ),
  );

  // 🔹 SAVE PDF PUBLICLY in Downloads
  final downloadsDir = Directory('/storage/emulated/0/Download');
  if (!await downloadsDir.exists()) await downloadsDir.create(recursive: true);

  final file = File('${downloadsDir.path}/${trip.tripName}.pdf');
  await file.writeAsBytes(await pdf.save());

  return file;
}

