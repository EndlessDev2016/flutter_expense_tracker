import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models/expense.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // 変数_enteredTitleとTextEditingController()は、同じことをしている
  // 違いとしては、_enteredTitleは、Stateが破棄されるときに値が破棄される
  // たくさんの変数を管理する場合は、TextEditingController()を使うと良い
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.clothes;

  void _presendDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    // .then((value) => )
    // print(pickedDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      // iOSの場合は、CupertinoAlertDialogを使う
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a title, amount and date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // show error message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a title, amount and date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpanseData() {
    // tryParse()は、Stringをdoubleに変換する
    // string文字列がdoubleに変換できない場合は、nullを返す(e.g. 'abc'の場合)
    final enteredAdmount = double.tryParse(_amountController.text);
    final amountIsInvalud = enteredAdmount == null || enteredAdmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalud ||
        _selectedDate == null) {
      _showDialog();
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAdmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    // _titleController.dispose()は、Stateが破棄されるときに呼び出される
    // ※不要なメモリを解放するために、Stateが破棄されるときに呼び出される
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // void _saveTitleInput(String inputValue) {
  //   _titleController.text = inputValue;
  // }

  // var _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        print('minHeight: ${constraints.minHeight}');
        print('maxHeight: ${constraints.maxHeight}');
        print('minWidth: ${constraints.minWidth}');
        print('maxWidth: ${constraints.maxWidth}');

        final width = constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 26, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            // onChanged: _saveTitleInput,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      // onChanged: _saveTitleInput,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width >= 600)
                    Row(children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value == null) return;
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Row(
                          // MainAxisAlignment.endは、cssでいうところのjustify-content: flex-end;と同じ
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No Date Selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presendDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ])
                  else
                    Row(
                      children: [
                        // Expandedを設定しないとエラーになる。
                        // InputDecoratorは通常、TextFieldで作成されます。例えば、InputDecoratorがRowに含まれている場合、その幅は制約される必要があります。幅が制約されていないと、InputDecoratorが無限に拡張されてしまい、このエラーが発生します。
                        // An InputDecorator, which is typically created by a TextField, cannot have an unbounded width.
                        // This happens when the parent widget does not provide a finite width constraint.
                        // For example, if the InputDecorator is contained by a Row, then its width must be constrained.
                        // An Expanded widget or a SizedBox can be used to constrain the width of the InputDecorator or the TextField that contains it.
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Expandedは、Rowの中で、TextFieldの横幅を最大限に広げるためのもの
                        // Expandedを入れないと、TextFieldの横幅が狭くなってしまう
                        Expanded(
                          child: Row(
                            // MainAxisAlignment.endは、cssでいうところのjustify-content: flex-end;と同じ
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No Date Selected'
                                    : formatter.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presendDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value == null) return;
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            // Navigatorは、画面遷移を管理するクラス
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: _submitExpanseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
