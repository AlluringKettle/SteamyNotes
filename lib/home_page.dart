import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:steamy_notes/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'note_card.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = "Notes";

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<NotesWrapper>(context).user;
    var title = user?.email ?? user?.uid ?? "Notes";
    const double maxScreenWidth = 1200;
    double screenWidth = min(MediaQuery.of(context).size.width, maxScreenWidth);
    int crossCount = (screenWidth / 300).ceil();
    List<NoteCard> cards = List.generate(100, (index) => NoteCard(index, ""));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset("assets/GitHub-Mark-Light-32px.png"),
          onPressed: () {
            launch('https://github.com/AlluringKettle/SteamyNotes');
          },
        ),
        title: Text(title),
        centerTitle: true,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        actions: [
          user == null
              ? IconButton(
                  icon: Icon(Icons.login),
                  onPressed: AuthService.signInWithGoogle,
                )
              : IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: AuthService.signOut,
                ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxScreenWidth),
          child: GridView.count(
            crossAxisCount: crossCount,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            padding: EdgeInsets.all(2),
            children: cards,
          ),
        ),
      ),
    );
  }
}
