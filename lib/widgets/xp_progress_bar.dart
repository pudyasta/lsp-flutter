import 'package:flutter/material.dart';
import '../theme.dart';

class XPProgressBar extends StatelessWidget {
  final int currentXP;
  final int nextLevelXP;
  final int level;

  const XPProgressBar({
    Key? key,
    required this.currentXP,
    required this.nextLevelXP,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = (currentXP % nextLevelXP) / nextLevelXP;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level $level',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${currentXP % nextLevelXP}/${nextLevelXP} XP',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 16,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
          ),
        ),
      ],
    );
  }
}
