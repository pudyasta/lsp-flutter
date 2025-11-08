import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../providers/user_provider.dart';
import '../models/course.dart';
import '../theme.dart';
import 'lesson_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  CourseDetailScreen({required this.courseId});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  Course? _course;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  Future<void> _loadCourse() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final course = await courseProvider.getCourseById(widget.courseId);

    setState(() {
      _course = course;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_course == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Course not found')),
      );
    }

    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    final isEnrolled = user?.enrolledCourses.contains(_course!.id) ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(_course!.title)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _course!.iconUrl,
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _course!.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  _course!.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(
                      '${_course!.totalLessons} Lessons',
                      Icons.menu_book,
                    ),
                    SizedBox(width: 12),
                    _buildInfoChip(_course!.difficulty, Icons.bar_chart),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _course!.lessons.length,
              itemBuilder: (context, index) {
                final lesson = _course!.lessons[index];
                final isCompleted =
                    user?.completedLessons.contains(lesson.id) ?? false;
                final isLocked =
                    !isEnrolled ||
                    (index > 0 &&
                        !(user?.completedLessons.contains(
                              _course!.lessons[index - 1].id,
                            ) ??
                            false));

                return _buildLessonCard(
                  lesson,
                  index + 1,
                  isCompleted,
                  isLocked,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isEnrolled
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () async {
                    await userProvider.enrollInCourse(_course!.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfully enrolled!'),
                        backgroundColor: AppTheme.primaryGreen,
                      ),
                    );
                  },
                  child: Text('Enroll Now'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLessonCard(lesson, int number, bool isCompleted, bool isLocked) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted
              ? AppTheme.primaryGreen
              : isLocked
              ? Colors.grey[300]
              : AppTheme.blue,
          child: isCompleted
              ? Icon(Icons.check, color: Colors.white)
              : isLocked
              ? Icon(Icons.lock, color: Colors.grey)
              : Text(
                  '$number',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLocked ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(
          '${lesson.xpReward} XP',
          style: TextStyle(color: isLocked ? Colors.grey : AppTheme.yellow),
        ),
        trailing: isLocked ? null : Icon(Icons.arrow_forward_ios, size: 16),
        onTap: isLocked
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LessonScreen(lesson: lesson, courseId: _course!.id),
                  ),
                );
              },
      ),
    );
  }
}
