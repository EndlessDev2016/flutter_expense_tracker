import 'package:flutter/material.dart';

import 'package:flutter_expense_tracker/widges/expenses_list/expenses_list.dart';
import 'package:flutter_expense_tracker/widges/new_expense.dart';
import '../models/expense.dart';
import 'chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Groceries',
      amount: 16.53,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: 'New Shirt',
      amount: 32.99,
      date: DateTime.now(),
      category: Category.clothes,
    ),
    // Expense(
    //   title: 'New TV',
    //   amount: 499.99,
    //   date: DateTime.now(),
    //   category: Category.entertainment,
    // ),
    Expense(
      title: 'Rent',
      amount: 1200.00,
      date: DateTime.now(),
      category: Category.bills,
    ),
    // Expense(
    //   title: 'New Desk',
    //   amount: 199.99,
    //   date: DateTime.now(),
    //   category: Category.other,
    // ),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _openAddExpenseOverlay() {
    // showModalBottomSheet()は、画面下部から上にスライドして表示される
    // showで始まるfunctionの種類は、たくさんあるので、以下のfunctionページを参照
    // https://api.flutter.dev/flutter/material/material-library.html
    // https://api.flutter.dev/flutter/material/material-library.html#functions
    // このcontextは、Stateから提供されてる。
    // つまり、このcontextは、default (built-in)として使える。
    showModalBottomSheet(
      useSafeArea: true, // 画面下部の余白を使うかどうか
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense);
      },
    );
  }

  void _removeExpense(Expense exepnse) {
    final expenseIndex = _registeredExpenses.indexOf(exepnse);

    setState(() {
      _registeredExpenses.remove(exepnse);
    });
    // Removes all the snackBars currently in queue by clearing the queue and running normal exit animation on the current snackBar.
    // 和訳：キューにあるすべてのsnackBarを削除して、キューをクリアし、現在のsnackBarで通常の終了アニメーションを実行します。
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, exepnse);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // constは、javascriptのconstと同じで、変更不可。
    // finalは、javascriptのconstと同じで、変更可能。
    // finalの場合、少し違い点としては、初期化時に値を代入しなくても良い。
    // copilotの自動補完機能を使う場合、右側にコメントがでくるようになる。
    final height = MediaQuery.of(context).size.height; // 画面の高さを取得
    final width = MediaQuery.of(context).size.width; // 画面の幅を取得
    print('width: $width');
    print('height: $height');

    Widget mainContent = const Center(
      child: Text('No expenses added yet! (><)'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
        //appBarのactionsは、右側に表示される
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(
                  expenses: _registeredExpenses,
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                // Expandedを使わないと以下のエラになる (要は、無限大に広がるサイズを制限をかけるために、Expandedを使う)
                /// The relevant error-causing widget was
                /// Row
                /// expense_item.dart:37
                /// The overflowing RenderFlex has an orientation of Axis.horizontal.
                /// The edge of the RenderFlex that is overflowing has been marked in the rendering with a yellow and black striped pattern. This is usually caused by the contents being too big for the RenderFlex.
                /// Consider applying a flex factor (e.g. using an Expanded widget) to force the children of the RenderFlex to fit within the available space instead of being sized to their natural size.
                /// This is considered an error condition because it indicates that there is content that cannot be seen. If the content is legitimately bigger than the available space, consider clipping it with a ClipRect widget before putting it in the flex, or using a scrollable container rather than a Flex, like a ListView.
                // 理由としては、RowのChart widthは、double.infinityになっている。
                // Expandedは、cssのflex-grow: 1;と同じ。
                Expanded(
                  child: Chart(
                    expenses: _registeredExpenses,
                  ),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
