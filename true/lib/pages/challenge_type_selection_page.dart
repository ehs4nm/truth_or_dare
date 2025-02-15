import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truth_or_dare/pages/pages.dart';
import 'package:truth_or_dare/widgets/widgets.dart';
import 'package:truth_or_dare/domain/domains.dart';

class ChallengeTypeSelectionPage extends StatefulWidget {
  @override
  _ChallengeTypeSelectionPageState createState() => _ChallengeTypeSelectionPageState();
}

class _ChallengeTypeSelectionPageState extends State<ChallengeTypeSelectionPage> with TickerProviderStateMixin {
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

    TruthOrDareCategory category = Provider.of<GameModel>(context, listen: false).mode;
    selectedCategoryTruthsList = TruthOrDareGenerator.getTruths(category);
    selectedCategoryDaresList = TruthOrDareGenerator.getDares(category);

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
            GradientCard(
              player: currentPlayerIndex < players.length
                  ? players[currentPlayerIndex] ?? new Player(name: 'You', gender: 'male')
                  : new Player(name: 'You', gender: 'male'),
              challengeTypeIsSelected: challengeTypeIsSelected,
              truthOrDareString: selectedTruthOrDareString,
              challengeType: challengeType,
            ),
            ChallengeContainer(
              challengeTypeIsSelected: challengeTypeIsSelected,
              showAppropriateTruth: showAppropriateTruth,
              showAppropriateDare: showAppropriateDare,
              selectNextPlayer: selectNextPlayer,
            )
          ],
        ),
      ),
    );
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    bool? exit = await showDialog(context: context, builder: (BuildContext context) => ExitConfirmationDialog());
    return exit ?? false;
  }

  void showAppropriateTruth() {
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
  }

  void showAppropriateDare() {
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
}