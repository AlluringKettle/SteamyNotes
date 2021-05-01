import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notes_provider.dart';

class NoteCard extends StatefulWidget {
  final int index;
  const NoteCard(this.index);

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  double fontSize = 60;
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        Provider.of<NoteNotifier>(context, listen: false).pushToDatabase();
      }
    });
  }

  void onTextChanged(String text) {
    setState(() {
      fontSize = 60 - log(text.length ~/ 7 * 14.4 + 1) * 7;
    });
    storeNote();
  }

  void storeNote() {
    Provider.of<NoteNotifier>(context, listen: false).storeNote(widget.index, controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final newText = Provider.of<NoteNotifier>(context, listen: true).notes[widget.index];
    if (newText != controller.text) {
      controller.text = newText;
      fontSize = 60 - log(controller.text.length ~/ 7 * 14.4 + 1) * 7;
    }
    return Card(
      child: Container(
        child: TextField(
          controller: controller,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          expands: true,
          style: TextStyle(fontSize: fontSize),
          onChanged: onTextChanged,
          focusNode: focusNode,
        ),
      ),
    );
  }
}
