import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notepad_app/services/cloud/cloud_constants.dart';
import 'package:notepad_app/services/cloud/cloud_exceptions.dart';
import 'package:notepad_app/services/cloud/cloud_note.dart';

class FirestoreCloudService {
  final notes = FirebaseFirestore.instance.collection('notes');

  static final FirestoreCloudService _shared =
      FirestoreCloudService._sharedIsntance();
  factory FirestoreCloudService() => _shared;
  FirestoreCloudService._sharedIsntance();

  void createNewNote({required String ownerId}) async {
    await notes.add({ownerIdFieldName: ownerId, textFieldName: ''});
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerID}) async {
    try {
      return await notes.where(ownerIdFieldName, isEqualTo: ownerID).get().then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                    documentId: doc.id,
                    ownerID: doc.data()[ownerIdFieldName] as String,
                    text: doc.data()[textFieldName] as String);
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerId}) {
    return notes.snapshots().map(
          (event) => event.docs
              .map(
                (doc) => CloudNote(
                  documentId: doc.id,
                  ownerID: doc.data()[ownerIdFieldName],
                  text: doc.data()[textFieldName],
                ),
              )
              .where((note) => note.ownerID == ownerId),
        );
  }

  Future<void> updateNote({
    required String docId,
    required String text,
  }) async {
    try {
      await notes.doc(docId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deletNote({
    required String docId,
  }) async {
    try {
      await notes.doc(docId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
}
