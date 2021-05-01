import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notes_provider.dart';

class NoteCard extends StatefulWidget {
  final int index;
  final String initialText;

  NoteCard(this.index, this.initialText);

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  double fontSize = 60;
  final controller = TextEditingController();
  final focusNode = FocusNode();

  void storeText() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString(widget.index.toString(), controller.text);
    Provider.of<NoteNotifier>(context, listen: false).updateNote(widget.index, controller.text);
  }

  // void restoreText() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // setState(() {
  //   controller.text =
  //       prefs.getString(widget.index.toString()) ?? widget.initialText;
  // });
  // }

  void onTextChanged(String text) {
    setState(() {
      fontSize = 60 - log(text.length ~/ 7 * 14.4 + 1) * 7;
    });
    storeText();
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        Provider.of<NoteNotifier>(context, listen: false).saveToDatabase();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String newText = Provider.of<NoteNotifier>(context, listen: true).notes[widget.index];
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
