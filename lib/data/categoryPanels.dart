import 'package:flutter/material.dart';

class CategoryPanels extends ChangeNotifier {
  List<CategoryPanel> _categoryPanels = [
    CategoryPanel(categoryPicked: 'Academic'),
  ];

  String tempCategory = 'Academic';
  CategoryPanels();

  List<CategoryPanel> getCategoryPanels () => _categoryPanels;
  void updateCategoryPanelState () {notifyListeners();}
}

class CategoryPanel {
  CategoryPanel({
    this.isExpanded = false,
    this.categoryPicked,
    this.defaultCategoryPicked
  });

  bool isExpanded;
  String categoryPicked;
  String defaultCategoryPicked;
}