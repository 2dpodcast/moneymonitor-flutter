import 'package:flutter/material.dart';
import 'package:money_monitor/main.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/models/category.dart';
import 'package:random_color/random_color.dart';
import 'dart:math' as math;

class ExpenseOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExpenseOverviewState();
  }
}

class _ExpenseOverviewState extends State<ExpenseOverview> {
  String getRandomColor() {
    // String col =
    //     ((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).toString();
    // print(col);
    // return col;
    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(colorHue: ColorHue.blue);
    String c = _color
        .toString()
        .replaceFirst("Color", "")
        .replaceFirst("(", "")
        .replaceFirst(")", "")
        .replaceFirst("0xff", "");
    print("#" + c);
    return "#$c";
  }

  List<charts.Series<CategoryData, int>> _createSampleData() {
    final data = [
      new CategoryData(
          0, 56, charts.Color.fromHex(code: getRandomColor()), "Food", "£456"),
      new CategoryData(
          1, 75, charts.Color.fromHex(code: getRandomColor()), "Bills", "£1567"),
      new CategoryData(
          2, 25, charts.Color.fromHex(code: getRandomColor()), "Leisure", "£20"),
      new CategoryData(
          3, 5, charts.Color.fromHex(code: getRandomColor()), "Miscellaneous","£8"),
    ];

    return [
      new charts.Series<CategoryData, int>(
        id: 'Categories',
        domainFn: (CategoryData category, _) => category.id,
        measureFn: (CategoryData category, _) => category.count,
        colorFn: (CategoryData category, _) => category.color,
        data: data,
        labelAccessorFn: (CategoryData row, _) => '${row.name} ${row.total}',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(
                  FocusNode(),
                ),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: deviceTheme == "light"
                      ? Theme.of(context).accentColor
                      : Colors.grey[900],
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      child: SafeArea(
                        bottom: false,
                        top: true,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 30),
                              child: Text(
                                "Expense Overview",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 200,
                              child: charts.PieChart(
                                _createSampleData(),
                                animate: true,
                                defaultRenderer: new charts.ArcRendererConfig(
                                  layoutPaintOrder: 1,
                                  arcRendererDecorators: [
                                    charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.auto,
                                      leaderLineStyleSpec: charts.ArcLabelLeaderLineStyleSpec(color: charts.Color.white, length: 20, thickness: 1),
                                      insideLabelStyleSpec:
                                          charts.TextStyleSpec(
                                        color: charts.Color.white,
                                        fontSize: 15,
                                      ),
                                      outsideLabelStyleSpec:
                                          charts.TextStyleSpec(
                                        color: charts.Color.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategoryData {
  final int id;
  final int count;
  final charts.Color color;
  final String name;
  final String total;

  CategoryData(this.id, this.count, this.color, this.name, this.total);
}
