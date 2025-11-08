class Lesson {
  final String id;
  final String title;
  final String content;
  final int xpReward;
  final bool isLocked;
  final String? imageUrl;
  final List<String>? keyPoints;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.xpReward,
    this.isLocked = false,
    this.imageUrl,
    this.keyPoints,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      xpReward: json['xpReward'],
      isLocked: json['isLocked'] ?? false,
      imageUrl: json['imageUrl'],
      keyPoints: json['keyPoints'] != null
          ? List<String>.from(json['keyPoints'])
          : null,
    );
  }
}
