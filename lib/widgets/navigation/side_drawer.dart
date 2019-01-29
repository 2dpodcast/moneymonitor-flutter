import 'package:flutter/material.dart';
import 'package:money_monitor/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/models/category.dart';

class SideDrawer extends StatefulWidget {
  final Function updateCategoryFilter;
  final Function updateSort;
  final String sortByVal;
  final List<Category> allCategories;
  SideDrawer(this.updateCategoryFilter, this.updateSort, this.sortByVal, this.allCategories);
  @override
  State<StatefulWidget> createState() {
    return _SideDrawerState();
  }
}

class _SideDrawerState extends State<SideDrawer> {
  String _sortByValue;
  List<Category> categories;
  bool clearAllButton = true;

  @override
  void initState() {
    _sortByValue = widget.sortByVal;
    categories = widget.allCategories;
    super.initState();
  }

  void _changeSortValue(String value) {
    setState(() {
      _sortByValue = value;
    });
  }

  final GlobalKey key = GlobalKey();

  @override
  void dispose() {
    widget.updateCategoryFilter(categories);
    widget.updateSort(_sortByValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return Drawer(
          key: key,
          child: Column(
            children: <Widget>[
              Container(
                height: 120.0,
                child: DrawerHeader(
                  child: Row(
                    children: <Widget>[
                      // TODO Add Logo
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Money Monitor",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              ExpansionTile(
                initiallyExpanded: true,
                title: Text("Sort By"),
                leading: Icon(
                  (Icons.sort),
                ),
                children: <Widget>[
                  RadioListTile(
                    onChanged: _changeSortValue,
                    groupValue: _sortByValue,
                    value: "date",
                    title: Text("Date"),
                  ),
                  RadioListTile(
                    onChanged: _changeSortValue,
                    groupValue: _sortByValue,
                    value: "amount",
                    title: Text("Amount"),
                  ),
                  RadioListTile(
                    onChanged: _changeSortValue,
                    groupValue: _sortByValue,
                    value: "category",
                    title: Text("Category"),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 15.0,
                  ),
                  Icon(Icons.filter_list),
                  SizedBox(
                    width: 33.0,
                  ),
                  Text("Filter Categories"),
                  SizedBox(
                    width: 39.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        categories.forEach((category) {
                          category.updateVisibility(true);
                        });
                      });
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        categories.forEach((category) {
                          category.updateVisibility(false);
                        });
                      });
                    },
                    icon: Icon(Icons.clear),
                  ),
                ],
              ),
              Container(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        onChanged: (value) {
                          setState(() {
                            categories[index].updateVisibility(value);
                          });
                        },
                        value: categories[index].show,
                        title: Text(categories[index].name),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
