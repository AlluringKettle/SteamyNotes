import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesWrapper with ChangeNotifier {
  User? user;
  List<String> notes;
  StreamSubscription<DocumentSnapshot>? subscription;

  void setUser(User? user) {
    if (this.user != user) {
      this.user = user;
      notifyListeners();
      this.subscribeToDatabase();
    }
  }

  NotesWrapper(this.notes) {
    FirebaseAuth.instance.authStateChanges().listen(setUser);
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
      var userDoc = FirebaseFirestore.instance.collection("users").doc(user!.uid);
      var firestoreData = await userDoc.get();
      List data = firestoreData.data()?["notes"] ?? List<String>.empty();
      list.setRange(0, data.length, data.cast());
    }
    this.setNotes(list);
  }

  void subscribeToDatabase() async {
    subscription?.cancel();
    if (user != null) {
      Stream<DocumentSnapshot> snapshots =
          FirebaseFirestore.instance.collection("users").doc(user!.uid).snapshots();
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
