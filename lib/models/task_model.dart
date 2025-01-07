import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_planner/common/enums/task_category.dart';
import 'package:task_planner/common/enums/task_status.dart';
import 'package:task_planner/common/extensions/time_extension.dart';

class TaskModel {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TaskCategory category;
  final TaskStatus status;
  // final DateTime createdAt = DateTime.now();

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.status,
  });

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    TaskCategory? category,
    TaskStatus? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'startTime': startTime.timeToString(),
      'endTime': endTime.timeToString(),
      'category': category.text,
      'status': status.text,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? -1,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      startTime: TimeExtension.stringToTime(map['startTime'] as String),
      endTime: TimeExtension.stringToTime(map['endTime'] as String),
      category: TaskCategory.fromMap(map['category']),
      status: TaskStatus.fromMap(map['status']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, description: $description, date: $date, startTime: $startTime, endTime: $endTime, category: $category, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.date == date &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.category == category &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        category.hashCode ^
        status.hashCode;
  }
}
