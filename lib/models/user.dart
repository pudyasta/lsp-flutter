class User {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  int xp;
  int streak;
  int level;
  List<String> enrolledCourses;
  List<String> completedLessons;
  List<String> earnedBadges;
  DateTime? lastActiveDate;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.xp = 0,
    this.streak = 0,
    this.level = 1,
    List<String>? enrolledCourses,
    List<String>? completedLessons,
    List<String>? earnedBadges,
    this.lastActiveDate,
  }) : enrolledCourses = enrolledCourses ?? [],
       completedLessons = completedLessons ?? [],
       earnedBadges = earnedBadges ?? [];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      xp: json['xp'] ?? 0,
      streak: json['streak'] ?? 0,
      level: json['level'] ?? 1,
      enrolledCourses: List<String>.from(json['enrolledCourses'] ?? []),
      completedLessons: List<String>.from(json['completedLessons'] ?? []),
      earnedBadges: List<String>.from(json['earnedBadges'] ?? []),
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'xp': xp,
      'streak': streak,
      'level': level,
      'enrolledCourses': enrolledCourses,
      'completedLessons': completedLessons,
      'earnedBadges': earnedBadges,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
    };
  }

  int get nextLevelXp => level * 500;
  double get progressToNextLevel => (xp % 500) / 500;
}
