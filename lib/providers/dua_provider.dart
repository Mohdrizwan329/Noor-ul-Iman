import 'package:flutter/foundation.dart';
import '../data/models/dua_model.dart';
import '../core/services/content_service.dart';

class DuaProvider with ChangeNotifier {
  final ContentService _contentService = ContentService();
  List<DuaCategory> _categories = [];
  DuaCategory? _selectedCategory;
  DuaModel? _selectedDua;
  String _searchQuery = '';
  bool _isLoading = false;

  // Getters
  List<DuaCategory> get categories => _categories;
  DuaCategory? get selectedCategory => _selectedCategory;
  DuaModel? get selectedDua => _selectedDua;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  // Get all duas from all categories (for search)
  List<DuaModel> get allDuas {
    List<DuaModel> duas = [];
    for (var category in _categories) {
      duas.addAll(category.duas);
    }
    return duas;
  }

  // Get filtered duas based on search query
  List<DuaModel> get filteredDuas {
    if (_searchQuery.isEmpty) return allDuas;

    final query = _searchQuery.toLowerCase();
    return allDuas.where((dua) {
      return dua.title.toLowerCase().contains(query) ||
          dua.transliteration.toLowerCase().contains(query) ||
          dua.translation.toLowerCase().contains(query) ||
          dua.arabic.contains(query);
    }).toList();
  }

  // Get duas in selected category
  List<DuaModel> get categoryDuas {
    if (_selectedCategory == null) return [];

    if (_searchQuery.isEmpty) {
      return _selectedCategory!.duas;
    }

    final query = _searchQuery.toLowerCase();
    return _selectedCategory!.duas.where((dua) {
      return dua.title.toLowerCase().contains(query) ||
          dua.transliteration.toLowerCase().contains(query) ||
          dua.translation.toLowerCase().contains(query) ||
          dua.arabic.contains(query);
    }).toList();
  }

  // Load all categories from Firebase (with local asset JSON fallback)
  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load from Firebase via ContentService (falls back to local asset JSON)
      _categories = await _contentService.getDuaCategoriesLegacy();
      debugPrint('Loaded ${_categories.length} dua categories');
    } catch (e) {
      debugPrint('Error loading dua categories: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Select a category
  void selectCategory(DuaCategory category) {
    _selectedCategory = category;
    _searchQuery = '';
    notifyListeners();
  }

  // Select a dua
  void selectDua(DuaModel dua) {
    _selectedDua = dua;
    notifyListeners();
  }

  // Clear selected dua
  void clearSelectedDua() {
    _selectedDua = null;
    notifyListeners();
  }

  // Clear selected category
  void clearSelectedCategory() {
    _selectedCategory = null;
    _searchQuery = '';
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Get total duas count
  int get totalDuasCount {
    int count = 0;
    for (var category in _categories) {
      count += category.duas.length;
    }
    return count;
  }

  // Get category by id
  DuaCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get dua by id
  DuaModel? getDuaById(int id) {
    for (var category in _categories) {
      try {
        return category.duas.firstWhere((dua) => dua.id == id);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  // Get next dua in category
  DuaModel? getNextDua() {
    if (_selectedCategory == null || _selectedDua == null) return null;

    final currentIndex = _selectedCategory!.duas.indexWhere((d) => d.id == _selectedDua!.id);
    if (currentIndex == -1 || currentIndex >= _selectedCategory!.duas.length - 1) {
      return null;
    }
    return _selectedCategory!.duas[currentIndex + 1];
  }

  // Get previous dua in category
  DuaModel? getPreviousDua() {
    if (_selectedCategory == null || _selectedDua == null) return null;

    final currentIndex = _selectedCategory!.duas.indexWhere((d) => d.id == _selectedDua!.id);
    if (currentIndex <= 0) {
      return null;
    }
    return _selectedCategory!.duas[currentIndex - 1];
  }

  // Navigate to next dua
  void goToNextDua() {
    final nextDua = getNextDua();
    if (nextDua != null) {
      _selectedDua = nextDua;
      notifyListeners();
    }
  }

  // Navigate to previous dua
  void goToPreviousDua() {
    final prevDua = getPreviousDua();
    if (prevDua != null) {
      _selectedDua = prevDua;
      notifyListeners();
    }
  }

  // Get current dua index in category
  int getCurrentDuaIndex() {
    if (_selectedCategory == null || _selectedDua == null) return 0;
    return _selectedCategory!.duas.indexWhere((d) => d.id == _selectedDua!.id) + 1;
  }

  // Check if has next dua
  bool get hasNextDua => getNextDua() != null;

  // Check if has previous dua
  bool get hasPreviousDua => getPreviousDua() != null;
}
