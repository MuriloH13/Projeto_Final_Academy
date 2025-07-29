import 'package:flutter/material.dart';

import '../../core/data/tables/group_Table.dart';
import '../../domain/entities/group.dart';

class GroupState extends ChangeNotifier {
  GroupState() {
    load();
  }
  final controllerDatabase = GroupController();

  final _controllerGroupName = TextEditingController();

  TextEditingController get controllerGroupName => _controllerGroupName;


  final _groupList = <Group>[];

  List<Group> get groupList => _groupList;

  Future<int> insert() async{
    final group = Group(groupName: controllerGroupName.text);

    final int id = await controllerDatabase.insert(group);
    await load();

    controllerGroupName.clear();
    notifyListeners();
    return id;
  }

  Future<void> delete(Group group) async {

    await controllerDatabase.delete(group);
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