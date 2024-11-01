import 'package:flutter/material.dart';

class Todo {
  String id;
  String name;
  Color color;
  DateTime createdAt;
  DateTime? updatedAt;

  Todo({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    this.updatedAt,
  });
}