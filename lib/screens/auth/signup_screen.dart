// screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../main_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _schoolController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final age = int.tryParse(_ageController.text);

    bool success = await AuthService.signUp(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      _schoolController.text,
      age!,
      _selectedGender!,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up failed. Please try again.')),
      );
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _schoolController.dispose();
    _ageController.dispose();
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to get started!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(label: 'Full Name', controller: _nameController),
                  _buildTextField(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
                  _buildTextField(label: 'Password', controller: _passwordController, obscureText: true),
                  _buildTextField(label: 'School', controller: _schoolController),
                  _buildTextField(label: 'Age', controller: _ageController, keyboardType: TextInputType.number),
                  _buildGenderDropdown(),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: GoogleFonts.poppins()),
                      TextButton(
                        onPressed: () {
                           Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginScreen())
                          );
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }

  // MODIFIED: This widget is updated to have a clean dropdown style
  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        hint: Text('Select Gender', style: GoogleFonts.poppins(color: Colors.grey.shade600)),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromRGBO(255, 255, 255, 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        elevation: 4,
        dropdownColor: const Color.fromRGBO(255, 255, 255, 1),
        items: ['Male', 'Female', 'Other']
            .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender, style: GoogleFonts.poppins()),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
        validator: (value) => value == null ? 'Please select a gender' : null,
      ),
    );
  }
}














// // screens/auth/signup_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../../services/auth_service.dart';
// import '../main_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _schoolController = TextEditingController();
//   final _ageController = TextEditingController(); // <-- 1. Add age controller
//   String? _selectedGender; // <-- 2. Variable for gender dropdown
//   bool _isLoading = false;

//   Future<void> _signUp() async {
//     // Basic validation
//     if (_nameController.text.isEmpty ||
//         _emailController.text.isEmpty ||
//         _passwordController.text.isEmpty ||
//         _schoolController.text.isEmpty ||
//         _ageController.text.isEmpty ||
//         _selectedGender == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please fill in all fields')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final age = int.tryParse(_ageController.text);
//     if (age == null) {
//        ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid age')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }

//     bool success = await AuthService.signUp(
//       _nameController.text,
//       _emailController.text,
//       _passwordController.text,
//       _schoolController.text,
//       age,
//       _selectedGender!,
//     );

//     setState(() {
//       _isLoading = false;
//     });

//     if (success) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const MainScreen()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Sign up failed')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(65, 65, 160, 1.0),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Create Account',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 40),
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           labelText: 'Full Name',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       TextField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       TextField(
//                         controller: _schoolController,
//                         decoration: InputDecoration(
//                           labelText: 'School',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       // 3. Add Age TextField
//                       TextField(
//                         controller: _ageController,
//                         decoration: InputDecoration(
//                           labelText: 'Age',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: <TextInputFormatter>[
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                       ),
//                       SizedBox(height: 16),
//                       // 4. Add Gender Dropdown
//                       DropdownButtonFormField<String>(
//                         value: _selectedGender,
//                         hint: Text('Select Gender'),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                         ),
//                         items: ['Male', 'Female', 'Other']
//                             .map((gender) => DropdownMenuItem(
//                                   value: gender,
//                                   child: Text(gender),
//                                 ))
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedGender = value;
//                           });
//                         },
//                       ),
//                       SizedBox(height: 16),
//                       TextField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: _isLoading ? null : _signUp,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             padding: EdgeInsets.all(16),
//                           ),
//                           child: _isLoading
//                               ? CircularProgressIndicator(color: Colors.white)
//                               : Text(
//                                   'Sign Up',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }