import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_datepicker.dart';
import 'package:flutter/material.dart';

import './adaptative_textfield.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm(this.onSubmit);

  final void Function(String, double, DateTime) onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();
  DateTime? _selectedDate;

  _onSubmit() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              AdaptativeTextfield(
                  controller: titleController,
                  onSubmit: (value) => _onSubmit(),
                  label: 'Título'),
              AdaptativeTextfield(
                  controller: valueController,
                  onSubmit: (value) => _onSubmit(),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  label: 'Valor (R\$)'),
              AdaptativeDatepicker(
                  selectedDate: _selectedDate ?? DateTime.now(),
                  onDateChanged: (newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AdaptativeButton(
                      label: "Nova Transação", onPressed: _onSubmit),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
