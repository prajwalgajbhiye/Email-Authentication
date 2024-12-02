import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otp_screen/home_page.dart';
import '../colors.dart';
import 'auth_service.dart';
import 'custom_text_field.dart';

class StudentSignUp extends StatefulWidget {
  const StudentSignUp({super.key});

  @override
  _StudentSignUpState createState() => _StudentSignUpState();
}

class _StudentSignUpState extends State<StudentSignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoadingOtp = false;
  bool _isLoadingSignUp = false;
  bool _obscurePassword = true;
  bool _obscureRePassword = true;

  Future<void> _sendOtp() async {
    setState(() => _isLoadingOtp = true);
    String email = _emailController.text.trim();
    if (email.isNotEmpty) {
      bool result = await _authService.sendOtp(email);
      _showSnackbar(result ? 'OTP sent to $email' : 'Failed to send OTP');
    } else {
      _showSnackbar('Please enter a valid email');
    }
    setState(() => _isLoadingOtp = false);
  }

  void _verifyOtp() {
    if (_authService.verifyOtp(_otpController.text.trim())) {
      _showSnackbar('OTP verified successfully');
    } else {
      _showSnackbar('Invalid OTP');
    }
  }

  Future<void> _signUp() async {
    setState(() => _isLoadingSignUp = true);
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String rePassword = _rePasswordController.text.trim();
    String username = _usernameController.text.trim();
    String otp = _otpController.text.trim();

    if ([email, password, username, otp].any((field) => field.isEmpty)) {
      _showSnackbar('Please fill in all fields');
    } else if (password != rePassword) {
      _showSnackbar('Passwords do not match');
    } else {
      UserCredential? userCredential = await _authService.signUpWithEmailAndOtp(
        context,
        email,
        password,
        username,
        otp,
      );

      if (userCredential != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    }
    setState(() => _isLoadingSignUp = false);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.06;
    double width = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.white24,

                Colors.pink,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create Your Account",
                      style: TextStyle(
                        color: loginButtonColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign up to get started",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: labelColor, fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: height,
                      width: width,
                      child: CustomTextField(
                        label: 'Enter Full Name',
                        controller: _usernameController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: height,
                      width: width,
                      child: CustomTextField(

                        label: 'Email Address',
                        controller: _emailController,
                        suffixIcon: _isLoadingOtp
                            ? const CircularProgressIndicator()
                            : IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: _sendOtp,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: height,
                      width: width,
                      child: CustomTextField(
                        label: 'OTP',
                        controller: _otpController,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.verified),
                          onPressed: _verifyOtp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: height,
                      width: width,
                      child: CustomTextField(
                        label: 'Password',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(
                                () => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: height,
                      width: width,
                      child: CustomTextField(
                        label: 'Re-enter Password',
                        controller: _rePasswordController,
                        obscureText: _obscureRePassword,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureRePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(
                                () => _obscureRePassword = !_obscureRePassword);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoadingSignUp ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: loginButtonColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoadingSignUp
                          ? const CircularProgressIndicator()
                          : const Text('Sign Up',
                              style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: textFieldColor, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Login",
                                style: TextStyle(color: Colors.blue)),
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
      ),
    );
  }
}
