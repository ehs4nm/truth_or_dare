import 'package:flutter/material.dart';
import 'package:truth_or_dare/pages/pages.dart';
import 'package:truth_or_dare/widgets/widgets.dart';
import 'package:truth_or_dare/domain/domains.dart';

import '../widgets/online_gradient_card.dart';

class OnlineChallengeTypeSelectionPage extends StatefulWidget {
  @override
  _OnlineChallengeTypeSelectionPageState createState() => _OnlineChallengeTypeSelectionPageState();
}

class _OnlineChallengeTypeSelectionPageState extends State<OnlineChallengeTypeSelectionPage> with TickerProviderStateMixin {
  late List<Player?> players = [];
  int currentDareIndex = 0;
  int currentTruthIndex = 0;
  int currentPlayerIndex = 0;
  late String selectedDare = '';
  late String selectedTruth = '';
  bool challengeTypeIsSelected = true;
  late String selectedTruthOrDareString = '';
  late List<String> selectedCategoryDaresList = [];
  late List<String> selectedCategoryTruthsList = [];
  late TruthOrDareType challengeType = TruthOrDareType.dare;

  @override
  void initState() {
    super.initState();
    fetchAllPlayers();
  }

  void fetchAllPlayers() async {
    List<Player> fetchedPlayers = await NameManager.getSavedPlayers();
    fetchedPlayers.shuffle();

    selectedCategoryTruthsList = TruthOrDareGenerator.getTruths(TruthOrDareCategory.lvl5);
    selectedCategoryDaresList = TruthOrDareGenerator.getDares(TruthOrDareCategory.lvl5);

    setState(() {
      players = fetchedPlayers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showExitConfirmationDialog(context);
        if (exit)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        return exit;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 35),
            onPressed: () async {
              bool exit = await showExitConfirmationDialog(context);
              if (exit) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));

              return;
            },
          ),
          actions: [
            IconButton(
              icon: Image.asset('lib/assets/flat/cup.png'),
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context) => DialogContent(players: players));
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OnlineGradientCard(
              toggle: toggle,
              selectNextPlayer: selectNextPlayer,
              myChild: OnlineChallengeContainer(
                selectNextPlayer: selectNextPlayer,
                challengeTypeIsSelected: challengeTypeIsSelected,
                showAppropriateTruth: showAppropriateTruth,
                showAppropriateDare: showAppropriateDare,
              ),
              player: currentPlayerIndex < players.length
                  ? players[currentPlayerIndex] ?? new Player(name: 'You', gender: 'male')
                  : new Player(name: 'You', gender: 'male'),
              challengeTypeIsSelected: challengeTypeIsSelected,
              truthOrDareString: selectedTruthOrDareString,
              challengeType: challengeType,
            ),

          ],
        ),
      ),
    );
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    bool? exit = await showDialog(context: context, builder: (BuildContext context) => ExitConfirmationDialog());
    return exit ?? false;
  }

  String showAppropriateTruth() {
    challengeType = TruthOrDareType.truth;
    if (currentTruthIndex < selectedCategoryTruthsList.length - 1) {
      currentTruthIndex++;
    } else {
      players.shuffle();
      currentTruthIndex = 0;
    }
    selectedTruth = selectedCategoryTruthsList[currentTruthIndex];

    setState(() {
      challengeTypeIsSelected = !challengeTypeIsSelected;
      selectedTruthOrDareString = selectedTruth;
    });
    return selectedTruthOrDareString;
  }

  String showAppropriateDare() {
    challengeType = TruthOrDareType.dare;
    if (currentDareIndex < selectedCategoryDaresList.length - 1) {
      currentDareIndex++;
    } else {
      players.shuffle();
      currentDareIndex = 0;
    }
    selectedDare = selectedCategoryDaresList[currentDareIndex];

    setState(() {
      challengeTypeIsSelected = !challengeTypeIsSelected;
      selectedTruthOrDareString = selectedDare;
    });
    return selectedTruthOrDareString;
  }

  void selectNextPlayer({bool incrementPlayer = false}) {
    setState(() {
      challengeTypeIsSelected = !challengeTypeIsSelected;
      if (incrementPlayer) players[currentPlayerIndex]!.points++;
      if (currentPlayerIndex < players.length - 1) {
        currentPlayerIndex++;
      } else {
        if (players.length > 2) players.shuffle();
        currentPlayerIndex = 0;
      }
    });
  }
  void toggle(){
    challengeTypeIsSelected = !challengeTypeIsSelected;
  }
}
