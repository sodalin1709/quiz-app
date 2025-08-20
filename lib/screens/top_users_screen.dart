// screens/top_users_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/quiz_service.dart';

class TopUsersScreen extends StatefulWidget {
  const TopUsersScreen({super.key});

  @override
  State<TopUsersScreen> createState() => _TopUsersScreenState();
}

class _TopUsersScreenState extends State<TopUsersScreen> {
  int _selectedFilterIndex = 0; // 0: All time, 1: This week, 2: Month

  @override
  Widget build(BuildContext context) {
    final topUsers = QuizService.getTopUsers();
    final topThree = topUsers.take(3).toList();
    final restOfUsers = topUsers.skip(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F8),
        elevation: 0,
        // This removes any back arrow that might appear automatically
        automaticallyImplyLeading: false, 
        // MODIFIED: This aligns the title to the left
        centerTitle: false, 
        title: Text(
          'Leaderboard',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(context, topThree),
          Expanded(
            child: _buildLeaderboardList(restOfUsers),
          ),
        ],
      ),
    );
  }

  // Builds the top purple header section with filters and podium
  Widget _buildHeader(BuildContext context, List<Map<String, dynamic>> topThree) {
    const Color primaryColor = Color.fromRGBO(106, 90, 224, 1);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFilterButtons(),
          const SizedBox(height: 30),
          _buildPodium(topThree),
        ],
      ),
    );
  }

  // Builds the filter toggle buttons
  Widget _buildFilterButtons() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ToggleButtons(
        isSelected: List.generate(3, (index) => index == _selectedFilterIndex),
        onPressed: (int index) {
          setState(() {
            _selectedFilterIndex = index;
          });
        },
        color: Colors.white.withOpacity(0.7),
        selectedColor: const Color.fromRGBO(106, 90, 224, 1),
        fillColor: Colors.white,
        splashColor: Colors.white.withOpacity(0.2),
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        children: [
          _buildFilterButton('All time'),
          _buildFilterButton('This week'),
          _buildFilterButton('Month'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    );
  }

  // Builds the podium for the top 3 users
  Widget _buildPodium(List<Map<String, dynamic>> topThree) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (topThree.length > 1) _buildPodiumUser(topThree[1], 2),
        const SizedBox(width: 20),
        if (topThree.isNotEmpty) _buildPodiumUser(topThree[0], 1),
        const SizedBox(width: 20),
        if (topThree.length > 2) _buildPodiumUser(topThree[2], 3),
      ],
    );
  }

  // Builds a single user display for the podium
  Widget _buildPodiumUser(Map<String, dynamic> user, int rank) {
    final isFirstPlace = rank == 1;
    final double avatarRadius = isFirstPlace ? 45 : 35;

    return Column(
      children: [
        if (isFirstPlace)
          const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: Colors.white.withOpacity(0.8),
          child: CircleAvatar(
            radius: avatarRadius - 3,
            backgroundImage: const AssetImage('assets/avatar.png'),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user['name'],
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isFirstPlace ? 16 : 14,
          ),
        ),
        Text(
          '${user['score']}',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.8),
            fontSize: isFirstPlace ? 14 : 12,
          ),
        ),
      ],
    );
  }

  // Builds the scrollable list for users from rank 4 onwards
  Widget _buildLeaderboardList(List<Map<String, dynamic>> users) {
    return Container(
      color: const Color(0xFFF4F6F8), // Match parent background
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final rank = index + 4;
          return _buildUserListItem(user, rank);
        },
      ),
    );
  }

  // Builds a single row for the leaderboard list
  Widget _buildUserListItem(Map<String, dynamic> user, int rank) {
    const Color primaryColor = Color.fromRGBO(106, 90, 224, 1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '$rank',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/avatar.png'),
          ),
          const SizedBox(width: 12),
          Text(
            user['name'],
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            '${user['score']}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
