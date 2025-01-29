import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedMessage extends StatelessWidget {
  final Widget child;

  AnimatedMessage({required this.child});

  @override
  Widget build(BuildContext context) {
    return child.animate().fade(duration: 300.ms).slide();
  }
}
