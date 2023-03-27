import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future insertNote({
    required String title,
    required String description,
    required String userId,
  }) async {
    try {
      await firestore.collection('notes').add({
        'title': title,
        'description': description,
        'userId': userId,
        'date': Timestamp.now(),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updateNote({
    required String description,
    required String title,
    required String id,
  }) async {
    try {
      await firestore.collection('notes').doc(id).update({
        'title': title,
        'description': description,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future deleteNote(String id) async {
    try {
      await firestore.collection('notes').doc(id).delete();
    } catch (e) {
      print(e);
    }
  }
}
