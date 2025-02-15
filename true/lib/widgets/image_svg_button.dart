import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundSvgImageButton extends StatelessWidget {
  final String imagePath;
  final double size;
  final VoidCallback? onTap;

  const RoundSvgImageButton({
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
        decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
        child: ClipOval(
          child: SvgPicture.asset('lib/assets/flat/$imagePath', width: size * 0.8, height: size, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
