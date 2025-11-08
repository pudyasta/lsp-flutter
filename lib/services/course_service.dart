import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lsp_flutter/models/lesson.dart';
import '../models/course.dart';

class CourseService {
  List<Course>? _cachedCourses;

  Future<List<Course>> getCourses() async {
    if (_cachedCourses != null) return _cachedCourses!;

    try {
      final String response = await rootBundle.loadString(
        'assets/data/courses.json',
      );
      final List<dynamic> data = jsonDecode(response);
      _cachedCourses = data.map((json) => Course.fromJson(json)).toList();
      return _cachedCourses!;
    } catch (e) {
      // Return mock data if file doesn't exist
      return _getMockCourses();
    }
  }

  Future<Course?> getCourseById(String id) async {
    final courses = await getCourses();
    try {
      return courses.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Course> _getMockCourses() {
    return [
      Course(
        id: 'flutter_basics',
        title: 'Flutter Basics',
        description: 'Learn the fundamentals of Flutter development',
        iconUrl: '🎨',
        difficulty: 'Beginner',
        totalLessons: 10,
        category: 'Mobile Development',
        lessons: [
          Lesson(
            id: 'lesson_1',
            title: 'Introduction to Flutter',
            content: 'Flutter is an open-source UI framework by Google...',
            xpReward: 50,
            keyPoints: ['Cross-platform', 'Hot reload', 'Rich widgets'],
          ),
          Lesson(
            id: 'lesson_2',
            title: 'Widgets Basics',
            content: 'Everything in Flutter is a widget...',
            xpReward: 75,
            isLocked: false,
          ),
        ],
      ),
      Course(
        id: 'dart_mastery',
        title: 'Dart Mastery',
        description: 'Master the Dart programming language',
        iconUrl: '🎯',
        difficulty: 'Intermediate',
        totalLessons: 15,
        category: 'Programming',
        lessons: [
          Lesson(
            id: 'dart_lesson_1',
            title: 'Variables and Types',
            content: 'Learn about Dart data types and variables...',
            xpReward: 60,
          ),
        ],
      ),
    ];
  }
}
