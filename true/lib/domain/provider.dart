import 'package:flutter/material.dart';
import 'package:truth_or_dare/domain/domains.dart';

class GameModel extends ChangeNotifier {
  late TruthOrDareCategory mode;
  late String challengeType;
  late List<String> questions;
  late List<Player> players;
  late int gamePlayed = 0;

  void countGamePlayed() {
    gamePlayed += 1;
    notifyListeners();
  }

  void setMode(TruthOrDareCategory selectedMode) {
    mode = selectedMode;
    notifyListeners();
  }

  void setChallengeType(String selectedChallengeType) {
    challengeType = selectedChallengeType;
    notifyListeners();
  }

  void setQuestions(List<String> selectedQuestions) {
    questions = selectedQuestions;
    notifyListeners();
  }

  void setPlayers(List<Player> selectedPlayers) {
    players = selectedPlayers;
    notifyListeners();
  }
}
