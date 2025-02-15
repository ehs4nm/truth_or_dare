import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:truth_or_dare/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:truth_or_dare/shared/theme/typography.dart';
import '../domain/name_manager.dart';
import '../domain/truth_or_dare_data_source.dart';
import '../widgets/online_challenge_container.dart';
import '../widgets/exit_game_dialog.dart';
import '../widgets/online_gradient_card.dart';

class OnlineGame extends StatefulWidget {
  final String? player1;
  final String? player2;
  final String? token;
  final String? gameId;
  final String? url;

  const OnlineGame({
    super.key,
    this.player1,
    this.player2,
    this.token,
    this.gameId,
    this.url
  });

  @override
  State<OnlineGame> createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> with TickerProviderStateMixin {
  List<Player> players = [];
  String id='';
  String inviter = '';
  String invitee = '';
  String turn = '';
  String truthdare = '';
  String currentTurn = '';
  int currentDareIndex = 0;
  int currentTruthIndex = 0;
  int currentPlayerIndex = 0;
  String selectedDare = '';
  String selectedTruth = '';
  bool challengeTypeIsSelected = true;
  String selectedTruthOrDareString = '';
  List<String> selectedCategoryDaresList =
  TruthOrDareGenerator.getDares(TruthOrDareCategory.lvl5);
  List<String> selectedCategoryTruthsList =
  TruthOrDareGenerator.getTruths(TruthOrDareCategory.lvl5);
  TruthOrDareType challengeType = TruthOrDareType.dare;
  String status = '';

  @override
  void initState() {
    super.initState();
    print('myToken: ${widget.token}');
    fetchInitialData();
    if(currentTurn == turn){
      setState(() {
        challengeTypeIsSelected = true;
        print('injam');
      });
    }
    else{
      setState(() {
        challengeTypeIsSelected = false;
        print('oonjam');
      });
    }
  }

  Future<void> fetchInitialData() async {
    await getGameState();
    await checkToken();
    challengeTypeIsSelected = turn == currentTurn ? true : false;
    print('challengeTypeIsSelected: ${challengeTypeIsSelected}');
    print('turn: $turn');
    print('current turn: $currentTurn');
  }

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }


    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return false;
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/flat/backlayer.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 35),
              onPressed: () async {
                bool exit = await showExitConfirmationDialog(context);
                if (exit) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.04),
                child: TextButton(onPressed: () async{
                  var headers = {
                  'Authorization': 'Bearer ' + widget.token!
                  };
                  var request = http.MultipartRequest('POST', Uri.parse('${widget.url}/api/game/reject'));
                  request.fields.addAll({
                  'gameid': widget.gameId as String
                  });

                  request.headers.addAll(headers);

                  http.StreamedResponse response = await request.send();

                  if (response.statusCode == 200) {
                  print(await response.stream.bytesToString());
                  }
                  else {
                  print(response.reasonPhrase);
                  }


                },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),

                    child: Text('پایان بازی',
                      style: AppTypography.semiBold14,
                    ),
                ),
              ),
            ],
          ),
          body: Center(
            child: OnlineGradientCard(
              selectNextPlayer: selectNextPlayer,
              toggle: toggle,
              truthdare: truthdare,
              myChild: OnlineChallengeContainer(
                truthdare: truthdare,
                selectNextPlayer: selectNextPlayer,
                challengeTypeIsSelected: challengeTypeIsSelected,
                showAppropriateTruth: showAppropriateTruth,
                showAppropriateDare: showAppropriateDare,
                token: widget.token,
                gameId: widget.gameId,
                turn: turn,
                player: players[currentPlayerIndex],
                url: widget.url,
              ),
              player: players[currentPlayerIndex],
              challengeTypeIsSelected: challengeTypeIsSelected,
              truthOrDareString: selectedTruthOrDareString,
              challengeType: challengeType,
              gameId: widget.gameId,
              turn: turn,
              players: players,
              url: widget.url,
              token: widget.token,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getGameState() async {
    var headers = {
      'Authorization': 'Bearer ${widget.token}',
    };
    var url = Uri.parse('https://oo9.ir/api/game/${widget.gameId}/state');

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          inviter = jsonResponse['inviter']['username'] ?? 'Unknown Inviter';
          invitee = jsonResponse['invitee']['username'] ?? 'Unknown Invitee';
          currentTurn = jsonResponse['game']['current_turn'];
          status = jsonResponse['game']['status'];
          players = [
            Player(name: inviter, gender: 'male'),
            Player(name: invitee, gender: 'male'),
          ];
        });
      } else {
        print("Failed to fetch game state: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching game state: $error");
    }
  }

  Future<void> checkToken() async {
    var headers = {
      'Authorization': 'Bearer ${widget.token}',
    };
    var url = Uri.parse('https://oo9.ir/api/me');

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          turn = jsonResponse['username'] == inviter ? '1' : '2';
          truthdare = jsonResponse['username'] == inviter ? '1' : '2';
        });
        print('players: $players');
        print('inviter: $inviter');
        print('players: $invitee');
        print('turn: $turn');

      } else {
        print("Failed to verify token: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error verifying token: $error");
    }
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    bool? exit = await showDialog(
      context: context,
      builder: (BuildContext context) => ExitConfirmationDialog(),
    );
    return exit ?? false;
  }

  String showAppropriateTruth() {
    challengeType = TruthOrDareType.truth;
    if (currentTruthIndex < selectedCategoryTruthsList.length - 1) {
      currentTruthIndex++;
    }
    else {
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
    }
    else {
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
      if (incrementPlayer) players[currentPlayerIndex].points++;
      if (currentPlayerIndex < players.length - 1) {
        currentPlayerIndex++;
      }
      else {

        currentPlayerIndex = 0;
      }
      challengeTypeIsSelected = !challengeTypeIsSelected;
    });
  }
  void toggle(){
    challengeTypeIsSelected = !challengeTypeIsSelected;
  }
  //
  // Future<void> getMassages() async {
  //   if (widget.token == null || widget.url == null) return;
  //
  //   var headers = {'Authorization': 'Bearer ${widget.token!}'};
  //   var response = await http.get(Uri.parse('${widget.url!}/api/chat/${widget.gameId as String}'), headers: headers);
  //
  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body) as List<dynamic>;
  //     setState(() {
  //       messages = jsonResponse.map((json) => GameChat.fromMap(json)).toList();
  //     });
  //     _scrollToEnd();
  //   }
  //   setState(() {
  //     isLoad=true;
  //   });
  // }
  // Future<void> fetchUserImage(String userId) async {
  //   if (widget.token == null || widget.url == null) return;
  //
  //   var headers = {'Authorization': 'Bearer ${widget.token!}'};
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('${widget.url!}/api/user/image'),
  //   )..fields.addAll({'userid': userId});
  //
  //   var response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     var imageBytes = await response.stream.toBytes();
  //     setState(() {
  //       if(userId == id){
  //         userImage = imageBytes;
  //       }
  //       else{
  //
  //       }
  //     });
  //   }
  // }
  // Future<void> fetchUserData() async {
  //   if (widget.token == null || widget.url == null) return;
  //
  //   var headers = {'Authorization': 'Bearer ${widget.token!}'};
  //   var response = await http.get(Uri.parse('${widget.url!}/api/me'), headers: headers);
  //
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //     setState(() {
  //       id = jsonResponse['id'].toString();
  //     });
  //     fetchUserImage(id.toString());
  //   }
  //   else{
  //     message.showError(context: context);
  //   }
  // }
  //
  // void setupWebSocket() {
  //   final subscriptionPayload = {
  //     "event": "pusher:subscribe",
  //     "data": {"channel": "gamechat.${widget.gameId as String}"}
  //   };
  //
  //   _channel.sink.add(jsonEncode(subscriptionPayload));
  //
  //   _channel.stream.listen((message) {
  //     final Map<String, dynamic> outerData = jsonDecode(message);
  //     final Map<String, dynamic> innerData = jsonDecode(outerData['data']);
  //     setState(() {
  //       chatMessages.add(innerData['data']['message']);
  //       chatMessagesId.add(innerData['data']['user_id']);
  //     });
  //     _scrollToEnd();
  //   }, onError: (error) => debugPrint("WebSocket error: $error"),
  //       onDone: () => debugPrint("WebSocket connection closed."));
  // }
  //
  // void getId() async{
  //   var headers = {
  //     'Authorization': 'Bearer ' + (widget.token as String)
  //   };
  //   var request = http.MultipartRequest('GET', Uri.parse('${widget.url as String}/api/me'));
  //
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   var responseBody = await response.stream.bytesToString();
  //   var jsonResponse = jsonDecode(responseBody);
  //
  //   if (response.statusCode == 200) {
  //     id = jsonResponse['id'].toString();
  //   }
  //   else {
  //     print(await 'connection failed');
  //   }
  // }
  //
  // Future<void> sendMessage(String message) async {
  //   if (widget.token == null || widget.url == null) return;
  //
  //   var headers = {'Authorization': 'Bearer ${widget.token as String}'};
  //   var request = http.MultipartRequest('POST', Uri.parse('${widget.url as String}/api/chat/${widget.gameId as String}'));
  //   request.fields.addAll({
  //     'message': message,
  //     'game_id': widget.gameId!
  //   });
  //
  //   request.headers.addAll(headers);
  //
  //   await request.send();
  // }
  //
  // void _scrollToEnd() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (_scrollController.hasClients) {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

}