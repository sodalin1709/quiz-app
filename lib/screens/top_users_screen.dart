// screens/top_users_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/leaderboard_user.dart';
import '../services/report_service.dart';

class TopUsersScreen extends StatefulWidget {
  const TopUsersScreen({super.key});

  @override
  State<TopUsersScreen> createState() => _TopUsersScreenState();
}

class _TopUsersScreenState extends State<TopUsersScreen> {
  Future<List<LeaderboardUser>>? _leaderboardFuture;

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = ReportService.getTopPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F8),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'Leaderboard',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: FutureBuilder<List<LeaderboardUser>>(
        future: _leaderboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Leaderboard data is not available.', style: GoogleFonts.poppins()));
          }

          final topUsers = snapshot.data!;
          final topThree = topUsers.take(3).toList();
          final restOfUsers = topUsers.skip(3).toList();

          return Column(
            children: [
              _buildHeader(context, topThree),
              Expanded(child: _buildLeaderboardList(restOfUsers)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<LeaderboardUser> topThree) {
    const Color primaryColor = Color.fromRGBO(106, 90, 224, 1);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: _buildPodium(topThree),
    );
  }

  Widget _buildPodium(List<LeaderboardUser> topThree) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Use spaceEvenly for better spacing
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (topThree.length > 1) _buildPodiumUser(topThree[1], 2),
        if (topThree.isNotEmpty) _buildPodiumUser(topThree[0], 1),
        if (topThree.length > 2) _buildPodiumUser(topThree[2], 3),
      ],
    );
  }

  Widget _buildPodiumUser(LeaderboardUser user, int rank) {
    final isFirstPlace = rank == 1;
    final double avatarRadius = isFirstPlace ? 45 : 35;
    final ImageProvider imageProvider = user.avatarUrl.startsWith('http')
        ? NetworkImage(user.avatarUrl)
        : AssetImage(user.avatarUrl) as ImageProvider;

    return Flexible( // Use Flexible to prevent overflow
      child: Column(
        children: [
          if (isFirstPlace) const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
          const SizedBox(height: 4),
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.white.withOpacity(0.8),
            child: CircleAvatar(
              radius: avatarRadius - 3,
              backgroundImage: imageProvider,
              onBackgroundImageError: (_, __) {},
            ),
          ),
          const SizedBox(height: 8),
          Text(user.name, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isFirstPlace ? 16 : 14)),
          Text('${user.score}', style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: isFirstPlace ? 14 : 12)),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardUser> users) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final rank = index + 4;
        return _buildUserListItem(user, rank);
      },
    );
  }

  Widget _buildUserListItem(LeaderboardUser user, int rank) {
    const Color primaryColor = Color.fromRGBO(106, 90, 224, 1);
    final ImageProvider imageProvider = user.avatarUrl.startsWith('http')
        ? NetworkImage(user.avatarUrl)
        : AssetImage(user.avatarUrl) as ImageProvider;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Text('$rank', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade600)),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 20,
            backgroundImage: imageProvider,
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 12),
          // FIX: Wrap the name in an Expanded widget to prevent overflow
          Expanded(
            child: Text(
              user.name,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis, // Add ellipsis for very long names
            ),
          ),
          const SizedBox(width: 8),
          Text('${user.score}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)),
        ],
      ),
    );
  }
}