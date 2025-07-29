import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_Routes.dart';
import '../../l10n/app_localizations.dart';
import '../states/group_State.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GroupState>(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.groupScreenTitle)),
      body: Column(
        children: [
          Expanded(
            child: TextFormField(
              controller: state.controllerGroupName,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: AppLocalizations.of(context)!.groupTripName,
                prefixIcon: Icon(Icons.archive),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final groupId = await state.insert();

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.transportScreen,
                arguments: groupId,
              );
            },
            child: Text(AppLocalizations.of(context)!.generalConfirmButton),
          ),
        ],
      ),
    );
  }
}
