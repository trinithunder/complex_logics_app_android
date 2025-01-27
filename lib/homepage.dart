import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Explanation of Code:

// getImageData():
// This is a simulated function where you'd normally retrieve your data (image URLs and text) from secure storage, a backend API, or any other local storage method.

// FutureBuilder:
// It’s used to handle asynchronous data fetching and displays a loading indicator (CircularProgressIndicator) while waiting for the data. Once the data is fetched, it populates the list.

// Image Background:
// Container widget is used to create each item with an image as the background (NetworkImage in this case, you can modify it for local images).
// DecorationImage with BoxFit.cover ensures the image fills the container.

// Text Overlay with Background:
// The text is positioned at the bottom of the container using the Positioned widget.
// A Container with a semi-transparent black background (Colors.black.withOpacity(0.4)) is added to create a depth effect.
// Text is placed on top of this background with some padding for clarity.

// Styling:
// The text is styled with white color, bold font, and a large font size to make it stand out.
// Rounded corners (borderRadius: BorderRadius.circular(15)) are applied to the image container and text background for a polished look.

class HomepageScreen extends StatelessWidget {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Sample data
  Future<List<Map<String, String>>> getImageData() async {
    // Normally, you would load this from secure storage or an API
    return [
      {"imageUrl": "https://example.com/image1.jpg", "text": "Image 1"},
      {"imageUrl": "https://example.com/image2.jpg", "text": "Image 2"},
      {"imageUrl": "https://example.com/image3.jpg", "text": "Image 3"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Homepage")),
      body: FutureBuilder<List<Map<String, String>>>(
        future: getImageData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                height: 250,  // Adjust the height of the image section
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item['imageUrl']!), // Load the image from the URL
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    // Semi-transparent background for text
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4), // Adjust transparency
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    // Text overlay
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(
                        item['text']!,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
