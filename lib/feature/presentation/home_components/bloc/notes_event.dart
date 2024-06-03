import 'package:notes/feature/data/model/notesmodel.dart';

abstract class NotestEvent {}

class NotesActionEvent extends NotestEvent {
  String? heading;
  String description;
  String? tag;
  bool isSelected;
  NotesActionEvent(
      {this.heading,
      required this.description,
      this.tag,
      this.isSelected = false});
}

class NotesDataFetchEvent extends NotestEvent {}

class NotesTagFetchEvent extends NotestEvent {}

class NotesCheckBoxCheckToggleEvent extends NotestEvent {}

class NotesFilterTagAddEvent extends NotestEvent {
  NotesModel label;
  NotesFilterTagAddEvent({required this.label});
}

class NotesSelectedColorChangeEvent extends NotestEvent {}
