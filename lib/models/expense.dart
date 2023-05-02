import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category {
  food,
  bills,
  clothes,
  work,
}

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.bills: Icons.flight_takeoff,
  Category.clothes: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  // factory constructor (alternative constructor)
  // https://dart.dev/guides/language/language-tour#factory-constructors
  // https://dart.dev/language/constructors#named-constructors
  // https://dart.dev/guides/language/language-tour#constructors
  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
      : expenses = allExpense
            .where((expense) => expense.category == category)
            .toList();
  // 他の方法で書くと以下になる。
  // ExpenseBucket.forCategory(List<Expense> allExpense, this.category) {
  //   expenses = allExpense
  //       .where((expense) => expense.category.toString() == category)
  //       .toList();
  // }

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount; // sum = sum + expense.amount
    }

    return sum;
  }
}
