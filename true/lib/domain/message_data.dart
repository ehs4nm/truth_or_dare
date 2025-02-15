import 'dart:convert';

List<Data> dataFromMap(String str) => List<Data>.from(json.decode(str).map((x) => Data.fromMap(x)));
String dataToMap(List<Data> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Data{
  Data({
    required this.id,
    required this.user_id,
    required this.message,
    required this.username,
});

  int id;
  String user_id;
  String message, username;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
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