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

  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
  static String getPrimaryKey(Map<String, Object?> json) =>
      json['id']! as String;

  final String id;

  final String title;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'is_done')
  final bool isDone;

  Map<String, Object?> toJson() => _$TodoToJson(this);
}
