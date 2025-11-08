import '../models/user.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storage = StorageService();

  // Mock login
  Future<User?> login(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay

    final users = await _storage.getAllUsers();

    // Check if user exists
    final userJson = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (userJson.isNotEmpty) {
      final user = User.fromJson(userJson);
      await _storage.saveUser(user.toJson());
      return user;
    }

    // Default demo user
    if (email == 'demo@duolingo.com' && password == 'demo123') {
      final demoUser = User(
        id: 'user_1',
        username: 'DemoUser',
        email: email,
        xp: 1250,
        streak: 7,
        level: 3,
        bio: 'Learning enthusiast!',
        lastActiveDate: DateTime.now(),
      );
      await _storage.saveUser(demoUser.toJson());
      return demoUser;
    }

    return null;
  }

  // Mock register
  Future<User?> register(String username, String email, String password) async {
    await Future.delayed(Duration(milliseconds: 500));

    final users = await _storage.getAllUsers();

    // Check if email exists
    if (users.any((u) => u['email'] == email)) {
      return null; // Email already exists
    }

    final newUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: email,
      xp: 0,
      streak: 0,
      level: 1,
      lastActiveDate: DateTime.now(),
    );

    users.add({...newUser.toJson(), 'password': password});
    await _storage.saveAllUsers(users);
    await _storage.saveUser(newUser.toJson());

    return newUser;
  }

  Future<User?> getCurrentUser() async {
    final userJson = await _storage.getCurrentUser();
    if (userJson != null) {
      return User.fromJson(userJson);
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.clearUser();
  }

  // Mock forgot password
  Future<bool> resetPassword(String email) async {
    await Future.delayed(Duration(milliseconds: 500));
    return true; // Always succeed in mock
  }
}
