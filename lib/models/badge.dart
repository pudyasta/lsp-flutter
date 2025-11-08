class Badge {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String requirement;
  final int requiredValue;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.requirement,
    required this.requiredValue,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      requirement: json['requirement'],
      requiredValue: json['requiredValue'],
    );
  }
}
