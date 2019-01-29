import 'package:money_monitor/models/category.dart';

class Preferences {
  final String theme;
  final String currency;
  List<Category> categories;


  Preferences(this.theme, this.currency, this.categories);

  void set updateCategories(List<Category> newCategories) {
    categories = newCategories;
  }

}