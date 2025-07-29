import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_final_academy/presentation/states/participant_State.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';

class DynamicParticipantFields extends StatefulWidget {
  final List<TextEditingController> nameControllers;
  final List<TextEditingController> ageControllers;
  final VoidCallback onAdd;
  final void Function(int index)? onRemove;

   const DynamicParticipantFields({
    super.key,
    required this.nameControllers,
    required this.ageControllers,
    required this.onAdd,
    this.onRemove,
  });

  @override
  State<DynamicParticipantFields> createState() => _DynamicParticipantFieldsState();
}



class _DynamicParticipantFieldsState extends State<DynamicParticipantFields> {


  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ParticipantState>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.nameControllers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [

                          Text('${AppLocalizations.of(context)!.participantsPerson} ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),

                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        state.participantImage[index] != null
                            ? CircleAvatar(
                          radius: 24,
                          backgroundImage: FileImage(state.participantImage[index]!),
                        )
                            : const CircleAvatar(child: Icon(Icons.person)),
                        Flexible(
                          flex: 3,
                          child: TextFormField(
                            controller: widget.nameControllers[index],
                            decoration:  InputDecoration(
                              hintText: AppLocalizations.of(context)!.participantsName,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: widget.ageControllers[index],
                            keyboardType: TextInputType.number,
                            decoration:  InputDecoration(hintText: AppLocalizations.of(context)!.participantsAge),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(widget.onRemove != null)
                          IconButton(onPressed: () async {
                            _pickImageFromGallery(index);
                          },
                              icon: Icon(Icons.photo)),
                        IconButton(
                            onPressed: () async {
                              await _pickImageFromCamera(index);
                        },
                            icon: Icon(Icons.camera)
                        ),
                          IconButton(
                            onPressed: () async{
                              state.addParticipant();
                              },
                            icon: Icon(Icons.add_circle_outline),
                          ),
                          IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red,),
                              onPressed: () {
                                state.removeParticipant(index);
                              },
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



  Future _pickImageFromGallery(int index) async {
    final participantImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (participantImage == null) return;

    final state = Provider.of<ParticipantState>(context, listen: false);
    state.updateParticipantImage(index, File(participantImage.path));
  }
  Future _pickImageFromCamera(int index) async{
    final participantImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if(participantImage == null) return;
    final state = Provider.of<ParticipantState>(context, listen: false);
    state.updateParticipantImage(index, File(participantImage.path));

  }
}

