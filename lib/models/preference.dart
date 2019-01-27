import 'package:money_monitor/models/category.dart';

class Preferences {
  final String theme;
  final String currency;
  final List<Category> categories;


  Preferences(this.theme, this.currency, this.categories);

}