import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';


// Explanation of Code:

// videoUrls List:
// This is a list containing the URLs of the videos. Replace these with your actual video URLs or paths.

// _controllers List:
// For each video URL, a VideoPlayerController is created to manage video playback.

// ListView.builder:
// A ListView.builder is used to create a scrollable list of video players.
// Each video is displayed in a Container that fills the screen height, ensuring each video takes up the full screen, just like TikTok.

// Autoplay and Video Control:
// When the video is in view, it’s automatically initialized and displayed using the VideoPlayer widget.
// The video plays when tapped, but you can also manage autoplay using the controller.play() and controller.pause() functions.

// Overlay Text:
// The Positioned widget is used to display text over the video at the bottom. You can add more UI elements or modify this as per your needs.

// Handling Video Initialization:
// The video controller is initialized within the itemBuilder of the ListView.builder. You can add extra logic to ensure the video starts playing when it comes into view, or pause when out of view (this would require handling VisibilityDetector or PageView).


class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final List<String> videoUrls = [
    'https://www.example.com/video1.mp4',
    'https://www.example.com/video2.mp4',
    'https://www.example.com/video3.mp4', // Add URLs to your video resources
  ];
  final List<VideoPlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize video controllers for each video
    for (var url in videoUrls) {
      _controllers.add(VideoPlayerController.networkUrl(Uri.parse(url)));
    }
  }

  @override
  void dispose() {
    // Dispose of all video controllers to prevent memory leaks
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Feed')),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          // Ensure each controller is initialized and ready for playback
          _controllers[index].initialize();

          return VisibilityDetector(
            key: Key('video-${index}'), // Unique key for each video item
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction > 0.5) {
                // Play the video when more than half of it is visible
                if (!_controllers[index].value.isPlaying) {
                  _controllers[index].play();
                }
              } else {
                // Pause the video when less than half of it is visible
                if (_controllers[index].value.isPlaying) {
                  _controllers[index].pause();
                }
              }
            },
            child: GestureDetector(
              onTap: () {
                // Optionally, toggle play/pause when video is tapped
                if (_controllers[index].value.isPlaying) {
                  _controllers[index].pause();
                } else {
                  _controllers[index].play();
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: MediaQuery.of(context).size.height, // Full screen height
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Stack(
                  children: [
                    VideoPlayer(_controllers[index]),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Color.fromRGBO(0, 0, 0, 0.5), // Using Color.fromRGBO to set opacity
                        child: Text(
                          'Video ${index + 1}',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
