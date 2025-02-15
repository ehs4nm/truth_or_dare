import 'dart:convert';

List<GameChat> dataFromMap(String str) => List<GameChat>.from(json.decode(str).map((x) => GameChat.fromMap(x)));
String dataToMap(List<GameChat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GameChat{
  GameChat({
    required this.id,
    required this.user_id,
    required this.message,
    required this.username,
    required this.game_id
  });

  int id;
  String user_id;
  String message, username, game_id;

  factory GameChat.fromMap(Map<String, dynamic> json) => GameChat(
      game_id: json['game_id'],
      id: json['id'],
      user_id: json['user_id'].toString(),
      message: json['message'],
      username: json['username']
  );

  Map<String, dynamic> toMap()=>{
    'user_id': user_id,
    'message': message
  };
}