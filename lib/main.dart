import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './components/transaction_list.dart';
import './models/transaction.dart';
import 'dart:math';
import 'dart:io';
import './components/chart.dart';

void main(List<String> args) {
  runApp(ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // faz o dispositivo funcionar somente em uma orientacao
    // import necessario import 'package:flutter/services.dart';

    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        fontFamily: 'Quicksand',
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(
              fontSize: 18,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(id: "t1", title: "tenis", value: 120, date: DateTime.now()),
    Transaction(id: "t2", title: "tenis", value: 120, date: DateTime.now()),
    Transaction(id: "t3", title: "tenis", value: 120, date: DateTime.now()),
    Transaction(id: "t4", title: "tenis", value: 120, date: DateTime.now()),
    Transaction(id: "t5", title: "tenis", value: 120, date: DateTime.now()),
    Transaction(id: "t6", title: "tenis", value: 120, date: DateTime.now()),
    Transaction(id: "t7", title: "tenis", value: 120, date: DateTime.now()),
    Transaction(id: "t8", title: "tenis", value: 120, date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(
        days: 7,
      )));
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) {
        return transaction.id == id;
      });
    });
  }

  void _addTransaction(String title, double value, DateTime data) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: data);
    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _openTransactionModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    Widget _getIconButton(IconData icon, Function() fn) {
      return Platform.isIOS
          ? GestureDetector(
              onTap: fn,
              child: Icon(icon),
            )
          : IconButton(icon: Icon(icon), onPressed: fn);
    }

    var actions = [
      if (isLandscape)
        _getIconButton(
          _showChart ? iconList : chartList,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(Platform.isIOS ? CupertinoIcons.add : Icons.add, () {
        _openTransactionModal(context);
      })
    ];

    final appBar = AppBar(
      title: Text(
        "Despesas Pessoais",
        style: TextStyle(fontFamily: "OpenSans"),
      ),
      actions: actions,
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // if (isLandscape)
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text("Exibir grafico"),
          //       Switch.adaptive(
          //           activeColor: Theme.of(context).primaryColor,
          //           value: _showChart,
          //           onChanged: (value) {
          //             setState(() {
          //               _showChart = value;
          //             });
          //           }),
          //     ],
          //   ),
          if (_showChart || !isLandscape)
            Container(
                height: availableHeight * (isLandscape ? 0.8 : 0.25),
                child: Chart(recentTransactions)),
          if (!_showChart || !isLandscape)
            Container(
                height: availableHeight * (isLandscape ? 1 : 0.75),
                child: TransactionList(_transactions, _deleteTransaction)),
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyPage,
            navigationBar: CupertinoNavigationBar(
              middle: Text("Despesas Pessoais"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openTransactionModal(context),
                    child: Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
