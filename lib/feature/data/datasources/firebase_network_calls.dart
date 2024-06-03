import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:notes/global_constants.dart';
import 'package:notes/feature/data/model/notesmodel.dart';

class FirebaseNetworkCalls {
  Future<List<NotesModel>> data() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid[0].toString())
        .collection('user data')
        .get();
    return snapshot.docs.map((e) => NotesModel.fromJson(e.data())).toList();
  }

  initialSetCall(userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData!.uid)
        .set({"uid": userData.uid, "name": userData.displayName});
  }

  firebaseNotesGetCall() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid[0].toString())
        .collection('user data')
        .get();
    return snapshot;
  }

  firebaseNotesAddCall(event) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid[0].toString())
        .collection('user data')
        .add({
      'title': event.heading,
      'description': event.description,
      'tag': event.tag ?? ''
    });
    return snapshot;
  }
}
