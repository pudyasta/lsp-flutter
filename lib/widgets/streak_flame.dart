import 'package:flutter/material.dart';
import '../theme.dart';

class StreakFlame extends StatelessWidget {
  final int streak;
  final bool compact;

  const StreakFlame({Key? key, required this.streak, this.compact = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 6 : 10,
      ),
      decoration: BoxDecoration(
        color: AppTheme.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.orange, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔥', style: TextStyle(fontSize: compact ? 18 : 24)),
          SizedBox(width: 6),
          Text(
            '$streak',
            style: TextStyle(
              color: AppTheme.orange,
              fontWeight: FontWeight.bold,
              fontSize: compact ? 16 : 20,
            ),
          ),
          if (!compact) ...[
            SizedBox(width: 4),
            Text(
              'day${streak != 1 ? 's' : ''}',
              style: TextStyle(color: AppTheme.orange, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
