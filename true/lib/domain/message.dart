import 'package:flutter/material.dart';
import 'package:truth_or_dare/pages/chat_page.dart';
import 'package:truth_or_dare/pages/online_game.dart';
import 'package:truth_or_dare/pages/online_room.dart';
import '../shared/theme/typography.dart';
import '../utils/no_animation_navigator_push.dart';
import 'package:http/http.dart' as http;
class message{
  static void showInvite({required BuildContext context, required String? token, required String? game_id,required String? url, required String player1, required String player2, required String invitedBy}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext){
          return AlertDialog(
            title: Text('پیام دعوت',
            style: AppTypography.semiBold30,
            textDirection: TextDirection.rtl,),
            content: Text(invitedBy + ' شما را به بازی دعوت کرده. بریم؟',
            style: AppTypography.semiBold14,
            textDirection: TextDirection.rtl,),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async{
                    var headers = {
                      'Authorization': 'Bearer ' + token!
                    };
                    var request = http.MultipartRequest('POST', Uri.parse('${url}/api/game/reject'));
                    request.fields.addAll({
                      'gameid': game_id as String
                    });

                    request.headers.addAll(headers);

                    http.StreamedResponse response = await request.send();

                    if (response.statusCode == 200) {
                      print(await response.stream.bytesToString());
                    }
                    else {
                    print(response.reasonPhrase);
                    }

                    Navigator.of(dialogContext).pop();
                  },
                  child: Icon(Icons.close_rounded)
              ),
              ElevatedButton(
                  onPressed: () async{
                    Navigator.pop(dialogContext);
                    var headers = {
                      'Authorization': 'Bearer ' + token!
                    };
                    var request = http.MultipartRequest('POST', Uri.parse('${url}/api/game/accept'));
                    request.fields.addAll({
                      'gameid': game_id as String
                    });

                    request.headers.addAll(headers);

                    http.StreamedResponse response = await request.send();

                    if (response.statusCode == 200) {
                      print(await response.stream.bytesToString());
                    }
                    else {
                      print(response.reasonPhrase);
                    }

                    pushReplacementWithoutAnimation(context, OnlineGame(player1: player1, player2: player2, token: token, gameId: game_id, url: url,));
                  },
                  child: Icon(Icons.check)
              ),
            ],
          );
        }
        );
  }
  static void rejected({required BuildContext context}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext){
          return AlertDialog(
            title: Text('ای وای',
              style: AppTypography.semiBold30,
              textDirection: TextDirection.rtl,),
            content: Text('قبول نکرد',
              style: AppTypography.semiBold14,
              textDirection: TextDirection.rtl,),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async{
                    Navigator.of(dialogContext).pop();
                  },
                  child: Icon(Icons.check)
              ),
            ],
          );
        }
    );
  }
  static void endGame({required BuildContext context, required String url, required String token}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext){
          return AlertDialog(
            title: Text('ای وای',
              style: AppTypography.semiBold30,
              textDirection: TextDirection.rtl,),
            content: Text('بازی تموم شد',
              style: AppTypography.semiBold14,
              textDirection: TextDirection.rtl,),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async{
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => ChatPage(url: url, token: token)),
                    );
                  },
                  child: Icon(Icons.check)
              ),
            ],
          );
        }
    );
  }
  static void accepted({required BuildContext context, required player1, required player2, required token, required gameId, required url}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext){
          return AlertDialog(
            title: Text('هورا',
              style: AppTypography.semiBold30,
              textDirection: TextDirection.rtl,),
            content: Text('قبول کرد. بریم؟',
              style: AppTypography.semiBold14,
              textDirection: TextDirection.rtl,),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async{
                    pushReplacementWithoutAnimation(context, OnlineGame(player1: player1, player2: player2, token: token, gameId: gameId, url: url,));
                  },
                  child: Icon(Icons.check)
              ),
            ],
          );
        }
    );
  }
  static Future<void> failed({required String message, required context}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('ای وای',
              style: AppTypography.semiBold30,
              textDirection: TextDirection.rtl,),
            content: Text( message,
              style: AppTypography.semiBold14,
              textDirection: TextDirection.rtl,),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.check)
              ),
            ],
          );
        }
    );
  }
  // static void failedRepeatPassword(BuildContext context){
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context){
  //         return AlertDialog(
  //           title: Text('ای وای',
  //             style: AppTypography.semiBold30,
  //             textDirection: TextDirection.rtl,),
  //           content: Text( 'تکرار رمز عبور با رمز عبورت یکی نیست!',
  //             style: AppTypography.semiBold14,
  //             textDirection: TextDirection.rtl,),
  //           actions: <Widget>[
  //             ElevatedButton(
  //                 onPressed: (){
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Icon(Icons.check)
  //             ),
  //           ],
  //         );
  //       }
  //   );
  // }
  static Future<void> success({required String message, required context, required String token, required String url}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('تبریک',
              style: AppTypography.semiBold30,
              textDirection: TextDirection.rtl,),
            content: Text( message,
              style: AppTypography.semiBold14,
              textDirection: TextDirection.rtl,),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                    amatis(context: context, token: token, url: url);
                  },
                  child: Icon(Icons.check)
              ),
            ],
          );
        }
    );
  }
  static void showResult({required BuildContext context, required question, required message, required action}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext){
          return AlertDialog(
            title: Text(action == '1' ? 'انجام شد' : 'انجام نشد',
              style: AppTypography.semiBold30,
              textDirection: TextDirection.rtl,),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  Text(question,
                    style: AppTypography.semiBold14,
                    textDirection: TextDirection.rtl,),
                  SizedBox(height: 50,),
                  Text(message != 'default message' ? message : '',
                    style: AppTypography.semiBold14,
                    textDirection: TextDirection.rtl,),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(dialogContext);
                  },
                  child: Icon(Icons.check)
              ),
            ],
          );
        }
    );
  }
  static void amatis({required BuildContext context, required token, required url}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('نسخه آزمایشی',
              style: AppTypography.semiBold30,
              textDirection: TextDirection.rtl,),
            content: Text( 'توسعه یافته توسط amatisdana.com',
              style: AppTypography.semiBold14,
              textDirection: TextDirection.rtl,),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage(token: token, url: url)),
                    );
                  },
                  child: Icon(Icons.check)
              ),
            ],
          );
        }
    );
  }
  static void inviteSent({required BuildContext context}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('تبریک',
              style: AppTypography.semiBold30,
              textDirection: TextDirection.rtl,),
            content: Text( 'دعوتنامه با موفقیت ارسال شد',
              style: AppTypography.semiBold14,
              textDirection: TextDirection.rtl,),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.check)
              ),
            ],
          );
        }
    );
  }
  static void showError({required BuildContext context}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext){
          return AlertDialog(
            title: Text('ای وای',
              style: AppTypography.semiBold30,
              textDirection: TextDirection.rtl,),
            content: Text('باید دوباره وارد بشی',
              style: AppTypography.semiBold14,
              textDirection: TextDirection.rtl,),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async{
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OnlineRoom()),
                    );
                  },
                  child: Icon(Icons.check)
              ),
            ],
          );
        }
    );
  }
}