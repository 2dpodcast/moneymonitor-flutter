import 'package:flutter/material.dart';
import 'package:money_monitor/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/models/category.dart';

class ExpenseForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExpenseFormState();
  }
}

class _ExpenseFormState extends State<ExpenseForm> {
  String _categoryVal = '0';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "title": null,
    "amount": null,
    "createdAt": DateTime.now().millisecondsSinceEpoch,
    "note": "",
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
          prefix: Text("  "),
          filled: true,
          fillColor: deviceTheme == "light" ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  _buildAmountField(String currency) {
    return Card(
      clipBehavior: Clip.none,
      elevation: 2.0,
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
          prefix: Text("$currency "),
          hasFloatingPlaceholder: true,
          filled: true,
          fillColor: deviceTheme == "light" ? Colors.white : Colors.grey[600],
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        autovalidate: true,
        validator: (String value) {
          if (!RegExp(
                  r"^\-?\(?\$?\s*\-?\s*\(?(((\d{1,3}((\,\d{3})*|\d*))?(\.\d{1,4})?)|((\d{1,3}((\,\d{3})*|\d*))(\.\d{0,4})?))\)?$")
              .hasMatch(value)) {
            return "Please enter a valid amount\n";
          }
        },
      ),
    );
  }

  String findCategoryName(String id, List<Category> categories) {
    Category cat = categories.firstWhere((category) => category.id == id);
    return cat.name;
  }

  _buildCategorySelector(List<Category> categories) {
    List<Category> output = [Category("0", "None")];
    output.addAll(categories);

    return Card(
      clipBehavior: Clip.none,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: MaterialButton(
        minWidth: 200,
        child: Text(
          _categoryVal == null || _categoryVal == "0"
              ? "Select Category (optional)"
              : findCategoryName(_categoryVal, categories),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 300,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: output.length,
                        itemBuilder: (BuildContext context, int index) {
                          return RadioListTile(
                            activeColor: Theme.of(context).accentColor,
                            groupValue: _categoryVal,
                            value: output[index].id,
                            title: Text(output[index].name),
                            onChanged: (String value) {
                              Navigator.pop(context);
                              _categoryVal = value;
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  _showDateOption() {
    return Card(
      clipBehavior: Clip.none,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: MaterialButton(
        minWidth: 100,
        child: Text("Date"),
        onPressed: () async {
          DateTime date = await showDatePicker(
            context: context,
            initialDate:
                DateTime.fromMillisecondsSinceEpoch(_formData["createdAt"]),
            firstDate: DateTime(2000),
            lastDate: DateTime(3000),
          );
          if (date != null) {
            _formData["createdAt"] = date.millisecondsSinceEpoch;
          }
        },
      ),
    );
  }

  _buildNoteField() {
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
          hintText: "Note",
          hintStyle: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          hasFloatingPlaceholder: true,
          prefix: Text("  "),
          filled: true,
          fillColor: deviceTheme == "light" ? Colors.white : Colors.grey[600],
        ),
        maxLines: 5,
      ),
    );
  }

  _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: deviceTheme == "light"
            ? Theme.of(context).accentColor
            : Colors.grey[800],
      ),
      child: MaterialButton(
        onPressed: () {
          // TODO Save Data to firebase then set locally
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Save Expense",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
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
                    _buildAmountField(model.userCurrency),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildCategorySelector(model.allCategories),
                        SizedBox(
                          width: 15.0,
                        ),
                        _showDateOption(),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildNoteField(),
                    SizedBox(
                      height: 10,
                    ),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
