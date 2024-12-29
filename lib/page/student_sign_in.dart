import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_screen/home_page.dart';
import 'package:otp_screen/page/student_sign_up.dart';
import '../colors.dart';
import 'auth_service.dart';
import 'custom_text_field.dart';
import 'forgot_password_screen.dart';

class StudentSignIn extends StatefulWidget {
  const StudentSignIn({super.key});

  @override
  _StudentSignInState createState() => _StudentSignInState();
}

class _StudentSignInState extends State<StudentSignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String _errorMessage = '';
  bool _isLoading = false;
  bool _isPasswordShow = true;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() => _isLoading = true);
      User? user = await _authService.loginWithEmail(email, password);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
          _isLoading = false;
        });
      }
    } else {
      setState(() => _errorMessage = 'Please fill out all fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        // create a gradient background
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.pink,
                Colors.white24,
                Colors.pink,
              ],
            ),
          ),

          // white center box

          child: Center(
            child:
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.all(20),
              height: 500,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      "Welcome Back,",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                        controller: _emailController, label: 'Email Address'),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: _isPasswordShow,
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        onPressed: () {
                          setState(() => _isPasswordShow = !_isPasswordShow);
                        },
                        icon: Icon(_isPasswordShow
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: loginButtonColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 120),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : const Text('Login',
                              style: TextStyle(fontSize: 18)),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width * 0.2,
                          color: Colors.black12,
                        ),
                        Text(
                          "  Or continue with   ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor2,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width * 0.2,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword()));
                          },
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(
                                color: textFieldColor, fontSize: 14),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StudentSignUp()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
