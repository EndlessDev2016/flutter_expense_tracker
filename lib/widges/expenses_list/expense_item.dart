import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;

  const ExpenseItem({
    super.key,
    required this.expense,
  });

  /// Card Item Widget
  /// @description - This is the widget that displays the expense item in the list.
  /// 和訳 - これは、リスト内のexpense itemを表示するウィジェットです。
  @override
  Widget build(BuildContext context) {
    // ここで、Cardを使うと、ListView.builder()の中で何度も呼び出される
    return Card(
      child: Padding(
        // EdgeInsets.symmetricは、上下と左右のpaddingを同じ値にするためのもの(cssのpadding: 16px 20px; みたいな感じ)
        // EdgeInsets.edgeは、上下と左右のpaddingを別々に設定するためのもの(cssのpadding: 10px 15px 20px 25px; みたいな感じ)
        // EdgeInsets.allは、上下と左右のpaddingを同じ値にするためのもの(cssのpadding: 10px; みたいな感じ)
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 8),
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );

    // return Card(
    //   child: Row(
    //     children: [
    //       Container(
    //         margin: const EdgeInsets.symmetric(
    //           vertical: 10,
    //           horizontal: 15,
    //         ),
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //             color: Theme.of(context).primaryColor,
    //             width: 2,
    //           ),
    //         ),
    //         padding: const EdgeInsets.all(10),
    //         child: Text(
    //           '\$${expense.amount}',
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 20,
    //             color: Theme.of(context).primaryColor,
    //           ),
    //         ),
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             expense.title,
    //             style: Theme.of(context).textTheme.headline6,
    //           ),
    //           Text(
    //             DateFormat.yMMMd().format(expense.date),
    //             style: const TextStyle(
    //               color: Colors.grey,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
