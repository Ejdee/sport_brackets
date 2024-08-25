
class CategoryDataManager {
  // Singleton
  CategoryDataManager._privateConstructor();
  static final CategoryDataManager instance = CategoryDataManager._privateConstructor();

  // data to be shared
  final List<Map<String, String>> categoryData = [];

  // add category to the list
  void addCategory(Map<String, String> category) {
    categoryData.add(category);
  }

  // remove the category from the list
  void removeCategory(int index) {
    categoryData.removeAt(index);
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