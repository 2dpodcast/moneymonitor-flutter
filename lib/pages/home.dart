import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/models/category.dart';
import 'package:money_monitor/main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_monitor/widgets/navigation/side_drawer.dart';
import 'package:money_monitor/widgets/expenses_builder.dart';

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
      child: SafeArea(
              child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {},
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
