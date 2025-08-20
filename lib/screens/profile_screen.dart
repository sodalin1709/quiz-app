// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'auth/login_screen.dart';
import 'edit_profile_screen.dart'; // Import the new screen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for the change password dialog
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  void _changePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password', style: GoogleFonts.poppins()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current Password'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password changed successfully')),
                );
                _currentPasswordController.clear();
                _newPasswordController.clear();
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout', style: GoogleFonts.poppins()),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                AuthService.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    if (user == null) {
      // This should ideally not be reached if routing is handled correctly,
      // but it's a safe fallback.
      return const LoginScreen();
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 250, 255),
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildHeader(user),
              const SizedBox(height: 30),
              _buildActionMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(User user) {
    const Color primaryColor = Color.fromRGBO(106, 90, 224, 1);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/avatar.png'), // Replace with user's profile picture
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Score', user.totalScore.toString()),
              _buildStatItem('Tests', user.totalTestsTaken.toString()),
              _buildStatItem('Rank', '#${user.leagueRanking}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildActionMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(106, 90, 224, 1).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuListItem(
            label: 'Edit Profile',
            icon: Icons.person_outline,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              ).then((_) {
                // Refresh the profile screen when returning from edit screen
                setState(() {});
              });
            },
          ),
          _buildMenuListItem(
            label: 'Change Password',
            icon: Icons.lock_outline,
            onPressed: _changePassword,
          ),
          _buildMenuListItem(
            label: 'Logout',
            icon: Icons.logout,
            onPressed: _logout,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuListItem({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(16))
            : BorderRadius.zero,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: isLast
                  ? BorderSide.none
                  : BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black54),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}






















// // screens/profile_screen.dart
// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import '../models/user.dart';
// import 'auth/login_screen.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _ageController = TextEditingController();
//   final _schoolController = TextEditingController();
//   final _currentPasswordController = TextEditingController();
//   final _newPasswordController = TextEditingController();
  
//   String _selectedGender = 'Male';
//   bool _isEditing = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   void _loadUserData() {
//     final user = AuthService.currentUser;
//     if (user != null) {
//       _nameController.text = user.name;
//       _emailController.text = user.email;
//       _ageController.text = user.age.toString();
//       _schoolController.text = user.school;
//       _selectedGender = user.gender;
//     }
//   }

//   void _saveProfile() {
//     final user = AuthService.currentUser;
//     if (user != null) {
//       final updatedUser = User(
//         name: _nameController.text,
//         email: _emailController.text,
//         age: int.tryParse(_ageController.text) ?? user.age,
//         school: _schoolController.text,
//         gender: _selectedGender,
//         totalTestsTaken: user.totalTestsTaken,
//         totalScore: user.totalScore,
//         leagueRanking: user.leagueRanking,
//         profilePicture: user.profilePicture,
//       );
      
//       AuthService.updateProfile(updatedUser);
//       setState(() {
//         _isEditing = false;
//       });
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile updated successfully')),
//       );
//     }
//   }

//   void _changePassword() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Change Password'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _currentPasswordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Current Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _newPasswordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'New Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Simulate password change
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Password changed successfully')),
//                 );
//                 _currentPasswordController.clear();
//                 _newPasswordController.clear();
//               },
//               child: const Text('Change'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _logout() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 AuthService.logout();
//                 Navigator.of(context).pop();
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                   (Route<dynamic> route) => false,
//                 );
//               },
//               child: const Text('Logout'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = AuthService.currentUser;
//     if (user == null) {
//       return const LoginScreen();
//     }

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(65, 65, 160, 1.0),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Header
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: const BoxDecoration(
//                   color: Color.fromRGBO(240, 140, 50, 1.0),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(32),
//                     bottomRight: Radius.circular(32),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         Icons.person,
//                         size: 60,
//                         color: Colors.blue.shade800,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       user.name,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       user.email,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
              
//               // User Stats
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildStatItem('Total Score', user.totalScore.toString()),
//                     _buildStatItem('Tests Taken', user.totalTestsTaken.toString()),
//                     _buildStatItem('Ranking', '#${user.leagueRanking}'),
//                   ],
//                 ),
//               ),
              
//               // Conditional Form or Buttons
//               _isEditing
//                 ? _buildEditingForm()
//                 : _buildActionButtons(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget for the main action buttons
//   Widget _buildActionButtons() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           const SizedBox(height: 16),
//           _buildActionButton(
//             label: 'Edit Profile',
//             icon: Icons.edit,
//             onPressed: () {
//               setState(() {
//                 _isEditing = true;
//               });
//             },
//           ),
//           const SizedBox(height: 12),
//           _buildActionButton(
//             label: 'Change Password',
//             icon: Icons.lock,
//             onPressed: _changePassword,
//           ),
//           const SizedBox(height: 12),
//           _buildActionButton(
//             label: 'Logout',
//             icon: Icons.logout,
//             onPressed: _logout,
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget for the editing form
//   Widget _buildEditingForm() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTextField(label: 'Full Name', controller: _nameController),
//             _buildTextField(label: 'Email', controller: _emailController, enabled: false),
//             _buildTextField(label: 'Age', controller: _ageController, keyboardType: TextInputType.number),
//             _buildTextField(label: 'School', controller: _schoolController),
//             _buildGenderDropdown(),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _isEditing = false;
//                         _loadUserData(); 
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: const Text('Cancel', style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _saveProfile,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: const Text('Save', style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.white70,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     bool enabled = true,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         enabled: enabled,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           filled: true,
//           fillColor: enabled ? Colors.white : Colors.grey.shade200,
//         ),
//       ),
//     );
//   }

//   Widget _buildGenderDropdown() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: DropdownButtonFormField<String>(
//         value: _selectedGender,
//         decoration: InputDecoration(
//           labelText: 'Gender',
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//         items: ['Male', 'Female', 'Other']
//             .map((gender) => DropdownMenuItem(
//                   value: gender,
//                   child: Text(gender),
//                 ))
//             .toList(),
//         onChanged: (value) {
//           if (value != null) {
//             setState(() {
//               _selectedGender = value;
//             });
//           }
//         },
//       ),
//     );
//   }

//   // This is the modified button widget
//   Widget _buildActionButton({
//     required String label,
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white, // Reverted to a neutral white color
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 2,
//       ),
//       // The child is a Row with MainAxisAlignment.start to left-align content
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start, // This aligns the content to the left
//         children: [
//           Icon(icon, color: Colors.black87),
//           const SizedBox(width: 16), // Spacing between icon and text
//           Text(label, style: const TextStyle(color: Colors.black87, fontSize: 16)),
//         ],
//       ),
//     );
//   }
// }