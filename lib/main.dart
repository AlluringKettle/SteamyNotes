import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SteamyNotes());
}

class SteamyNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotesWrapper>(
      create: (context) => NotesWrapper(List.filled(100, "")),
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

class NotesWrapper with ChangeNotifier {
  User? user;
  List<String> notes;

  NotesWrapper(this.notes) {
    // CRICITAL BUG ON DEBUG
    // see https://github.com/FirebaseExtended/flutterfire/issues/4756
    FirebaseAuth.instance.userChanges().listen((User? user) {
      this.user = user;
      notifyListeners();
      // print("Auth State Changed $user");
      this.loadFromDatabase();
    });
  }

  void setNotes(notes) {
    this.notes = notes;
    notifyListeners();
  }

  void updateNote(int index, String text) {
    notes[index] = text;
  }

  void saveToDatabase() async {
    if (user == null) return;
    var userDoc = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    // print("DB Saving: $notes");
    await userDoc.set({"notes": notes});
  }

  void loadFromDatabase() async {
    if (user != null) {
      var users = FirebaseFirestore.instance.collection("users");
      var firestoreData = await users.doc(user!.uid).get();
      List data = firestoreData.data()?["notes"] ?? List<String>.empty();
      // print("DB Loading: $data");
      List<String> arr = List.filled(100, "");
      arr.setRange(0, data.length, data.cast());
      this.setNotes(arr);
    } else {
      // print("Dumb db");
      this.setNotes(List.filled(100, ""));
    }
  }
}
