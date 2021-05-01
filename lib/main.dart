import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'notes_provider.dart';
import 'views/home_page.dart';
import 'util/stub.dart' if (dart.library.js) 'util/web.dart';

void main() async {
  restartFirebase();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SteamyNotes());
}

class SteamyNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotesWrapper>(
      create: (context) => NotesWrapper(List.filled(100, '')),
      child: MaterialApp(
        title: 'Steamy Notes',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Color(0xFFFF774D),
          appBarTheme: AppBarTheme(color: Color(0xFFFF774D)),
        ),
        home: HomePage(),
      ),
    );
  }
}
