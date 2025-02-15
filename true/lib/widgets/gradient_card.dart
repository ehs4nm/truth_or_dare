import 'package:flutter/material.dart';
import 'package:truth_or_dare/domain/domains.dart';
import 'package:truth_or_dare/shared/theme/typography.dart';
import 'package:truth_or_dare/widgets/widgets.dart';

class GradientCard extends StatelessWidget {
  final Player player;
  final String truthOrDareString;
  final bool challengeTypeIsSelected;
  final TruthOrDareType challengeType;

  const GradientCard({
    required this.player,
    required this.truthOrDareString,
    required this.challengeTypeIsSelected,
    required this.challengeType,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: Stack(
            alignment: challengeTypeIsSelected ? AlignmentDirectional.center : AlignmentDirectional.topStart,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width * .8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: RandomColorGenerator.getBothColors(player.name + player.randomString),
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(player.name, style: AppTypography.extraBold32),
                    SizedBox(height: 20),
                    Text(challengeTypeIsSelected ? 'جرات یا حقیقت' : truthOrDareString,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: challengeTypeIsSelected ? AppTypography.extraBold48 : AppTypography.semiBold17),
                    SizedBox(height: 50),
                  ],
                ),
              ),
              challengeTypeIsSelected
                  ? Container()
                  : Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white30),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset('lib/assets/flat/${challengeType == TruthOrDareType.dare ? 'dare' : 'truth'}.png', width: 40, height: 40),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}