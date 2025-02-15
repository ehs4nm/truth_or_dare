import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:truth_or_dare/shared/theme/typography.dart';
import 'package:truth_or_dare/widgets/widgets.dart';

class ExitConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff1E2952), RandomColorGenerator.lighten(Color(0xff1E2952), .15)],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'این دور بازی تموم شد؟',
                  style: AppTypography.extraBold24,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'برگردیم به صفحه اول',
                  style: AppTypography.semiBold14,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundImageButton(imagePath: 'reject.png', size: 45, onTap: () => Navigator.of(context).pop(false)),
                    RoundImageButton(imagePath: 'done.png', size: 45, onTap: () => Navigator.of(context).pop(true)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
