import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/models/user.dart';
import 'package:money_monitor/models/expense.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:money_monitor/models/category.dart';
import 'package:money_monitor/widgets/expenses/expense_tile.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _widgetOptions = [
    ExpensesList(),
    Manage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    print("SSSSSSSSSSSSSSSSS");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _buildUserInfo() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        final User user = model.authenticatedUser;
        return Container(
          child: Column(
            children: <Widget>[
              Text(user.displayName),
              SizedBox(
                height: 3.0,
              ),
              Text(user.email),
            ],
          ),
        );
      },
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text("Money Monitor"),
      backgroundColor: Theme.of(context).primaryColorLight,
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
        ),
      ),
      bottom: TabBar(
        labelColor: Colors.black,
        tabs: <Widget>[
          Tab(
            text: "Create Expense",
          ),
          Tab(
            text: "All Expenses",
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          color: Colors.grey,
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }

  _buildAppBar2() {
    return AppBar(
      title: Text("Money Monitor"),
      backgroundColor: Theme.of(context).primaryColorLight,
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
        ),
      ),
      actions: <Widget>[
        IconButton(
          color: Colors.grey,
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
        appBar: _selectedIndex == 1 ? _buildAppBar() : _buildAppBar2(),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          fixedColor: Theme.of(context)
              .accentColor, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(MdiIcons.cashRegister),
              title: new Text('Expenses'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.edit),
              title: new Text('Manage Expenses'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class Manage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        Center(
          child: Text("Expense Form"),
        ),
        Center(
          child: Text("List of Expenses"),
        ),
      ],
    );
  }
}

class ExpensesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        if (model.syncStatus) {
          return Expenses();
        }
        return FutureBuilder(
          future: FirebaseDatabase.instance
              .reference()
              .child('users/${model.authenticatedUser.uid}')
              .once(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return new CircularProgressIndicator();
            }
            List<Expense> expenses = [];
            List<Category> categories = [];
            String theme;
            String currency;

            Map<dynamic, dynamic> categoryMap;
            Map<dynamic, dynamic> expenseMap = snapshot.data.value;
            expenseMap.forEach((key, value) {
              if (key == "expenses") {
                Map<dynamic, dynamic> expenseT = value;
                expenseT.forEach((key, value) {
                  expenses.add(Expense.fromJson(key, value));
                });
              }
              if (key == "preferences") {
                Map<dynamic, dynamic> pref = value;
                pref.forEach((key, value) {
                  if (key == "theme") {
                    theme = value;
                  }

                  if (key == "currency") {
                    currency = value;
                  }

                  if (key == "userCategories") {
                    categoryMap = value;
                  }
                });
              }
            });

            categoryMap.forEach((key, value) {
              categories.add(Category.fromJson(key, value));
            });

            model.setPreferences(theme, currency, categories);
            model.setExpenses(expenses);
            model.toggleSynced();
            return Expenses();
          },
        );
      },
    );
  }
}

class Expenses extends StatelessWidget {
  Future<void> _getData(User user, Function setExpenses, DateTime lastUpdate,
      BuildContext context) async {
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
      expenseMap.forEach((key, value) {
        expenses.add(Expense.fromJson(key, value));
      });
      setExpenses(expenses);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        List<Expense> expenses = model.allExpenses;
        print(model.userCurrency);
        return Container(
          child: RefreshIndicator(
            onRefresh: () => _getData(model.authenticatedUser,
                model.setExpenses, model.lastUpdate, context),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  ExpenseTile(expenses[index], index, model.expenseCategory, model.userCurrency),
              itemCount: expenses.length,
            ),
          ),
        );
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return RaisedButton(
          child: Text("Sign Out"),
          onPressed: () {
            model.logoutUser();
            FirebaseAuth.instance.signOut();
          },
        );
      },
    );
  }
}


