import 'package:flutter/material.dart';
import '../shared/theme/typography.dart';
import '../widgets/widgets.dart';
import 'package:http/http.dart' as http;

class OnlineChallengeContainer extends StatefulWidget {
  final bool challengeTypeIsSelected;
  final Function showAppropriateTruth;
  final Function showAppropriateDare;
  final Function selectNextPlayer;
  final token;
  final gameId;
  final player;
  final turn;
  final truthdare;
  final url;

  OnlineChallengeContainer({
    required this.challengeTypeIsSelected,
    required this.showAppropriateTruth,
    required this.showAppropriateDare,
    required this.selectNextPlayer,
    this.url,
    this.gameId,
    this.token,
    this.player,
    this.turn,
    this.truthdare
  });


  @override
  State<OnlineChallengeContainer> createState() => _OnlineChallengeContainerState();
}

class _OnlineChallengeContainerState extends State<OnlineChallengeContainer> {
  String? user;
  String question = 'default';
  TextEditingController _message = TextEditingController();
  // late WebSocketChannel _gameChannel;

  @override
  void initState() {
    super.initState();
    // _gameChannel = WebSocketChannel.connect(
    //   Uri.parse(
    //       'ws://oo9.ir:6001/app/abcdef123456?protocol=7&client=js&version=4.3.1'),
    // );
    // setupWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: widget.challengeTypeIsSelected
            ? Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        RoundImageButton(
                            imagePath: 'truth1.png',
                            onTap: () {
                              question = widget.showAppropriateTruth();
                              sendMessage('کاربر حقیقت را انتخاب کرد\nمتن سوال: $question');
                            },
                        ),
                        Text('حقیقت',
                          style: AppTypography.semiBold14,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        RoundImageButton(
                            imagePath: 'dare1.png',
                            onTap: () {
                              question = widget.showAppropriateDare();
                              sendMessage('کاربر جرات را انتخاب کرد\nمتن سوال: $question');
                            },
                        ),
                        Text('جرات',
                          style: AppTypography.semiBold14,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container(
                child: Column(
                  children: [
                    Container(
                      child: TextField(
                        controller: _message,
                        style: AppTypography.semiBold14,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          hintText: 'پیام خود را بنویسید',
                          hintStyle: AppTypography.semiBold14,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundImageButton(
                            imagePath: 'reject1.png',
                            size: 65,
                            onTap: () {
                              action('0');
                              // widget.selectNextPlayer(incrementPlayer: false);
                              _message.clear();
                            }),
                        RoundImageButton(
                            imagePath: 'done1.png',
                            size: 65,
                            onTap: () {
                              action('1');
                              _message.clear();
                              // widget.selectNextPlayer(incrementPlayer: true);
                            }),
                      ],
                    ),
                  ],
                ),
              ));
  }

  void action(String act) async{
    var headers = {
      'Authorization': 'Bearer ' + widget.token
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://oo9.ir/api/game/${widget.gameId}/end-turn'));
    String myMessage = _message.text;
    if(myMessage.isEmpty){
      myMessage = 'جوابی نداشت';
    }
    request.fields.addAll({
      'gameid': widget.gameId,
      'action': act,
      'truthdare': widget.truthdare,
      'message': myMessage,
      'question': question
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void> sendMessage(String message) async {
    if (widget.token == null || widget.url == null) return;

    var headers = {'Authorization': 'Bearer ${widget.token as String}'};
    var request = http.MultipartRequest('POST', Uri.parse('${widget.url as String}/api/chat/${widget.gameId as String}'));
    request.fields.addAll({
      'message': message,
      'game_id': widget.gameId!
    });

    request.headers.addAll(headers);

    await request.send();
    print('senttttttttt');
  }

// void setupWebSocket() {
//   final subscriptionPayload = {
//     "event": "pusher:subscribe",
//     "data": {"channel": "game.${widget.gameId}"}
//   };
//
//   _gameChannel.sink.add(jsonEncode(subscriptionPayload));
//
//   _gameChannel.stream.listen((message) {
//     print('///////////////////////////////${message}');
//     final Map<String, dynamic> msg = jsonDecode(message);
//     final event = msg['event'];
//     final outerData = event?['data'];
//     final innerData = outerData?['data'];
//     setState(() {
//       currentTurn = innerData['current_turn'];
//     });
//   }, onError: (error) => debugPrint("WebSocket error: $error"),
//       onDone: () => debugPrint("WebSocket connection closed."));
// }

}