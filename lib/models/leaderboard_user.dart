// models/leaderboard_user.dart

class LeaderboardUser {
  final String name;
  final int score;
  final String avatarUrl;

  LeaderboardUser({
    required this.name,
    required this.score,
    required this.avatarUrl,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    // FIX: Read firstName and lastName directly from the top-level object.
    final firstName = json['firstName'] ?? '';
    final lastName = json['lastName'] ?? '';
    String fullName = '$firstName $lastName'.trim();
    if (fullName.isEmpty) {
      fullName = 'Anonymous User';
    }

    // FIX: Read from 'totalScore' and safely parse the String to an int.
    final scoreString = json['totalScore'] ?? '0';
    final scoreInt = int.tryParse(scoreString) ?? 0;

    return LeaderboardUser(
      name: fullName,
      score: scoreInt,
      // The API does not provide an avatar, so we use a local asset.
      avatarUrl: 'assets/avatar.png',
    );
  }
}