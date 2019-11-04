import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

enum Priority { Low, Medium, High }

@JsonSerializable()
class Task {
  Task({this.id, this.name, this.description, this.creationDate, this.expirationDate, this.priority});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  int id;
  String name;
  String description;
  DateTime creationDate;
  DateTime expirationDate;
  Priority priority;
}

