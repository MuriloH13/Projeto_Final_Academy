import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../core/data/tables/transport_Table.dart';
import '../../domain/entities/transport.dart';

class TransportState extends ChangeNotifier {
  TransportState() {
    addTransport();
    load();
  }

  final List<TextEditingController> transportControllers = [];
  final controllerDatabase = TransportController();
  final _transportList = <Transport>[];

  List<Transport> get transportList => _transportList;

  void addTransport() {
    transportControllers.add(TextEditingController());
    notifyListeners();
  }

  Future<void> insert(int groupId) async {
    for (int i = 0; i < transportControllers.length; i++) {
      final transport = Transport(
        transportName: transportControllers[i].text,
        groupId: groupId,
      );
      await controllerDatabase.insert(transport);
    }

    transportControllers.clear();
    notifyListeners();
  }

  void removeTransport(int index) {
    if(index >= 1) {
      transportControllers[index].dispose();
      transportControllers.removeAt(index);
      notifyListeners();
    }
    else {
      // ShowErrorCode
    }
  }

  Future<void> load() async {
    final list = await controllerDatabase.select();
    _transportList
      ..clear()
      ..addAll(list);
    notifyListeners();
  }
}