import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/models/user.dart';
import 'package:money_monitor/models/expense.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:money_monitor/models/category.dart';
import 'package:money_monitor/main.dart';
import 'package:money_monitor/widgets/expenses/expense_tile.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_monitor/widgets/navigation/side_drawer.dart';

List<Category> categories;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _formData = "";
  int _selectedIndex = 0;
  bool _showSearch = false;
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
      _showSearch = false;
      _selectedIndex = index;
    });
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
      iconTheme: new IconThemeData(color: Colors.grey),
      automaticallyImplyLeading: !_showSearch,
      title: Form(
        key: _formKey,
        child: _showSearch
            ? TextFormField(
                onSaved: (value) => _formData = value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16.0, left: 10.0),
                  hintText: "Search",
                  suffixIcon: IconButton(
                    onPressed: () {
                      _formKey.currentState.save();

                      if (_formData.trim().length > 0) {
                        _formKey.currentState.reset();
                      } else {
                        _formKey.currentState.reset();
                        // TODO Reset search filter
                        setState(() {
                          _showSearch = false;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 20.0,
                    ),
                  ),
                ),
              )
            : Text("Money Monitor"),
      ),
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
          icon: Icon(_showSearch ? Icons.arrow_forward : Icons.search),
          onPressed: () {
            if (!_showSearch) {
              setState(() {
                _showSearch = !_showSearch;
              });
            } else {
              // Search
            }
          },
        ),
      ],
    );
  }

  _buildDrawer() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        categories = model.allCategories;
        return SideDrawer(model.updateCategoryFilter, model.updateSort,
            model.sortBy, model.allCategories);
      },
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
        drawer: _buildDrawer(),
        appBar: _selectedIndex == 1 ? _buildAppBar() : _buildAppBar2(),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
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
              title: new Text('Manage'),
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
            if (expenseMap != null) {
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

              if (categoryMap != null) {
                categoryMap.forEach((key, value) {
                  categories.add(Category.fromJson(key, value));
                });
              }

              model.setPreferences(theme, currency, categories);
              if (expenses.length > 0) {
                model.setExpenses(expenses);
              }
              model.toggleSynced();
            } else {
              model.gotNoData();
            }
            return Expenses();
          },
        );
      },
    );
  }
}

class Expenses extends StatelessWidget {
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
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        List<Expense> expenses = model.filteredExpenses;

        return Container(
          child: RefreshIndicator(
            onRefresh: () => _getData(model.authenticatedUser,
                model.setExpenses, model.lastUpdate, context, model.gotNoData),
            child: expenses.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text("No Expenses"),
                      ),
                      RaisedButton(
                        child: Text("Refresh"),
                        onPressed: () => _getData(
                            model.authenticatedUser,
                            model.setExpenses,
                            model.lastUpdate,
                            context,
                            model.gotNoData),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return ExpenseTile(expenses[index], index,
                          model.expenseCategory, model.userCurrency);
                    },
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
            runApp(MyApp());
          },
        );
      },
    );
  }
}
