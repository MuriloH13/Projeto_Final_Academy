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

  TextEditingController get controllerGroupName => _controllerGroupName;

  Trip? get currentGroup => _currentGroup;


  final _groupList = <Trip>[];

  List<Trip> get groupList => _groupList;

  Future<int> insert() async{
    final group = Trip(groupName: controllerGroupName.text);

    final int id = await controllerDatabase.insert(group);
    await load();

    controllerGroupName.clear();
    notifyListeners();
    return id;
  }

  Future<void> updateGroup(Trip trip) async {
    final editedGroup = Trip(
      id: _currentGroup?.id,
      cities: _currentGroup?.cities,
      participants: _currentGroup?.participants,
      experiences: _currentGroup?.experiences,
      groupName: controllerGroupName.text,
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