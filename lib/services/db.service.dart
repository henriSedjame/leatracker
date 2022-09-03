import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leatracker/models/position.dart';

const POSITIONS = "positions";

class DbService {
  static final ref = FirebaseFirestore.instance
      .collection(POSITIONS)
      .withConverter<LeaPosition>(
          fromFirestore: (snapshot, _) =>
              LeaPosition.fromJson(snapshot.data()!),
          toFirestore: (position, _) => position.toJson());

  static Future<String> save(LeaPosition position) {
    return ref.add(position).then((value) => value.id);
  }

  static Stream<List<LeaPosition>> watch() {
    return ref
        .orderBy("at", descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  static Future<void> purge() async {

    DateTime date = DateTime.now().subtract(const Duration(days: 7));

    await ref
        .where("at", isLessThan: date.toIso8601String())
        .get()
        .then((value) async {
          for (var doc in value.docs) {
            await doc.reference.delete();
          }
        });
  }
}
