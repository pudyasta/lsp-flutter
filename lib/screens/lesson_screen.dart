import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';
import '../providers/user_provider.dart';
import '../providers/gamification_provider.dart';
import '../widgets/success_dialog.dart';
import '../theme.dart';
import 'quiz_screen.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final String courseId;

  LessonScreen({required this.lesson, required this.courseId});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.lesson.imageUrl != null)
              Container(
                height: 200,
                color: AppTheme.primaryGreen.withOpacity(0.1),
                child: Center(
                  child: Text('📚', style: TextStyle(fontSize: 80)),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.yellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('⭐', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 4),
                        Text(
                          '${widget.lesson.xpReward} XP Reward',
                          style: TextStyle(
                            color: AppTheme.yellow.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Lesson Content',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.lesson.content,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),
                  if (widget.lesson.keyPoints != null) ...[
                    SizedBox(height: 24),
                    Text(
                      'Key Points',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ...widget.lesson.keyPoints!.map(
                      (point) => Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '✓ ',
                              style: TextStyle(
                                color: AppTheme.primaryGreen,
                                fontSize: 18,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                point,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 32),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.blue, width: 2),
                    ),
                    child: Row(
                      children: [
                        Text('💡', style: TextStyle(fontSize: 32)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Complete the quiz to earn your XP and unlock the next lesson!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isCompleted
                ? null
                : () async {
                    // Navigate to quiz screen (mock quiz)
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(
                          lessonId: widget.lesson.id,
                          xpReward: widget.lesson.xpReward,
                        ),
                      ),
                    );

                    if (result == true) {
                      final userProvider = Provider.of<UserProvider>(
                        context,
                        listen: false,
                      );
                      final gamificationProvider =
                          Provider.of<GamificationProvider>(
                            context,
                            listen: false,
                          );

                      await userProvider.completeLesson(
                        widget.lesson.id,
                        widget.lesson.xpReward,
                      );

                      setState(() {
                        _isCompleted = true;
                      });

                      await gamificationProvider.checkBadges(
                        userProvider.currentUser!,
                      );

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => SuccessDialog(
                          title: 'Lesson Complete!',
                          message: 'Great job! Keep learning!',
                          xpEarned: widget.lesson.xpReward,
                          onContinue: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.pop(context); // Back to course
                          },
                        ),
                      );
                    }
                  },
            child: Text(_isCompleted ? 'Completed' : 'Start Quiz'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }
}
