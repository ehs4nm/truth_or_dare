import 'package:flutter/material.dart';

class RoundImageButton extends StatelessWidget {
  final String imagePath;
  final double size;
  final VoidCallback? onTap;

  const RoundImageButton({
    required this.imagePath,
    this.size = 80,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        width: size,
        height: size,
        child: ClipOval(
          child: Image.asset('lib/assets/flat/$imagePath', width: size * 0.7, height: size, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
