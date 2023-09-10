// ignore_for_file: invalid_annotation_target

import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.isDone,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final bool isDone;

  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
  Map<String, Object?> toJson() => _$TodoToJson(this);
}
