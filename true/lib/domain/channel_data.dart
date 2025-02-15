import 'dart:convert';

List<ChannelData> dataFromMap(String str) => List<ChannelData>.from(json.decode(str).map((x) => ChannelData.fromMap(x)));
String dataToMap(List<ChannelData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ChannelData{
  ChannelData({
    required this.user_id,
    required this.message,
  });

  String user_id;
  String message;

  factory ChannelData.fromMap(Map<String, dynamic> json) => ChannelData(
      user_id: json['user_id'].toString(),
      message: json['message']
  );

  Map<String, dynamic> toMap()=>{
    'user_id': user_id,
    'message': message
  };
}