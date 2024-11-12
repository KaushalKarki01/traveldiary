import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveldiary/components/text_field.dart';
import 'package:traveldiary/database/local/database_helper.dart';
import 'package:traveldiary/model/travel_destination.dart';

class TravelDescriptionNoteScreen extends StatefulWidget {
  const TravelDescriptionNoteScreen({super.key});

  @override
  State<TravelDescriptionNoteScreen> createState() =>
      _TravelDescriptionNoteScreenState();
}

class _TravelDescriptionNoteScreenState
    extends State<TravelDescriptionNoteScreen> {
  DBHelper dbRef = DBHelper.getInstance;
  final TextEditingController _titleController = TextEditingController();
  final QuillController _descriptionController = QuillController.basic();

  List<String> mediaPaths = []; // to store media paths

  // SAVE IMAGE
  Future<void> onImagePick() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final String imagePath = image.path;
      _descriptionController.insertImageBlock(
        imageSource: imagePath,
      );
      // mediaPaths.add(imagePath);
      print('Image inserted on path:$imagePath');
    }
  }

  // SAVE VIDEO

  // SAVE DATA TO DATABASE
  void saveDestination() async {
    final now = DateTime.now();
    final title = _titleController.text;
    String description =
        jsonEncode(_descriptionController.document.toDelta().toJson());
    // HANDLE IMAGES
    print('title:$title, description:$description');
    final mediaPaths = <String>[];
    List<dynamic> operations =
        _descriptionController.document.toDelta().toJson();
    for (var op in operations) {
      if (op['insert'] is Map && op['insert']['image'] != null) {
        mediaPaths.add(op['insert']['image']);
      }
    }
    print('Extracted mediapaths: $mediaPaths');
    // String? mediaPathsJson =
    //     mediaPaths.isNotEmpty ? jsonEncode(mediaPaths) : null;
    final TravelDestination newDestination = TravelDestination(
        title: title,
        desc: description,
        // mediaPaths: mediaPathsJson != null
        //     ? jsonDecode(mediaPathsJson).cast<String>()
        //     : null,
        mediaPaths: mediaPaths,
        createdAt: now,
        updatedAt: now);
    await dbRef.insertEntry(newDestination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _descriptionController.clear();
              _titleController.clear();
            },
            icon: const Icon(Icons.cancel),
          ),
          IconButton(
            onPressed: () {
              saveDestination();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: [
            CTextField(
                controller: _titleController,
                label: 'Title',
                hintText: 'Enter Destination'),
            const SizedBox(height: 10),
            QuillToolbar.simple(
              controller: _descriptionController,
              configurations: QuillSimpleToolbarConfigurations(
                // multiRowsDisplay: true,
                showLink: false,
                showInlineCode: false,
                showClipboardCut: false,
                showSearchButton: false,
                showBackgroundColorButton: false,
                showSubscript: false,
                showSuperscript: false,
                showCodeBlock: false,
                showQuote: false,
                showStrikeThrough: false,
                showIndent: false,
                showClipboardPaste: false,

                embedButtons: FlutterQuillEmbeds.toolbarButtons(
                  imageButtonOptions: QuillToolbarImageButtonOptions(),
                ),
              ),
            ),
            Expanded(
              child: QuillEditor.basic(
                controller: _descriptionController,
                configurations: QuillEditorConfigurations(
                  placeholder: 'Write about the destination',
                  embedBuilders: kIsWeb
                      ? FlutterQuillEmbeds.editorWebBuilders()
                      : FlutterQuillEmbeds.editorBuilders(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
