// screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _schoolController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = AuthService.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _ageController.text = user.age.toString();
      _schoolController.text = user.school;
      _selectedGender = user.gender;
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final user = AuthService.currentUser;
      if (user != null) {
        final updatedUser = User(
          name: _nameController.text,
          email: user.email, // Email is not editable
          age: int.tryParse(_ageController.text) ?? user.age,
          school: _schoolController.text,
          gender: _selectedGender,
          totalTestsTaken: user.totalTestsTaken,
          totalScore: user.totalScore,
          leagueRanking: user.leagueRanking,
          profilePicture: user.profilePicture,
        );

        AuthService.updateProfile(updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromRGBO(106, 90, 224, 1);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 250, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Personal Info',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildAvatar(),
                const SizedBox(height: 30),
                _buildTextField(label: 'Full Name', controller: _nameController),
                _buildTextField(label: 'Email', controller: _emailController, enabled: false),
                _buildTextField(label: 'Age', controller: _ageController, keyboardType: TextInputType.number),
                _buildTextField(label: 'School', controller: _schoolController),
                _buildGenderDropdown(),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage('assets/avatar.png'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(106, 90, 224, 1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromRGBO(106, 90, 224, 1)),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        // MODIFIED: Added styling to the dropdown menu
        borderRadius: BorderRadius.circular(12),
        elevation: 4,
        dropdownColor: Colors.white,
        items: ['Male', 'Female', 'Other']
            .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender, style: GoogleFonts.poppins()),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedGender = value;
            });
          }
        },
      ),
    );
  }
}
