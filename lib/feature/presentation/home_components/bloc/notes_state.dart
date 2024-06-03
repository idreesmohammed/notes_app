import 'package:notes/feature/data/model/notesmodel.dart';

abstract class NotesState {}

class NotesInitialState extends NotesState {}

class NotesAddSuccessState extends NotesState {}

class NotesAddFailureState extends NotesState {}

class NotesDataFetchSuccessState extends NotesState {
  List<NotesModel> notesModel;
  NotesDataFetchSuccessState({required this.notesModel});
}

class NotesTagFetchState extends NotesState {
  Stream<List<NotesModelTwo>> notesModel;
  NotesTagFetchState({required this.notesModel});
}

class NotesDataFetchFailureState extends NotesState {}

class NotesDataFetchLoadingState extends NotesState {}

class NotesToggleCheckboxState extends NotesState {
  bool isChecked;
  NotesToggleCheckboxState({required this.isChecked});
}
