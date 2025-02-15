import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrapezoidButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;
  final Widget child;

  TrapezoidButton({required this.onPressed, required this.enabled, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: TrapezoidPainter(enabled: enabled),
        child: Container(
          height: 60.h,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
          child: child,
        ),
      ),
    );
  }
}

class TrapezoidPainter extends CustomPainter {
  final bool enabled;

  TrapezoidPainter({required this.enabled});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.orange[600]!, Colors.orange[600]!],
        stops: [0.0, 1],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    Path path = Path()
      ..moveTo(25, size.height)
      ..lineTo(size.width * .04, size.height * 0.3)
      ..lineTo(size.width * 1.05, size.height * 0.05)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrapezoidPainter oldDelegate) => oldDelegate.enabled != enabled;
}
