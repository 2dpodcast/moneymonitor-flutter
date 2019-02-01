import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/models/category.dart';
import 'package:money_monitor/main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_monitor/widgets/navigation/side_drawer.dart';
import 'package:money_monitor/widgets/expenses_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_monitor/pages/manage_expenses.dart';

List<Category> categories;

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
    ManageExpenses(),
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
    return Scaffold(
      backgroundColor:
          deviceTheme == "light" ? Colors.grey[100] : Colors.grey[900],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              elevation: 5.0,
              backgroundColor: deviceTheme == "light"
                  ? Colors.white
                  : Theme.of(context).primaryColorLight,
              child: Icon(
                Icons.add,
                color: Theme.of(context).accentColor,
                size: 40,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            )
          : Container(
              width: 0,
              height: 0,
            ),
      drawer: _buildDrawer(),
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
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Sign Out"),
              onPressed: () {
                model.logoutUser();
                FirebaseAuth.instance.signOut();
                restartApp();
              },
            ),
            RaisedButton(
              child: Text("Light Theme"),
              onPressed: () async {
                model.updateTheme("light");
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.setString("theme", "light");
                restartApp();
              },
            ),
            RaisedButton(
              child: Text("Dark Theme"),
              onPressed: () async {
                model.updateTheme("dark");
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.setString("theme", "dark");
                restartApp();
              },
            ),
          ],
        );
      },
    );
  }
}
