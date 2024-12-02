
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variable to store the generated OTP
  String? _sentOtp;

  // Sign-up with email and OTP verification
  Future<UserCredential?> signUpWithEmailAndOtp(
      BuildContext context, String email, String password, String username, String enteredOtp) async {
    if (verifyOtp(enteredOtp)) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          // Store user data in Firestore under the 'users' collection
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'uid': userCredential.user!.uid,
            'email': email,
            'username': username,
            'createdAt': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-up successful!')),
          );
          return userCredential;
        }
      } catch (e) {
        print('Sign-up Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-up failed')),
        );
        return null;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP does not match')),
      );
      return null;
    }
    return null;
  }

  // Send OTP via email using the mailer package
  Future<bool> sendOtp(String email) async {
    try {
      // Gmail SMTP server configuration
      String username = 'gajbhiyeprajwal466@gmail.com';
      String password = 'fhhr avhb piln qzwb';  // Replace with your app password

      final smtpServer = gmail(username, password);

      // Generate a 6-digit OTP
      String otp = _generateOtp();

      // Store the generated OTP
      _sentOtp = otp;

      // Compose the email
      final message = Message()
        ..from = Address(username, 'Your App OTP Service')
        ..recipients.add(email)
        ..subject = 'Your OTP Code'
        ..text = 'Your OTP code is: $otp';

      // Send the email
      final sendReport = await send(message, smtpServer);

      if (sendReport != null) {
        print('OTP sent: $otp');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  // Generate a 6-digit OTP
  String _generateOtp() {
    var random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Verify if the entered OTP matches the sent one
  bool verifyOtp(String enteredOtp) {
    if (_sentOtp == enteredOtp) {
      print('OTP verification successful');
      return true;
    } else {
      print('OTP verification failed');
      return false;
    }
  }

  // Login with email and password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }
}
