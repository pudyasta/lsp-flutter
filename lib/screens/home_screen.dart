import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/course_provider.dart';
import '../providers/gamification_provider.dart';
import '../widgets/xp_progress_bar.dart';
import '../widgets/streak_flame.dart';
import '../widgets/badge_card.dart';
import '../theme.dart';
import './leaderboard_screen.dart';
import './profile_screen.dart';
import './course_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final gamificationProvider = Provider.of<GamificationProvider>(
      context,
      listen: false,
    );

    await courseProvider.loadCourses();
    gamificationProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(user),
          _buildCoursesTab(),
          _buildLeaderboardTab(),
          _buildProfileTab(user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Courses'),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeTab(user) {
    final gamificationProvider = Provider.of<GamificationProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${user.username}! 👋',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ready to learn today?',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
                StreakFlame(streak: user.streak),
              ],
            ),
            SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    XPProgressBar(
                      currentXP: user.xp,
                      nextLevelXP: user.nextLevelXp,
                      level: user.level,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('Total XP', user.xp.toString(), '⭐'),
                        _buildStatCard('Streak', '${user.streak} days', '🔥'),
                        _buildStatCard(
                          'Lessons',
                          '${user.completedLessons.length}',
                          '📚',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Daily Challenge',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _buildDailyChallengeCard(),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Badges',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3; // Go to profile
                    });
                  },
                  child: Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: gamificationProvider.allBadges.take(5).length,
                itemBuilder: (context, index) {
                  final badge = gamificationProvider.allBadges[index];
                  final isEarned = user.earnedBadges.contains(badge.id);
                  return Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 12),
                    child: BadgeCard(badge: badge, isEarned: isEarned),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String emoji) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 24)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildDailyChallengeCard() {
    return Card(
      elevation: 2,
      color: AppTheme.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.blue, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('🎯', style: TextStyle(fontSize: 32)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete 3 Lessons',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Earn 100 bonus XP',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppTheme.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTab() {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => CoursesScreen());
      },
    );
  }

  Widget _buildLeaderboardTab() {
    return LeaderboardScreen();
  }

  Widget _buildProfileTab(user) {
    return ProfileScreen();
  }
}
