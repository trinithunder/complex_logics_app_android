import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Key Features:

// List of Posts: ListView.builder is used to display multiple posts dynamically.

// Post Tile: Each post is displayed using a custom PostTile widget.

// Profile Image: Loaded using CircleAvatar.

// Username & Handle: Displayed in a row with the name and handle.

// Timestamp: Shows when the post was made.

// Tweet Content: Displays the main content of the post.

// Engagement: Includes icons for "like", "retweet", and "comment", with counters.

// Customization:

// Images: Replace the avatar URL with actual image URLs or local assets.

// Data Source: Replace the posts list with real data fetched from your backend.

// Actions: Implement actual functionality for liking, retweeting, and replying.


// Explanation:

// State Management:

// _isLoading: A boolean flag to track loading state.

// _errorMessage: A string to hold any error message for display.

// _posts: A list to store the fetched posts data.

// Fetching Posts:
// The fetchPosts method is updated to fetch posts from your backend URL. It now returns a list of posts, where each post is a map with String keys and String values.
// Proper error handling is added to display an error message in case of a failure.

// UI Components:

// Loading Indicator: A CircularProgressIndicator is shown when data is being fetched.

// Error Handling: If there's an error fetching the posts, an error message is shown.

// Empty State: If there are no posts, a message is displayed.

// Post List: A list of posts is displayed once the data is fetched. Each post shows the username, content, and timestamp. It also includes a profile picture (from the avatar URL).

// UI Improvements:
// I've used a Card widget around each post for better visual organization.
// The ListTile inside the card displays the username, content, and timestamp in a structured format.
// CircleAvatar is used to show the user's profile image.

// Animations: You could consider adding animations (e.g., FadeInImage, AnimatedList, etc.) for smoother transitions, but this setup should work well for a basic implementation.

// Notes:
// API URL: Replace 'https://your-backend-url.com/posts' with your actual backend URL that returns posts data.
// Error Handling: The error message is displayed if the API call fails.

class MicrobloggingScreen extends StatefulWidget {
  @override
  _MicrobloggingScreenState createState() => _MicrobloggingScreenState();
}

class _MicrobloggingScreenState extends State<MicrobloggingScreen> {
  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, String>> _posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<List<Map<String, String>>> fetchPosts() async {
    setState(() {
      _isLoading = true;  // Show loading state
      _errorMessage = '';  // Reset error message
    });

    try {
      final response = await http.get(Uri.parse('https://your-backend-url.com/posts'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          _isLoading = false;  // Hide loading state
          _posts = data.map((item) {
            return {
              'username': item['username'].toString(),
              'handle': item['handle'].toString(),
              'avatar': item['avatar'].toString(),
              'content': item['content'].toString(),
              'timestamp': item['timestamp'].toString(),
            };
          }).toList();
        });

        return _posts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load posts: ${e.toString()}';
      });
      return [];  // Return an empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Microblogging')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
            else if (_posts.isEmpty)
                Center(child: Text('No posts available'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(post['avatar'] ?? ''),
                          ),
                          title: Text(post['username'] ?? 'Unknown User'),
                          subtitle: Text(post['content'] ?? 'No content available'),
                          trailing: Text(post['timestamp'] ?? ''),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
