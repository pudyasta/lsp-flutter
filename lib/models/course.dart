import './lesson.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final String difficulty;
  final int totalLessons;
  final List<Lesson> lessons;
  final String category;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.difficulty,
    required this.totalLessons,
    required this.lessons,
    required this.category,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      difficulty: json['difficulty'],
      totalLessons: json['totalLessons'],
      category: json['category'],
      lessons: (json['lessons'] as List)
          .map((l) => Lesson.fromJson(l))
          .toList(),
    );
  }
}
