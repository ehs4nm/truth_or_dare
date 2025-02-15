import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class ChallengeContainer extends StatelessWidget {
  final bool challengeTypeIsSelected;
  final Function showAppropriateTruth;
  final Function showAppropriateDare;
  final Function selectNextPlayer;

  ChallengeContainer({
    required this.challengeTypeIsSelected,
    required this.showAppropriateTruth,
    required this.showAppropriateDare,
    required this.selectNextPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 65),
      child: challengeTypeIsSelected
          ? Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RoundImageButton(imagePath: 'truth.png', onTap: () => showAppropriateTruth()),
            RoundImageButton(imagePath: 'dare.png', onTap: () => showAppropriateDare()),
          ],
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RoundImageButton(imagePath: 'reject.png', onTap: () => selectNextPlayer(incrementPlayer: false)),
          RoundImageButton(imagePath: 'done.png', onTap: () => selectNextPlayer(incrementPlayer: true)),
        ],
      ),
    );
  }
}