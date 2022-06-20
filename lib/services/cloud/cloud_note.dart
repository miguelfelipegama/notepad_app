import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'cloud_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerID;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.ownerID,
    required this.text,
  });
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerID = snapshot.data()[ownerIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
