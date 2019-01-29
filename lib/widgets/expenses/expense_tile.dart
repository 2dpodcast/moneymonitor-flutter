import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_monitor/models/category.dart';

import 'package:money_monitor/models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final int index;
  final String currency;
  final Function expenseCategory;
  ExpenseTile(this.expense, this.index, this.expenseCategory, this.currency);

  _buildModelSheet(BuildContext context, Category category) {
    return Container(
      height: expense.note.split("\n").length >= 3 || expense.note.length > 20
          ? (MediaQuery.of(context).size.height) / 2
          : (MediaQuery.of(context).size.height) / 3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Icon(
            category.icon != null ? category.icon : MdiIcons.cashRegister,
            color: Theme.of(context).accentColor,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 25.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Text(
              expense.title,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.0,
              vertical: 2.5,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              currency +
                  (double.parse(expense.amount) / 1000).toStringAsFixed(2),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          expense.note != ""
              ? Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      expense.note,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      maxLines: 8,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = expenseCategory(expense.category);
    return Column(
      children: <Widget>[
        Card(
                  child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildModelSheet(context, category);
                  });
            },
            splashColor: Colors.blue[100],
            child: ListTile(
              leading: Icon(
                category.icon != null ? category.icon : MdiIcons.cashRegister,
                color: Colors.blueAccent,
              ),
              title: Text(
                expense.title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(currency +
                    (double.parse(expense.amount) / 100).toStringAsFixed(2)),
              ),
              trailing: Text(
                DateTime.fromMillisecondsSinceEpoch(int.parse(expense.createdAt))
                    .toIso8601String()
                    .substring(0, 10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
