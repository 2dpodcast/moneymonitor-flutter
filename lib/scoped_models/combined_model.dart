import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/models/user.dart';
import 'package:money_monitor/models/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:money_monitor/pages/home.dart';

mixin CombinedModel on Model {
  User _authUser;
  List<Expense> _expenses = [];
  bool synced = false;
  DateTime _lastUpdated;

  bool get syncStatus {
    return synced;
  }

  DateTime get lastUpdate {
    return _lastUpdated;
  }

  void toggleSynced() {
    synced = !synced;
    notifyListeners();
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
    toggleSynced();
  }
}
