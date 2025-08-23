import 'package:flutter/material.dart';

import '../../core/data/tables/trip_Table.dart';
import '../../domain/entities/trip.dart';

class TripState extends ChangeNotifier {
  TripState() {
    load();
  }
  final controllerDatabase = TripController();

  Trip? _currentGroup;

  final _controllerGroupName = TextEditingController();
  final _controllerTripDepartureDate = ValueNotifier<DateTime?>(null);
  final _controllerTripArrivalDate = ValueNotifier<DateTime?>(null);

  TextEditingController get controllerGroupName => _controllerGroupName;
  ValueNotifier<DateTime?> get controllerTripDepartureDate => _controllerTripDepartureDate;
  ValueNotifier<DateTime?> get controllerTripArrivalDate => _controllerTripArrivalDate;

  int groupStatus = 0;

  Trip? get currentGroup => _currentGroup;

  final _groupList = <Trip>[];

  List<Trip> get groupList => _groupList;

  Future<int> insert() async {
    final group = Trip(
      groupName: controllerGroupName.text,
      departure: controllerTripDepartureDate.value,
      arrival: controllerTripArrivalDate.value,
      status: groupStatus,
    );

    final int id = await controllerDatabase.insert(group);
    await load();

    controllerGroupName.clear();
    notifyListeners();
    return id;
  }

  Future<void> updateGroup(Trip trip) async {
    final editedGroup = Trip(
      id: _currentGroup?.id,
      groupName: controllerGroupName.text,
      departure: controllerTripDepartureDate.value,
      arrival: controllerTripArrivalDate.value,
      status: groupStatus,
      cities: _currentGroup?.cities,
      participants: _currentGroup?.participants,
      experiences: _currentGroup?.experiences,
    );
    await controllerDatabase.update(editedGroup);
    _currentGroup = null;
    _controllerGroupName.clear();
    await load();
  }

  Future<void> delete(Trip trip) async {
    await controllerDatabase.delete(trip);
    await load();

    notifyListeners();
  }

  Future<void> load() async {
    final list = await controllerDatabase.select();
    _groupList
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  @override
  void dispose() {
    _controllerGroupName.dispose();
    super.dispose();
  }
}
