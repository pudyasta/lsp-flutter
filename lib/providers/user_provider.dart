import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/progress_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final ProgressService _progressService = ProgressService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  Future<void> loadCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.getCurrentUser();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _error = 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.register(username, email, password);
      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _error = 'Registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> addXP(int xp) async {
    if (_currentUser == null) return;

    _currentUser = await _progressService.addXP(_currentUser!, xp);
    notifyListeners();
  }

  Future<void> completeLesson(String lessonId, int xpReward) async {
    if (_currentUser == null) return;

    _currentUser = await _progressService.completeLesson(
      _currentUser!,
      lessonId,
      xpReward,
    );
    notifyListeners();
  }

  Future<void> enrollInCourse(String courseId) async {
    if (_currentUser == null) return;

    _currentUser = await _progressService.enrollInCourse(
      _currentUser!,
      courseId,
    );
    notifyListeners();
  }

  Future<void> updateProfile(String? bio, String? avatarUrl) async {
    if (_currentUser == null) return;

    // _currentUser!.bio = bio;
    // _currentUser!.avatarUrl = avatarUrl;
    notifyListeners();
  }
}
