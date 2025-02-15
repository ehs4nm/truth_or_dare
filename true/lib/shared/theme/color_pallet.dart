import 'dart:math';

import 'package:flutter/material.dart';

class RandomColorGenerator {
  static List<Color> get colors => _colors;

  static final List<Color> _colors = [
    Color(0xffd0312d),
    Color(0xff990f02),
    Color(0xff60100b),
    Color.fromARGB(255, 206, 83, 71),
    Color(0xffd21404),
    Color(0xffff033e),
    Color(0xffed7014),
    Color(0xfffcae1e),
    Color(0xff8d4004),
    Color(0xffbe5504),
    Color.fromARGB(255, 253, 149, 97),
    Color(0xffff4500),
    Color(0xfffb8842),
    Color.fromARGB(255, 235, 200, 47),
    Color.fromARGB(255, 105, 82, 12),
    Color(0xffeeed09),
    Color.fromARGB(255, 83, 82, 8),
    Color(0xffc49102),
    Color(0xff3cb043),
    Color(0xffb0fc38),
    Color(0xff3a5311),
    Color.fromARGB(255, 71, 124, 53),
    Color(0xff98bf64),
    Color(0xff028a0f),
    Color(0xff74b72e),
    Color(0xff3ded97),
    Color(0xff03c04a),
    Color.fromARGB(255, 82, 218, 150),
    Color(0xff597d35),
    Color(0xff568203),
    Color(0xff29ab87),
    Color(0xff00755e),
    Color(0xff50c878),
    Color(0xff00f0a8),
    Color(0xff3944bc),
    Color.fromARGB(255, 8, 101, 122),
    Color(0xff0a1172),
    Color(0xff022d36),
    Color(0xff1520a6),
    Color(0xff0492c2),
    Color(0xff2c3e4c),
    Color.fromARGB(255, 1, 42, 48),
    Color.fromARGB(255, 65, 129, 182),
    Color(0xff004f98),
    Color.fromARGB(255, 8, 51, 83),
    Color.fromARGB(255, 61, 103, 182),
    Color(0xff318ce7),
    Color(0xffa32cc4),
    Color(0xff7a4988),
    Color(0xff710193),
    Color(0xffa1045a),
    Color.fromARGB(255, 170, 59, 201),
    Color(0xff663046),
    Color.fromARGB(255, 162, 54, 216),
    Color(0xff290916),
    Color(0xff8f00ff),
    Color(0xff4e2a84),
    Color.fromARGB(255, 248, 100, 140),
    Color(0xfffc46aa),
    Color(0xfff25278),
    Color(0xffe11584),
    Color(0xffff00ff),
    Color.fromARGB(255, 167, 117, 48),
    Color.fromARGB(255, 88, 83, 161),
    Color(0xff5e5e5e),
    Color.fromARGB(255, 54, 71, 3),
  ];

  static Color getRandomColor() {
    int randomValue = Random(12).nextInt(_colors.length);
    return _colors[randomValue];
  }

  static List<Color> getBothColors(String playerName) {
    int parsedValue = calculateAsciiSum(playerName);
    parsedValue = (parsedValue % _colors.length).abs();
    Color color1 = _colors[parsedValue];

    // Choose another color based on a different calculation or pattern
    // int index2 = (parsedValue + 100) % _colors.length;
    // Color color2 = _colors[index2];
    Color color2 = lighten(color1, 0.15);
    return [color2, color1];
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static int calculateAsciiSum(String input) {
    int sum = 0;
    for (int i = 0; i < input.length; i++) {
      sum += input.codeUnitAt(i);
    }
    return sum;
  }
}
