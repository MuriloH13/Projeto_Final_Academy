import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../core/data/tables/transport_Table.dart';
import '../../domain/entities/transport.dart';

class TransportState extends ChangeNotifier {
  TransportState() {
    load();
  }

  String selectedTransport = "";

  final controllerDatabase = TransportController();

  final _controllerTransportName = TextEditingController();

  TextEditingController get controllerTransportName => _controllerTransportName;

  final _transportList = <Transport>[];

  List<Transport> get transportList => _transportList;

  Future<void> insert(int tripId) async {
    // Remove any existing transport for this group
    final existingTransports = _transportList.where((t) => t.tripId == tripId).toList();
    for (final t in existingTransports) {
      await controllerDatabase.delete(t);
    }

    // Insert the new transport
    final transport = Transport(
      transportName: selectedTransport,
      tripId: tripId,
    );
    await controllerDatabase.insert(transport);

    await load();
    controllerTransportName.clear();
    notifyListeners();
  }

  Future<void> delete(Transport transport) async {

    await controllerDatabase.delete(transport);
    await load();

    notifyListeners();
  }

  Future<void> load() async {
    final list = await controllerDatabase.select();
    _transportList
      ..clear()
      ..addAll(list);
    notifyListeners();
  }
}