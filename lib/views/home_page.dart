import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../notes_provider.dart';
import '../util/auth_service.dart';
import 'note_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    const maxScreenWidth = 1200.0;
    final screenWidth = min(MediaQuery.of(context).size.width, maxScreenWidth);
    final crossCount = (screenWidth / 300).ceil();

    final user = Provider.of<NoteNotifier>(context).user;
    final cards = List.generate(100, (index) => NoteCard(index));

    final title = Text(user?.email ?? user?.uid ?? 'Notes');
    final leadingButton = IconButton(
      icon: Image.asset('assets/GitHub-Mark-Light-64px.png'),
      padding: EdgeInsets.all(11),
      onPressed: () => launch('https://github.com/AlluringKettle/SteamyNotes'),
    );
    final authButton = user == null
        ? IconButton(icon: Icon(Icons.login), onPressed: AuthService.signInWithGoogle)
        : IconButton(icon: Icon(Icons.logout), onPressed: AuthService.signOut);

    return Scaffold(
      appBar: AppBar(
        title: title,
        leading: leadingButton,
        actions: [authButton],
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
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
