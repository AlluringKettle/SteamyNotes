import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NoteNotifier with ChangeNotifier {
  User? user;
  List<String> notes;
  StreamSubscription<DocumentSnapshot>? subscription;

  void updateUser(User? user) {
    if (this.user != user) {
      this.user = user;
      notifyListeners();
      subscribeToDatabase();
    }
  }

  NoteNotifier(this.notes) {
    FirebaseAuth.instance.authStateChanges().listen(updateUser);
    subscribeToDatabase();
  }

  void updateNotes(List<String> notes) {
    this.notes = notes;
    notifyListeners();
  }

  void storeNote(int index, String text) {
    notes[index] = text;
  }

  void pushToDatabase() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid ?? '0');
    await userDoc.set({'notes': notes});
  }

  void subscribeToDatabase() {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid ?? '0');
    subscription?.cancel();
    subscription = userDoc.snapshots().listen(
      (DocumentSnapshot document) {
        List data = document.get('notes') ?? List.empty();
        List<String> list = List.filled(100, '');
        list.setRange(0, data.length, data.cast());
        this.updateNotes(list);
      },
    );
  }
}
