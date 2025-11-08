import '../models/user.dart';
import '../models/badge.dart';
import 'storage_service.dart';

class ProgressService {
  final StorageService _storage = StorageService();

  Future<User> addXP(User user, int xp) async {
    user.xp += xp;

    // Level up logic
    while (user.xp >= user.nextLevelXp) {
      user.level++;
    }

    await _storage.saveUser(user.toJson());
    return user;
  }

  Future<User> updateStreak(User user) async {
    final now = DateTime.now();
    final lastActive = user.lastActiveDate;

    if (lastActive != null) {
      final difference = now.difference(lastActive).inDays;

      if (difference == 1) {
        user.streak++;
      } else if (difference > 1) {
        user.streak = 1; // Reset streak
      }
    } else {
      user.streak = 1;
    }

    user.lastActiveDate = now;
    await _storage.saveUser(user.toJson());
    return user;
  }

  Future<User> completeLesson(User user, String lessonId, int xpReward) async {
    if (!user.completedLessons.contains(lessonId)) {
      user.completedLessons.add(lessonId);
      user = await addXP(user, xpReward);
      user = await updateStreak(user);
    }

    await _storage.saveUser(user.toJson());
    return user;
  }

  Future<User> enrollInCourse(User user, String courseId) async {
    if (!user.enrolledCourses.contains(courseId)) {
      user.enrolledCourses.add(courseId);
      await _storage.saveUser(user.toJson());
    }
    return user;
  }

  Future<List<Badge>> checkAndAwardBadges(
    User user,
    List<Badge> allBadges,
  ) async {
    List<Badge> newBadges = [];

    for (var badge in allBadges) {
      if (user.earnedBadges.contains(badge.id)) continue;

      bool earned = false;

      switch (badge.requirement) {
        case 'xp':
          earned = user.xp >= badge.requiredValue;
          break;
        case 'streak':
          earned = user.streak >= badge.requiredValue;
          break;
        case 'lessons':
          earned = user.completedLessons.length >= badge.requiredValue;
          break;
        case 'level':
          earned = user.level >= badge.requiredValue;
          break;
      }

      if (earned) {
        user.earnedBadges.add(badge.id);
        newBadges.add(badge);
      }
    }

    if (newBadges.isNotEmpty) {
      await _storage.saveUser(user.toJson());
    }

    return newBadges;
  }
}
