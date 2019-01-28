import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/models/user.dart';
import 'package:money_monitor/models/expense.dart';
import 'package:money_monitor/models/preference.dart';
import 'package:money_monitor/models/category.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


final List<Category> defaultCategories = [
  Category("1", "Bills", MdiIcons.fileDocument),
  Category("2", "Rent", Icons.home),
  Category("3", "Food", MdiIcons.foodForkDrink),
  Category("4", "Leisure", MdiIcons.shopping),
  Category("5", "Debt", Icons.monetization_on),
];

mixin CombinedModel on Model {
  User _authUser;
  List<Expense> _expenses = [];
  Preferences _userPreferences;
  bool _synced = false;
  DateTime _lastUpdated;

  bool get syncStatus {
    return _synced;
  }

  DateTime get lastUpdate {
    return _lastUpdated;
  }

  String get userTheme {
    return _userPreferences.theme;
  }

  String get userCurrency {
    return _userPreferences.currency;
  }

  Category expenseCategory(String categoryId) {
    Category cat = _userPreferences.categories.firstWhere(
        (category) => category.id == categoryId,
        orElse: () => Category("0", ""));
    return cat;
  }

  void toggleSynced() {
    _synced = !_synced;
  }

  void gotNoData() {
    _expenses = [];
  }
  void setPreferences(
      String theme, String currency, List<Category> categories) {
    String actualCurrency = "";
    if (currency == "en-gb") {
      actualCurrency = '£';
    } else if (currency == 'fr') {
      actualCurrency = '€';
    } else {
      actualCurrency = '\$';
    }

    List<Category> allCategories = List.from(defaultCategories)..addAll(categories);
    _userPreferences = Preferences(theme, actualCurrency, allCategories);
  }

  void loginUser(displayName, uid, email, photoUrl) {
    _authUser = User(
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      uid: uid,
    );
  }
}

mixin ExpensesModel on CombinedModel {
  List<Expense> get allExpenses {
    return List.from(_expenses);
  }

  List<Expense> get filteredExpenses {
    // TODO add filtering logic
    return [];
  }

  void setExpenses(List<Expense> expenses) {
    _expenses = expenses;
    _lastUpdated = DateTime.now();
    notifyListeners();
  }
}

mixin UserModel on CombinedModel {
  User get authenticatedUser {
    return _authUser;
  }

  void logoutUser() {
    _authUser = null;
    _lastUpdated = null;
    _expenses = [];
    _userPreferences = null;
    toggleSynced();
    notifyListeners();
  }
}
