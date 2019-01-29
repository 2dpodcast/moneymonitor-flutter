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
  bool _synced = false;
  DateTime _lastUpdated;
  String _newName;
  Preferences _userPreferences;
  String _sortBy = "date";

  bool get syncStatus {
    return _synced;
  }

  String get newName {
    return _newName;
  }

  DateTime get lastUpdate {
    return _lastUpdated;
  }

  void toggleSynced() {
    _synced = !_synced;
  }

  void gotNoData() {
    _expenses = [];
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

mixin FilterModel on CombinedModel {
  Category expenseCategory(String categoryId) {
    Category cat = _userPreferences.categories.firstWhere(
        (category) => category.id == categoryId,
        orElse: () => Category("0", ""));
    return cat;
  }

  List<Category> get allCategories {
    return _userPreferences.categories;
  }

  void updateCategoryFilter(List<Category> newCategories) {
    _userPreferences.categories = newCategories;
    notifyListeners();
  }

  void updateSort(String value) {
    _sortBy = value;
    notifyListeners();
  }

  String get sortBy {
    return _sortBy;
  }

  String get userTheme {
    return _userPreferences.theme;
  }

  String get userCurrency {
    return _userPreferences.currency;
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

    List<Category> allCategories = List.from(defaultCategories)
      ..addAll(categories);
    _userPreferences = Preferences(theme, actualCurrency, allCategories);
  }
}

mixin ExpensesModel on CombinedModel {
  List<Expense> get allExpenses {
    return List.from(_expenses);
  }

  List<Expense> get filteredExpenses {
    List<Expense> output = [];

    _expenses.forEach(
      (expense) {
        Category category = _userPreferences.categories.firstWhere(
            (category) => category.id == expense.category,
            orElse: () => Category("0", "empty"));
        if (category.show || category.name == "empty") {
          output.add(expense);
        }
      },
    );

    output.sort(
      (a, b) {
        if (_sortBy == "date") {
          return b.createdAt.compareTo(a.createdAt);
        } else if (_sortBy == "amount") {
          return double.parse(a.amount) < double.parse(b.amount) ? 1 : -1;
        } else if (_sortBy == "category") {
          return a.category.compareTo(b.category);
        }
      },
    );

    return output;
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

  void setDisplayName(String name) {
    _newName = name;
  }

  void updateUserName() {
    _authUser = User(
        displayName: _newName,
        uid: _authUser.uid,
        photoUrl: _authUser.photoUrl,
        email: _authUser.email);
    _newName = null;
  }

  void logoutUser() {
    _authUser = null;
    _lastUpdated = null;
    _expenses = [];
    toggleSynced();
    notifyListeners();
  }
}
