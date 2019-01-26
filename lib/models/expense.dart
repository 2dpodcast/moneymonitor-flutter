import 'package:flutter/material.dart';

class Expense {
  final String title;
  final String category;
  final String amount;
  final String createdAt;
  final String note;
  final String id;

  Expense({
    @required this.title,
    @required this.amount,
    @required this.id,
    @required this.createdAt,
    this.category = "",
    this.note = "",
  });
}
