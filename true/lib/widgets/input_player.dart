import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:truth_or_dare/domain/name_manager.dart';
import 'package:truth_or_dare/shared/theme/typography.dart';
import 'package:truth_or_dare/shared/theme/color_pallet.dart';
import 'package:multiavatar/multiavatar.dart';

class PlayerInputRow extends StatefulWidget {
  final VoidCallback onAddPlayer;

  PlayerInputRow({required this.onAddPlayer});

  @override
  _PlayerInputRowState createState() => _PlayerInputRowState();
}

class _PlayerInputRowState extends State<PlayerInputRow> with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  String svgCode = '';
  late String _randomString = '';
  bool _isVisible = true;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 350));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _animationController.addListener(() {
      setState(() {});
    });

    Future.delayed(Duration(milliseconds: 900), () {
      playAnimation();
      Future.delayed(Duration(milliseconds: 300), () => setState(() => _isVisible = false));
    });
  }

  void playAnimation() {
    _animationController
        .forward()
        .then((_) => _animationController.reverse())
        .then((_) => _animationController.forward().then((_) => _animationController.reverse()));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _generateRandomString({int length = 10}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _randomString = _generateRandomString();
              svgCode = multiavatar(_nameController.text + _randomString, trBackground: true);
            }),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: RandomColorGenerator.getBothColors(_nameController.text + _randomString),
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.add_outlined, grade: 10, weight: 30, size: 35.w, color: Colors.white),
                      onPressed: () {
                        _validatePlayers(_nameController.text);
                        _nameController.clear();
                        svgCode = '';
                        setState(() {});
                      }),
                  Expanded(
                    child: TextField(
                      style: AppTypography.extraBold24,
                      textDirection: TextDirection.rtl,
                      controller: _nameController,
                      onChanged: (value) {
                        setState(() {
                          svgCode = multiavatar(_nameController.text + _randomString, trBackground: true);
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'اسم هم بازی',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: AppTypography.extraBold24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Material(
                      elevation: 3,
                      shape: CircleBorder(),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white70,
                          ),
                          child: svgCode != ''
                              ? SvgPicture.string(
                                  svgCode,
                                  height: 60.w,
                                  width: 60.w,
                                  placeholderBuilder: (BuildContext context) => CircularProgressIndicator(),
                                )
                              : Container(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 1500),
            curve: Curves.fastOutSlowIn,
            child: Text('میتونی روی آواتارت بزنی تا عوض بشه', style: AppTypography.semiBold13),
          ),
        ],
      ),
    );
  }

  _validatePlayers(String playerName) async {
    if (playerName == '') {
      playAnimation();
      showSnack('رفیقمون باید یه اسمی داشته باشه بالاخره');
    }
    if (playerName.isNotEmpty) {
      Player player = Player(name: playerName, gender: '', points: 0, randomString: _randomString);

      try {
        await NameManager.savePlayer(player);
        widget.onAddPlayer();
      } on Exception catch (e) {
        showSnack('اسمت تکراریه');
      }
    }
  }

  // int calculateAsciiSum(String input) {
  //   int sum = 0;
  //   for (int i = 0; i < input.length; i++) {
  //     sum += input.codeUnitAt(i);
  //   }
  //   return sum;
  // }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          msg,
          style: TextStyle(fontSize: 17.w, fontWeight: FontWeight.w800, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
