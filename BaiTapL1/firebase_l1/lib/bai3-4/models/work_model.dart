import 'package:flutter/material.dart';

class WorkModel {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  String userId;
  Color backgroundColor;

  WorkModel({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.userId,
    this.backgroundColor = Colors.white,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'userId': userId,
      'backgroundColor': backgroundColor.value
    };
  }

  factory WorkModel.fromMap(Map<String, dynamic> map) {
    return WorkModel(
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'],
      userId: map['userId'],
      backgroundColor: Color(map['backgroundColor'] ?? Colors.white.value),
    );
  }
}