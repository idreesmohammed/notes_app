import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

class NotesModel {
  String heading;
  String description;
  String? tag;

  NotesModel({
    required this.heading,
    required this.description,
    this.tag,
  });
  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      heading: json["title"],
      description: json["description"],
      tag: json['tag'] ?? '',
    );
  }
}
/*
class NotesModel {
  String heading;
  String description;
  List<String>? tag;

  NotesModel({
    required this.heading,
    required this.description,
    this.tag,
  });
  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      heading: json["title"],
      description: json["description"],
      tag: json[["tag"]] ?? [""],
    );
  }
}
*/

class NotesModelTwo {
  String heading;
  String description;
  List<String>? tag;

  NotesModelTwo({
    required this.heading,
    required this.description,
    this.tag,
  });
  factory NotesModelTwo.fromJson(DocumentSnapshot json) {
    return NotesModelTwo(
      heading: json["title"],
      description: json["description"],
      tag: json[["tag"]],
    );
  }
}
