import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:truth_or_dare/domain/domains.dart';
import 'package:truth_or_dare/domain/message.dart';
import 'package:truth_or_dare/shared/theme/typography.dart';
import 'package:truth_or_dare/widgets/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../domain/game_chat_data.dart';
import 'chat_bubble.dart';

class OnlineGradientCard extends StatefulWidget {
  final Player player;
  final players;
  final String truthOrDareString;
  final bool challengeTypeIsSelected;
  final TruthOrDareType challengeType;
  final OnlineChallengeContainer myChild;
  final Function selectNextPlayer;
  final Function toggle;
  final token;
  final gameId;
  final turn;
  final truthdare;
  final url;

  const OnlineGradientCard({
    required this.myChild,
    required this.player,
    required this.truthOrDareString,
    required this.challengeTypeIsSelected,
    required this.challengeType,
    required this.selectNextPlayer,
    required this.toggle,
    this.players,
    this.token,
    this.gameId,
    this.turn,
    this.truthdare,
    this.url
  });

  @override
  State<OnlineGradientCard> createState() => _OnlineGradientCardState();
}

class _OnlineGradientCardState extends State<OnlineGradientCard> {

  late WebSocketChannel _gameChannel, _chatChannel, _checkInvitationChannel;
  late String id;
  String currentTurn='1';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  List<GameChat> messages = [];
  final List<String> chatMessages = [];
  final List<String> chatMessagesId=[];
  final List<String> usrname=[];
  Uint8List? userImage, usrImgs;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    print("initState is running");
    getMassages();
    _gameChannel = WebSocketChannel.connect(
      Uri.parse(
          'ws://oo9.ir:6001/app/abcdef123456?protocol=7&client=js&version=4.3.1'),
    );
    _chatChannel = WebSocketChannel.connect(
      Uri.parse(
          'ws://oo9.ir:6001/app/abcdef123456?protocol=7&client=js&version=4.3.1'),
    );
    _checkInvitationChannel = WebSocketChannel.connect(
      Uri.parse(
          'ws://oo9.ir:6001/app/abcdef123456?protocol=7&client=js&version=4.3.1'),
    );
    setupWebSocket();
    setupChatWebSocket();
    checkInvitationWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    final combinedMessages = [...messages.map((m) => m.message), ...chatMessages];
    return Container(
      child: Center(
          child: Stack(
            alignment: widget.challengeTypeIsSelected ? AlignmentDirectional.center : AlignmentDirectional.topStart,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:[Color.fromRGBO(28, 28, 34, 1), Color.fromRGBO(70, 70, 85, 1),],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    //Text(player.name, style: AppTypography.extraBold32),
                    SizedBox(height: MediaQuery.of(context).size.height*0.06),
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: MediaQuery.of(context).size.height*0.15,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(222, 205, 184, 1),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Center(
                        child: currentTurn==widget.turn ? Text(widget.challengeTypeIsSelected ? 'جرات یا حقیقت' : widget.truthOrDareString,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: widget.challengeTypeIsSelected ? AppTypography.extraBold32black : AppTypography.semiBold17black)
                            : Text('صبر کن',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: AppTypography.extraBold32black,
                        ),
                      ),
                    ),
                    // myChild,
                    currentTurn==widget.turn ? widget.myChild : Container(
                      child: Text('نوبت حریفه',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: AppTypography.extraBold32
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Center(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromRGBO(28, 28, 34, 1),
                                      Color.fromRGBO(70, 70, 85, 1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                width: MediaQuery.sizeOf(context).width * 0.7,
                                margin: const EdgeInsets.only(top: 20.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: combinedMessages.length,
                                      itemBuilder: (context, index) {
                                        return ChatBubble(
                                          text: combinedMessages[index],
                                          isMine: index < messages.length ? messages[index].user_id == id : chatMessagesId[index-messages.length] == id,
                                          id: id,
                                          user_id: index < messages.length ? messages[index].user_id : chatMessagesId[index-messages.length],
                                          username: 'nadarim',
                                          token: widget.token.toString(),
                                          url: widget.url.toString(),
                                          usrImg: usrImgs,
                                          size: 0.45,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),


                            SizedBox(height: 10,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection: TextDirection.ltr,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.5,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(186, 179, 197, 1),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: TextField(
                                        controller: _messageController,
                                        style: AppTypography.semiBold14black,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          hintText: 'پیام خود را بنویسید',
                                          hintStyle: AppTypography.semiBold14black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // margin: EdgeInsets.only(
                                  //   right: MediaQuery.sizeOf(context).width * 0.04,
                                  // ),
                                  width: MediaQuery.sizeOf(context).width * 0.13,
                                  height: MediaQuery.sizeOf(context).width * 0.13,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(126, 93, 220, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                                    onPressed: () {
                                      sendMessage(_messageController.text);
                                      _messageController.clear();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.6,
                  bottom: !widget.challengeTypeIsSelected ? MediaQuery.of(context).size.height * 0 : MediaQuery.of(context).size.height * 0.6,
                ),
                width: 80,
                child: IconButton(
                  icon: Image.asset('lib/assets/flat/cup1.png'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          DialogContent(players: widget.players),
                    );
                  },
                ),
              ),
              widget.challengeTypeIsSelected
                  ? Container()
                  : Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 60,
                  height: 60,
                  child: Image.asset('lib/assets/flat/${widget.challengeType == TruthOrDareType.dare ? 'dare1' : 'truth1'}.png', width: 60, height: 60),
                ),

              ),


            ],
          ),
      ),
    );
  }

  void setupWebSocket() {
    final subscriptionPayload = {
      "event": "pusher:subscribe",
      "data": {"channel": "game.${widget.gameId}"}
    };

    _gameChannel.sink.add(jsonEncode(subscriptionPayload));

    _gameChannel.stream.listen((msg) {
      // Parse the incoming message
      final Map<String, dynamic> jsonMessage = jsonDecode(msg);
      print('msg: $msg');

      // Check if the message is for the event you're interested in
      if (jsonMessage['event'] == "App\\Events\\TurnChanged") {
        // Decode the inner 'data' field, which is still a JSON string
        final Map<String, dynamic> eventData = jsonDecode(jsonMessage['data']);

        // Access the nested fields properly
        final Map<String, dynamic> nestedData = eventData['data'];
        final int currentTurn = nestedData['current_turn'];
        final String question = nestedData['question'];
        final String opMessage = nestedData['message'];
        final String action = nestedData['action'];
        final String truthdare = nestedData['truthdare'];

        // Update your UI or state
        setState(() {
          this.currentTurn = currentTurn.toString();
          print('Message Data: $msg');
        });
        if(action == '0'){
          setState(() {
            widget.selectNextPlayer(incrementPlayer: false);
            if(this.currentTurn != widget.turn){
              widget.toggle();
            }
            print('hi');
          });
        }

        else if(action == '1'){
          setState(() {
            widget.selectNextPlayer(incrementPlayer: true);
            if(this.currentTurn != widget.turn){
              widget.toggle();
            }
            print('hello');
          });
        }

        if(this.currentTurn == widget.turn){
          message.showResult(
            context: context,
            question: question,
            message: opMessage,
            action: action,
          );

        }
        print('Turn: ${widget.turn}');
        print("Current Turn: $currentTurn");
        print('isSelected: ${widget.challengeTypeIsSelected}');
      }

    });
  }


  Future<void> getMassages() async {
    if (widget.token == null || widget.url == null) return;

    var headers = {'Authorization': 'Bearer ${widget.token!}'};
    var response = await http.get(Uri.parse('${widget.url!}/api/chat/${widget.gameId as String}'), headers: headers);
    print('statusCode: ${response.statusCode}');
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as List<dynamic>;
      setState(() {
        messages = jsonResponse.map((json) => GameChat.fromMap(json)).toList();
      });
      _scrollToEnd();
    }
  }
  Future<void> fetchUserImage(String userId) async {
    if (widget.token == null || widget.url == null) return;

    var headers = {'Authorization': 'Bearer ${widget.token!}'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${widget.url!}/api/user/image'),
    )..fields.addAll({'userid': userId});

    var response = await request.send();

    if (response.statusCode == 200) {
      var imageBytes = await response.stream.toBytes();
      setState(() {
        if(userId == id){
          userImage = imageBytes;
        }
        else{

        }
      });
    }
  }


  void setupChatWebSocket() {
    final subscriptionPayload = {
      "event": "pusher:subscribe",
      "data": {"channel": "gamechat.${widget.gameId}"}
    };

    _chatChannel.sink.add(jsonEncode(subscriptionPayload));

    _chatChannel.stream.listen((message) {
      print('myMessage: $message');
      final Map<String, dynamic> outerData = jsonDecode(message);
      final Map<String, dynamic> innerData = jsonDecode(outerData['data']);
      setState(() {
        chatMessages.add(innerData['data']['message']);
        chatMessagesId.add(innerData['data']['user_id']);
      });
      _scrollToEnd();
    }, onError: (error) => debugPrint("Chat WebSocket error: $error"),
        onDone: () => debugPrint("Chat WebSocket connection closed."));
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

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
Future<void> fetchUserData() async {
  if (widget.token == null || widget.url == null) return;

  var headers = {'Authorization': 'Bearer ${widget.token!}'};
  var response = await http.get(Uri.parse('${widget.url!}/api/me'), headers: headers);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    setState(() {
      id = jsonResponse['id'].toString();
    });
    fetchUserImage(id.toString());
    print('my ID: $id');
  }
  else{
    message.showError(context: context);
  }
}
  void checkInvitationWebSocket() {
    final subscriptionPayload = {
      "event": "pusher:subscribe",
      "data": {"channel": "invitation"}
    };

    _checkInvitationChannel.sink.add(jsonEncode(subscriptionPayload));

    _checkInvitationChannel.stream.listen((msg) {
      final Map<String, dynamic> data = jsonDecode(msg);
      final event = data['event'];
      final game = event?['game'];
      if((game['player_one']==id || game['player_two']==id) && game['status']=='rejected'){
        message.endGame(context: context, url: widget.url, token: widget.token);
      }
    }, onError: (error) => debugPrint("WebSocket error: $error"),
        onDone: () => debugPrint("WebSocket connection closed."));
  }

}