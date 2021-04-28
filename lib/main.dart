import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AuthService.init();
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
  StreamSubscription<DocumentSnapshot>? subscription;

  NotesWrapper(this.notes) {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      this.user = user;
      notifyListeners();
      this.subscribeToDatabase();
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
    await userDoc.set({"notes": notes});
  }

  void loadFromDatabase() async {
    List<String> list = List.filled(100, "");
    if (user != null) {
      var userDoc =
          FirebaseFirestore.instance.collection("users").doc(user!.uid);
      var firestoreData = await userDoc.get();
      List data = firestoreData.data()?["notes"] ?? List<String>.empty();
      list.setRange(0, data.length, data.cast());
    }
    this.setNotes(list);
  }

  void subscribeToDatabase() async {
    subscription?.cancel();
    if (user != null) {
      Stream<DocumentSnapshot> snapshots = FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .snapshots();
      subscription = snapshots.listen((DocumentSnapshot document) {
        print("onSnapshot");
        List data = document.data()?["notes"] ?? List<String>.empty();
        List<String> list = List.filled(100, "");
        list.setRange(0, data.length, data.cast());
        this.setNotes(list);
      });
    } else {
      this.setNotes(List.filled(100, ""));
    }
  }
}
