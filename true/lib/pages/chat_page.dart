import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:truth_or_dare/domain/message.dart';
import 'package:truth_or_dare/domain/message_data.dart';
import 'package:truth_or_dare/main.dart';
import 'package:truth_or_dare/pages/home_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../shared/theme/typography.dart';
import '../utils/no_animation_navigator_push.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final String? token;
  final String? url;

  const ChatPage({super.key, this.token, this.url});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String id='';
  Uint8List? userImage, usrImgs;
  List<Data> messages = [];
  final List<String> chatMessages = [];
  final List<String> chatMessagesId=[];
  final List<String> usrname=[];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  late String player1, player2, gameId, invitedBy;
  late WebSocketChannel _channel, _checkInvitationChannel;
  bool isLoad=false;

  @override
  void initState() {
    super.initState();
    getId();
    _channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://oo9.ir:6001/app/abcdef123456?protocol=7&client=js&version=4.3.1'),
    );
    _checkInvitationChannel = WebSocketChannel.connect(
      Uri.parse(
          'ws://oo9.ir:6001/app/abcdef123456?protocol=7&client=js&version=4.3.1'),
    );
    fetchUserData();
    setupWebSocket();
    checkInvitationWebSocket();
    getMassages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _channel.sink.close();
    _checkInvitationChannel.sink.close();
    super.dispose();
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
    }
    else{
      message.showError(context: context);
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

  Future<void> getMassages() async {
    if (widget.token == null || widget.url == null) return;

    var headers = {'Authorization': 'Bearer ${widget.token!}'};
    var response = await http.get(Uri.parse('${widget.url!}/api/chat'), headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as List<dynamic>;
      setState(() {
        messages = jsonResponse.map((json) => Data.fromMap(json)).toList();
      });
      _scrollToEnd();
    }
    setState(() {
      isLoad=true;
    });
  }


  void setupWebSocket() {
    final subscriptionPayload = {
      "event": "pusher:subscribe",
      "data": {"channel": "group-chat"}
    };

    _channel.sink.add(jsonEncode(subscriptionPayload));

    _channel.stream.listen((message) {
      final Map<String, dynamic> outerData = jsonDecode(message);
      final Map<String, dynamic> innerData = jsonDecode(outerData['data']);
      setState(() {
        chatMessages.add(innerData['chat']['message']);
        chatMessagesId.add(innerData['chat']['user_id']);
        usrname.add(innerData['chat']['user']['username']);
      });
      _scrollToEnd();
    }, onError: (error) => debugPrint("WebSocket error: $error"),
        onDone: () => debugPrint("WebSocket connection closed."));
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
      if(game['player_one']==id || game['player_two']==id){
        setState(() {
          gameId = game['id'].toString();
          player1 = game['player_one'];
          player2 = game['player_two'];
          invitedBy = event['invited_by'];
        });
      }
      if(game['status']=='pending' && game['player_two']==id){
        message.showInvite(
            context: context,
            token: widget.token!,
            game_id: gameId,
            url: widget.url!,
            player1: player1,
            player2: player2,
            invitedBy: invitedBy
        );
      }
      else if(game['status']=='rejected' && game['player_one']==id){
        message.rejected(context: context);
      }
      else if(game['status']=='active' && game['player_one']==id){
        message.accepted(context: context, player1: player1, player2: player2, token: widget.token, gameId: gameId, url: widget.url);
      }
    }, onError: (error) => debugPrint("WebSocket error: $error"),
        onDone: () => debugPrint("WebSocket connection closed."));
  }


  void getId() async{
    var headers = {
      'Authorization': 'Bearer ' + (widget.token as String)
    };
    var request = http.MultipartRequest('GET', Uri.parse('${widget.url as String}/api/me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      id = jsonResponse['id'].toString();
    }
    else {
      print(await 'connection failed');
    }
  }

  Future<void> sendMessage(String message) async {
    if (widget.token == null || widget.url == null) return;

    var headers = {'Authorization': 'Bearer ${widget.token!}'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${widget.url!}/api/chat'))
      ..fields.addAll({'message': message})
      ..headers.addAll(headers);

    await request.send();
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

  @override
  Widget build(BuildContext context) {
    final combinedMessages = [...messages.map((m) => m.message), ...chatMessages];

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainApp()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 35),
            onPressed: (){
              pushReplacementWithoutAnimation(context, HomePage());
            },
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: userImage != null ? MemoryImage(userImage!) : null,
                child: userImage == null ? const Icon(Icons.person) : null,
              ),
              Text("پیام ها", style: AppTypography.extraBold24),
            ],
          ),
        ),
        body: Column(
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
                width: MediaQuery.sizeOf(context).width * 0.9,
                margin: const EdgeInsets.only(top: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: !isLoad ? Center(
                    child: CircularProgressIndicator(
                      color: const Color.fromRGBO(126, 93, 220, 1),
                    ),
                  ) :ClipRRect(
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
                          username: index < messages.length ? messages[index].username : usrname[index-messages.length],
                          token: widget.token.toString(),
                          url: widget.url.toString(),
                          usrImg: usrImgs,
                          size: 0.69,
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
                  margin: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).width * 0.04,
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.75,
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
                  margin: EdgeInsets.only(
                    right: MediaQuery.sizeOf(context).width * 0.04,
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.15, // Circular size
                  height: MediaQuery.sizeOf(context).width * 0.15,
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
    );
  }
}

