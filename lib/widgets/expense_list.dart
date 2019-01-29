import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:money_monitor/models/expense.dart';
import 'package:money_monitor/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/widgets/expenses/expense_tile.dart';

class ExpenseList extends StatelessWidget {
  Future<void> _getData(User user, Function setExpenses, DateTime lastUpdate,
      BuildContext context, Function gotNoData) async {
    if (lastUpdate == null) {
      DataSnapshot snapshot = await FirebaseDatabase.instance
          .reference()
          .child('users/${user.uid}/expenses')
          .once();

      List<Expense> expenses = [];
      Map<dynamic, dynamic> expenseMap = snapshot.value;
      if (expenseMap == null) {
        return gotNoData();
      }
      expenseMap.forEach((key, value) {
        expenses.add(Expense.fromJson(key, value));
      });
      setExpenses(expenses);
      return ('');
    }
    Duration difference = DateTime.now().difference(lastUpdate);
    if (difference.inMinutes < 10) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blueAccent,
        content: Text(
            "Next update available in ${10 - difference.inMinutes} minutes."),
        action: SnackBarAction(
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
          },
          label: "Dismiss",
          textColor: Colors.white,
        ),
      ));
    } else {
      DataSnapshot snapshot = await FirebaseDatabase.instance
          .reference()
          .child('users/${user.uid}/expenses')
          .once();

      List<Expense> expenses = [];
      Map<dynamic, dynamic> expenseMap = snapshot.value;
      if (expenseMap == null) {
        return gotNoData();
      }
      expenseMap.forEach((key, value) {
        expenses.add(Expense.fromJson(key, value));
      });
      setExpenses(expenses);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        List<Expense> expenses = model.filteredExpenses;
        double total = 0;
        expenses.forEach((expense) {
          double price = double.parse(expense.amount) / 100;
          total = total + price;
        });
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.white,
              title: Text(
                "Money Monitor",
                style: TextStyle(color: Colors.white),
              ),
              pinned: false,
              floating: false,
              expandedHeight: 220.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.blueAccent,
                  padding: EdgeInsets.only(left: 30, right: 30, top: 80),
                  child: Column(
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Text(
                            expenses.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "expenses totalling",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "${model.userCurrency}${total.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Currently sorting by ${model.sortBy}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () => _getData(
                                model.authenticatedUser,
                                model.setExpenses,
                                model.lastUpdate,
                                context,
                                model.gotNoData),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  "Refresh",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ExpenseTile(expenses[index], index,
                      model.expenseCategory, model.userCurrency);
                },
                childCount: expenses.length,
              ),
            ),
          ],
        );
      },
    );
    ;
  }
}
