import 'package:flutter/material.dart';

class BackgroundAnimationScreen extends StatefulWidget {
  final Widget child;

  BackgroundAnimationScreen({required this.child});

  @override
  _BackgroundAnimationScreenState createState() => _BackgroundAnimationScreenState();
}

class _BackgroundAnimationScreenState extends State<BackgroundAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _colorAnimation = ColorTween(begin: Colors.black45, end: Colors.black).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(color: _colorAnimation.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
