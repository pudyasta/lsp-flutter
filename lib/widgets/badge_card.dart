import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/badge.dart' as badge_model;

class BadgeCard extends StatelessWidget {
  final badge_model.Badge badge;
  final bool isEarned;
  final bool showDetails;

  const BadgeCard({
    Key? key,
    required this.badge,
    this.isEarned = false,
    this.showDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEarned ? AppTheme.yellow.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEarned ? AppTheme.yellow : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            badge.iconUrl,
            style: TextStyle(
              fontSize: showDetails ? 48 : 32,
              // : isEarned ? 1.0 : 0.3,
            ),
          ),
          SizedBox(height: 8),
          Text(
            badge.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: showDetails ? 16 : 12,
              color: isEarned ? Colors.black87 : Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (showDetails) ...[
            SizedBox(height: 4),
            Text(
              badge.description,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
