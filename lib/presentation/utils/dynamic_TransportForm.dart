import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class DynamicTransportFields extends StatelessWidget {
  final List<TextEditingController> transportControllers;
  final VoidCallback onAdd;
  final void Function(int index)? onRemove;

  const DynamicTransportFields({
    super.key,
    required this.transportControllers,
    required this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: transportControllers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${AppLocalizations.of(context)!.transportName} ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: transportControllers[index],
                      decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.participantsName),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(onRemove != null)
                          IconButton(
                            onPressed: onAdd,
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () => onRemove!(index),
                        )
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}