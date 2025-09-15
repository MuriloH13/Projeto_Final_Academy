import 'package:flutter/material.dart';

import '../../core/data/tables/trip_Table.dart';
import '../../domain/entities/trip.dart';

class TripState extends ChangeNotifier {
  TripState() {
    load();
  }
  final controllerDatabase = TripController();
  bool isLoading = false;

  Trip? _currentGroup;

  final _controllerGroupName = TextEditingController();
  final controllerTripDepartureDate = ValueNotifier<DateTime?>(null);
  final controllerTripArrivalDate = ValueNotifier<DateTime?>(null);

  TextEditingController get controllerGroupName => _controllerGroupName;

  int groupStatus = 0;

  Trip? get currentGroup => _currentGroup;

  final _tripList = <Trip>[];

  List<Trip> get tripList => _tripList;

  Future<int> insert() async {
    isLoading = true;
    notifyListeners();

    final trip = Trip(
      tripName: controllerGroupName.text,
      departure: controllerTripDepartureDate.value,
      arrival: controllerTripArrivalDate.value,
      status: groupStatus,
    );

    final int id = await controllerDatabase.insert(trip);
    await load();

    controllerGroupName.clear();
    controllerTripDepartureDate.value = null;
    controllerTripArrivalDate.value = null;

    isLoading = false;
    notifyListeners();
    return id;
  }

  Future<void> updateGroup(Trip trip) async {
    isLoading = true;
    notifyListeners();

    final editedGroup = Trip(
      id: _currentGroup?.id,
      tripName: controllerGroupName.text,
      departure: controllerTripDepartureDate.value,
      arrival: controllerTripArrivalDate.value,
      status: groupStatus,
      stops: _currentGroup?.stops,
      participants: _currentGroup?.participants,
      experiences: _currentGroup?.experiences,
    );

    await controllerDatabase.update(editedGroup);

    _currentGroup = null;
    _controllerGroupName.clear();
    controllerTripDepartureDate.value = null;
    controllerTripArrivalDate.value = null;

    await load();

    isLoading = false;
    notifyListeners();
  }

  Future<void> delete(Trip trip) async {
    isLoading = true;
    notifyListeners();

    await controllerDatabase.delete(trip);
    await load();

    isLoading = false;
    notifyListeners();
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    final list = await controllerDatabase.select();

    _tripList
      ..clear()
      ..addAll(list);

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _controllerGroupName.dispose();
    controllerTripDepartureDate.dispose();
    controllerTripArrivalDate.dispose();
    super.dispose();
  }
}
