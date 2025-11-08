import 'package:flutter/material.dart';
import '../models/course.dart';
import '../theme.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isEnrolled;
  final VoidCallback onTap;

  const CourseCard({
    Key? key,
    required this.course,
    this.isEnrolled = false,
    required this.onTap,
  }) : super(key: key);

  Color _getDifficultyColor() {
    switch (course.difficulty.toLowerCase()) {
      case 'beginner':
        return AppTheme.primaryGreen;
      case 'intermediate':
        return AppTheme.yellow;
      case 'advanced':
        return AppTheme.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        course.iconUrl,
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            course.difficulty,
                            style: TextStyle(
                              color: _getDifficultyColor(),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isEnrolled)
                    Icon(Icons.check_circle, color: AppTheme.primaryGreen),
                ],
              ),
              SizedBox(height: 12),
              Text(
                course.description,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.menu_book, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    '${course.totalLessons} lessons',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.category, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    course.category,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
