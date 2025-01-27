import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secure_storage.dart';  // Import your SecureStorage helper
import 'login_screen.dart';
class ACHClientsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ACH Clients")),
      body: FutureBuilder(
        future: fetchACHClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('Data fetched successfully!'));
          }
        },
      ),
    );
  }

  Future<void> fetchACHClients() async {
    final token = await SecureStorage.loadToken();

    if (token == null) {
      throw Exception('No token found. Please log in first.');
    }

    final url = Uri.parse("https://your-backend.com/api/ach_clients");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',  // Include token in header
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);  // Handle the response data
    } else {
      throw Exception('Failed to load ACH clients');
    }
  }
}