import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../services/course_service.dart';

class CourseProvider with ChangeNotifier {
  final CourseService _courseService = CourseService();

  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;

  List<Course> get courses {
    var filtered = _courses;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((course) {
        return course.title.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            course.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      filtered = filtered.where((course) {
        return course.category == _selectedCategory;
      }).toList();
    }

    return filtered;
  }

  List<String> get categories {
    return _courses.map((c) => c.category).toSet().toList();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  Future<void> loadCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _courses = await _courseService.getCourses();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<Course?> getCourseById(String id) async {
    return await _courseService.getCourseById(id);
  }
}
