import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class TravelDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final void Function()? onDelete;
  const TravelDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> jsonData = jsonDecode(description);
    Delta delta = Delta.fromJson(jsonData);

    // Create a QuillController with the parsed Delta content
    final quillController = QuillController(
      document: Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
              top: 8.0, right: 10.0, bottom: 4.0, left: 10.0),
          child: QuillEditor.basic(
            controller: quillController,
            configurations: QuillEditorConfigurations(
              embedBuilders: FlutterQuillEmbeds.editorBuilders(),
              // readOnlyMouseCursor: MouseCursor.defer,
            ),
          ),
        ),
      ),
    );
  }
}
