import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secure_storage.dart';  // Import your SecureStorage helper
import 'homepage.dart';
import 'register_screen.dart';  // Import the registration screen

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await register(emailController.text, passwordController.text);
                  Navigator.pop(context);
                } catch (e) {
                  print('Registration failed: $e');
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> register(String email, String password) async {
    final url = Uri.parse("http://localhost:3000/users");

    final response = await http.post(url, body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to register');
    }
  }
}