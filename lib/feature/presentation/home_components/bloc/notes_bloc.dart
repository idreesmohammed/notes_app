import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/feature/data/datasources/firebase_network_calls.dart';
import 'package:notes/feature/presentation/home_components/bloc/notes_event.dart';
import 'package:notes/feature/presentation/home_components/bloc/notes_state.dart';

class NotesBloc extends Bloc<NotestEvent, NotesState> {
  NotesBloc() : super(NotesInitialState()) {
    on<NotesActionEvent>(
      (event, emit) async {
        try {
          await FirebaseNetworkCalls().firebaseNotesAddCall(event);
        } catch (e) {
          throw (Exception(e));
        }
      },
    );
    on<NotesDataFetchEvent>(
      (event, emit) async {
        emit(NotesDataFetchLoadingState());
        CollectionReference collectionReference =
            FirebaseFirestore.instance.collection('users');
        collectionReference.doc('user data');
        final data = await FirebaseNetworkCalls().data();
        emit(NotesDataFetchSuccessState(notesModel: data));
      },
    );
  }
}
