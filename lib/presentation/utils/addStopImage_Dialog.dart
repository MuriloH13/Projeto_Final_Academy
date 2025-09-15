import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/data/tables/tripImages_Table.dart';
import '../../domain/entities/tripImage.dart';
import '../../l10n/app_localizations.dart';

class AddStopImageDialog extends StatefulWidget {
  final int stopId;
  final int participantId;
  final TripImageController tripImagesController;

  const AddStopImageDialog({
    super.key,
    required this.stopId,
    required this.participantId,
    required this.tripImagesController,
  });

  @override
  State<AddStopImageDialog> createState() => _AddStopImageDialogState();
}

class _AddStopImageDialogState extends State<AddStopImageDialog> {
  File? pickedImage;
  final TextEditingController commentController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        pickedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.addStopImageDialogComment,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: pickedImage != null
                        ? Image.file(pickedImage!, fit: BoxFit.cover)
                        : const Icon(Icons.add_a_photo, size: 40),
                  ),
                ),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.addStopImageDialogComment,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(AppLocalizations.of(context)!.generalCancelButton),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (pickedImage != null) {
                          final newTripImage = TripImage(
                            stopId: widget.stopId,
                            participantId: widget.participantId,
                            photo: pickedImage!.path,
                            report: commentController.text,
                          );
                          await widget.tripImagesController.insert(newTripImage);
                          Navigator.of(context).pop(newTripImage);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.generalYesButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}