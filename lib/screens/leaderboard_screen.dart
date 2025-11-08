import 'package:flutter/material.dart';
import '../theme.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _mockLeaderboard = [
    {'rank': 1, 'name': 'Alice Wonder', 'xp': 2450, 'avatar': '👩'},
    {'rank': 2, 'name': 'Bob Builder', 'xp': 2100, 'avatar': '👨'},
    {'rank': 3, 'name': 'Charlie Tech', 'xp': 1890, 'avatar': '🧑'},
    {'rank': 4, 'name': 'Diana Prince', 'xp': 1650, 'avatar': '👸'},
    {'rank': 5, 'name': 'DemoUser', 'xp': 1250, 'avatar': '😊'},
    {'rank': 6, 'name': 'Frank Castle', 'xp': 1100, 'avatar': '🦸'},
    {'rank': 7, 'name': 'Grace Hopper', 'xp': 950, 'avatar': '👩‍💻'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_mockLeaderboard.length > 1)
                  _buildPodium(
                    _mockLeaderboard[1],
                    2,
                    AppTheme.blue.withOpacity(0.3),
                  ),
                if (_mockLeaderboard.isNotEmpty)
                  _buildPodium(
                    _mockLeaderboard[0],
                    1,
                    AppTheme.yellow.withOpacity(0.5),
                  ),
                if (_mockLeaderboard.length > 2)
                  _buildPodium(
                    _mockLeaderboard[2],
                    3,
                    AppTheme.orange.withOpacity(0.3),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _mockLeaderboard.length,
              itemBuilder: (context, index) {
                final entry = _mockLeaderboard[index];
                return _buildLeaderboardCard(entry, index == 4);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(Map<String, dynamic> entry, int rank, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: _getRankColor(rank), width: 3),
          ),
          child: Center(
            child: Text(entry['avatar'], style: TextStyle(fontSize: 32)),
          ),
        ),
        SizedBox(height: 8),
        Text(_getRankEmoji(rank), style: TextStyle(fontSize: 24)),
        Text(
          entry['name'].split(' ')[0],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          '${entry['xp']} XP',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildLeaderboardCard(Map<String, dynamic> entry, bool isCurrentUser) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: isCurrentUser ? AppTheme.primaryGreen.withOpacity(0.1) : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRankColor(entry['rank']).withOpacity(0.2),
          child: Text(
            '${entry['rank']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getRankColor(entry['rank']),
            ),
          ),
        ),
        title: Text(
          entry['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          '${entry['xp']} XP',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.yellow),
        ),
      ),
    );
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return AppTheme.yellow;
      case 2:
        return AppTheme.blue;
      case 3:
        return AppTheme.orange;
      default:
        return Colors.grey;
    }
  }
}
