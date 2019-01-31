import 'package:flutter/material.dart';
import 'package:money_monitor/main.dart';
import 'package:money_monitor/widgets/expenses/create_expense.dart';

class ManageExpenses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManageExpensesState();
  }
}

class _ManageExpensesState extends State<ManageExpenses>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: deviceTheme == "light"
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColorLight,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Theme.of(context).primaryColorLight,
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: SafeArea(
                  bottom: false,
                  top: true,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Manage",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 5.0,),
                          Text(
                            "expenses",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            forceElevated: innerBoxIsScrolled,
            bottom: new TabBar(
              tabs: <Tab>[
                new Tab(text: "Create"),
                new Tab(text: "All Expenses"),
              ],
              controller: _tabController,
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ExpenseForm(),
          Center(
            child: Text("List of Expenses"),
          ),
        ],
      ),
    );
  }
}
