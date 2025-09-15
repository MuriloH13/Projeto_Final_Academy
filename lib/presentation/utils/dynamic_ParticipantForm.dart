import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/states/participant_State.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';

class DynamicParticipantFields extends StatelessWidget {
  final bool isDetails;
  final VoidCallback? onAdd;
  final void Function(int index)? onRemove;

  const DynamicParticipantFields({
    super.key,
    required this.isDetails,
    this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<ParticipantState>();

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.participantList.length,
            itemBuilder: (context, index) {
              var participant = state.participantList[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.participantsPerson} ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        participant.photo != null
                            ? SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(participant.photo ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              controller: participant.nameController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(
                                  context,
                                )!.participantsName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              controller: participant.ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(
                                  context,
                                )!.participantsAge,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final file = await state.pickImage(
                              participant: state.participantList[index],
                              fromCamera: false,
                            );

                            if (state.participantList.length > index) {
                              state.participantList.removeAt(index);
                            }
                            state.participantList.insert(
                              index,
                              participant.copyWith(photo: file?.path, photoFile: file),
                            );

                            state.reload();
                          },
                          icon: Icon(Icons.photo),
                        ),
                        IconButton(
                          onPressed: () async {
                            final file = await state.pickImage(
                              participant: state.participantList[index],
                              fromCamera: true
                            );

                            if (state.participantList.length > index) {
                              state.participantList.removeAt(index);
                            }

                            state.participantList.insert(
                              index,
                              participant.copyWith(photo: file?.path, photoFile: file),
                            );

                            state.reload();
                          },
                          icon: Icon(Icons.camera),
                        ),
                        if (onAdd != null)
                          IconButton(
                            onPressed: () async {
                              state.addParticipant();
                            },
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        if (onRemove != null)
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              state.removeParticipant(index);
                            },
                          ),
                      ],
                    ),
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
