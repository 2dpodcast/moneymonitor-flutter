import 'package:flutter/material.dart';
import 'package:money_monitor/main.dart';

class ExpenseForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExpenseFormState();
  }
}

class _ExpenseFormState extends State<ExpenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    "title": null,
    "amount": null,
    "createdAt": null,
    "note": null,
    "category": null,
  };

  Widget _buildHeader() {
    return Text(
      "Add Expense",
      style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.w700,
        color: deviceTheme == "light" ? Colors.grey[800] : Colors.white,
        wordSpacing: 2.0,
      ),
    );
  }

  _buildTitleField() {
    return Card(
      clipBehavior: Clip.none,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30.0),
          ),
          hintText: "Title",
          hintStyle: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          hasFloatingPlaceholder: true,
          filled: true,
          fillColor: deviceTheme == "light" ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  _buildAmountField() {
    return Card(
      clipBehavior: Clip.none,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30.0),
          ),
          hintText: "Amount",
          hintStyle: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          hasFloatingPlaceholder: true,
          filled: true,
          fillColor: deviceTheme == "light" ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              _buildHeader(),
              SizedBox(
                height: 10,
              ),
              _buildTitleField(),
              SizedBox(
                height: 10,
              ),
              _buildAmountField(),
            ],
          ),
        ),
      ),
    );
  }
}
