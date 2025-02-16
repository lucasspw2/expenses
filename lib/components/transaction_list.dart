import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) removeTransaction;

  TransactionList(this.transactions, this.removeTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, contrains) {
            return Column(
              children: [
                SizedBox(
                  height: contrains.maxHeight * 0.05,
                ),
                Container(
                  height: contrains.maxHeight * 0.1,
                  child: Text("Nenhuma transação cadastrada!",
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                SizedBox(
                  height: contrains.maxHeight * 0.05,
                ),
                SizedBox(
                  height: contrains.maxHeight * 0.5,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final transaction = transactions[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple[400],
                    foregroundColor: Colors.white,
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: FittedBox(child: Text("R\$${transaction.value}")),
                    ),
                  ),
                  title: Text(
                    transaction.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle:
                      Text(DateFormat("d MMM y").format(transaction.date)),
                  trailing: MediaQuery.of(context).size.width > 480
                      ? ElevatedButton.icon(
                          onPressed: () => removeTransaction(transaction.id),
                          label: Text("Excluir"),
                          icon: Icon(Icons.delete),
                        )
                      : IconButton(
                          onPressed: () => removeTransaction(transaction.id),
                          icon: const Icon(Icons.delete),
                          style:
                              IconButton.styleFrom(foregroundColor: Colors.red),
                        ),
                ),
              );
            });
  }
}
