import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/widges/expenses_list/expense_item.dart';

import '../../models/expense.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  // const ExpensesList({
  //   Key? key,
  //   required this.expenses,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // たくさんのウィジェットを表示する場合は、ListView.builder()を使うと良い
    // ListViewは、スクロール可能なウィジェットを表示するためのウィジェット
    return ListView.builder(
      // ※linear array 和訳: 線形配列
      // ※on demand 和訳：要求に応じて
      // itemBuilderは、ListView.builder()の中で何度も呼び出される
      itemCount: expenses.length,
      // Dismissibleは、スワイプで削除できるようにするためのウィジェット
      // DismissibleのValueKeyは、一意のキーを設定するためのもの
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
          // 直接指定も可能だが、Theme.of(context).margin.horizontalを指定することで
          // MaterialApp.theme.cardTheme.margin.horizontalから値を入れることで、グローバル管理が可能になる
          // margin: const EdgeInsets.symmetric(
          //   horizontal: 50,
          //   vertical: 4,
          // ),
        ),
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(
          expense: expenses[index],
        ),
      ),
    );
  }
}
