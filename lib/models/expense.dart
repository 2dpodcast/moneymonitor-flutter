import 'package:flutter/material.dart';

class Expense {
  String title;
  String category;
  String amount;
  String createdAt;
  String note;
  String key;

  Expense({
    @required this.title,
    @required this.amount,
    @required this.key,
    @required this.createdAt,
    this.category = "",
    this.note = "",
  });

  Expense.fromJson(this.key, Map data) {
    title = data['title'];
    category = data['category'];
    amount = data['amount'].toString();
    createdAt = data['createdAt'].toString();
    note = data['note'];
  }
}
