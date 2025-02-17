
class CategoryDataManager {
  // Singleton
  CategoryDataManager._privateConstructor();
  static final CategoryDataManager instance = CategoryDataManager._privateConstructor();

  // Data to be shared
  final List<Map<String, String>> categoryData = [];

  // Add category to the list
  void addCategory(Map<String, String> category) {
    categoryData.add(category);
  }

  // Remove the category from the list
  void removeCategory(int index) {
    if (index >= 0 && index < categoryData.length) {
      categoryData.removeAt(index);
    }
  }

  // Clear all categories
  void clearAll() {
    categoryData.clear();
  }
}


class FilteredCategoryDataManager {
  // Singleton
  FilteredCategoryDataManager._privateConstructor();
  static final FilteredCategoryDataManager instance = FilteredCategoryDataManager._privateConstructor();

  // data to be shared
  final Map<String, List<String>> filteredCategories = {};

  // add category to the list
  void addCategory(String categoryName, String name) {
    if(!filteredCategories.containsKey(categoryName)) {
      filteredCategories[categoryName] = [];
    }

    filteredCategories[categoryName]!.add(name);
  }
}