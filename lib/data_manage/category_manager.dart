
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