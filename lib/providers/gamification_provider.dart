import 'package:flutter/foundation.dart';
import '../models/badge.dart';
import '../models/user.dart';
import '../services/progress_service.dart';

class GamificationProvider with ChangeNotifier {
  final ProgressService _progressService = ProgressService();

  List<Badge> _allBadges = [];
  List<Badge> _newlyEarnedBadges = [];
  bool _showLevelUpAnimation = false;
  int? _previousLevel;

  List<Badge> get allBadges => _allBadges;
  List<Badge> get newlyEarnedBadges => _newlyEarnedBadges;
  bool get showLevelUpAnimation => _showLevelUpAnimation;

  void initialize() {
    _allBadges = _getMockBadges();
  }

  Future<void> checkBadges(User user) async {
    final newBadges = await _progressService.checkAndAwardBadges(
      user,
      _allBadges,
    );

    if (newBadges.isNotEmpty) {
      _newlyEarnedBadges = newBadges;
      notifyListeners();
    }
  }

  void checkLevelUp(User user) {
    if (_previousLevel != null && user.level > _previousLevel!) {
      _showLevelUpAnimation = true;
      notifyListeners();

      Future.delayed(Duration(seconds: 3), () {
        _showLevelUpAnimation = false;
        notifyListeners();
      });
    }
    _previousLevel = user.level;
  }

  void clearNewBadges() {
    _newlyEarnedBadges = [];
    notifyListeners();
  }

  List<Badge> _getMockBadges() {
    return [
      Badge(
        id: 'first_lesson',
        name: 'First Steps',
        description: 'Complete your first lesson',
        iconUrl: '🎯',
        requirement: 'lessons',
        requiredValue: 1,
      ),
      Badge(
        id: 'streak_3',
        name: 'On Fire',
        description: 'Maintain a 3-day streak',
        iconUrl: '🔥',
        requirement: 'streak',
        requiredValue: 3,
      ),
      Badge(
        id: 'streak_7',
        name: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        iconUrl: '⚡',
        requirement: 'streak',
        requiredValue: 7,
      ),
      Badge(
        id: 'xp_500',
        name: 'Rising Star',
        description: 'Earn 500 XP',
        iconUrl: '⭐',
        requirement: 'xp',
        requiredValue: 500,
      ),
      Badge(
        id: 'xp_1000',
        name: 'Knowledge Seeker',
        description: 'Earn 1000 XP',
        iconUrl: '🌟',
        requirement: 'xp',
        requiredValue: 1000,
      ),
      Badge(
        id: 'level_5',
        name: 'Intermediate',
        description: 'Reach level 5',
        iconUrl: '🏆',
        requirement: 'level',
        requiredValue: 5,
      ),
      Badge(
        id: 'lessons_10',
        name: 'Dedicated Learner',
        description: 'Complete 10 lessons',
        iconUrl: '📚',
        requirement: 'lessons',
        requiredValue: 10,
      ),
    ];
  }
}
