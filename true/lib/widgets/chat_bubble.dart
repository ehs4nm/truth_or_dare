import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../domain/message.dart';
import '../shared/theme/typography.dart';
import 'package:http/http.dart' as http;

class ChatBubble extends StatefulWidget {
  final String text;
  final bool isMine;
  final String id, user_id, username, token, url;
  final Uint8List? usrImg;
  final double size;

  const ChatBubble({required this.text, required this.isMine, required this.id, required this.user_id, required this.username, required this.token, required this.url, required this.usrImg, required this.size});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    fetchUserImage(widget.user_id);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isMine ? TextDirection.ltr : TextDirection.rtl,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width*widget.size,
            margin: widget.isMine ? EdgeInsets.fromLTRB(5, 10, 5, 10) : EdgeInsets.fromLTRB(5, 5, 10, 10),
            decoration: BoxDecoration(
              color: widget.isMine ? Color.fromRGBO(126, 93, 220, 1) : Color.fromRGBO(186, 179, 197, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.65,
                ),
                child: Text(
                  widget.text,
                  style: AppTypography.semiBold14black,
                  textDirection: TextDirection.rtl,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),

          ),
          widget.username != 'nadarim' ? InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => InviteDialog(
                  isMine: widget.isMine,
                  user_id: widget.id,
                  opponent_id: widget.user_id,
                  username: widget.username,
                  token: widget.token,
                  url: widget.url,
                  avatar: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: image != null ? MemoryImage(image!) : null,
                    child: image == null ? const Icon(Icons.person, size: 50,) : null,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: image != null ? MemoryImage(image!) : null,
              child: image == null ? const Icon(Icons.person) : null,
            ),
          )
          : CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: image != null ? MemoryImage(image!) : null,
            child: image == null ? const Icon(Icons.person) : null,
            ),
        ],
      ),
    );
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
        image = imageBytes;
      });
    }
  }
}
class InviteDialog extends StatefulWidget {
  final String user_id, opponent_id, username, token, url;
  final Widget avatar;
  final bool isMine;

  const InviteDialog({
    required this.user_id,
    required this.opponent_id,
    required this.username,
    required this.token,
    required this.url,
    required this.avatar,
    required this.isMine,

    Key? key,
  }) : super(key: key);

  @override
  _InviteDialogState createState() => _InviteDialogState();
}

class _InviteDialogState extends State<InviteDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Material(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(15.0)),
          child: Container(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.avatar,
                        Text(
                          widget.username,
                          style: AppTypography.semiBold30,
                        ),
                        Text(
                          'id: ${widget.opponent_id}',
                          style: AppTypography.semiBold30,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.1,
                          ),
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(84, 66, 134, 1),
                                Color.fromRGBO(105, 80, 177, 1),
                                Color.fromRGBO(126, 93, 220, 1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: !widget.isMine ? ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              var headers = {
                                'Authorization': 'Bearer ' + widget.token,
                              };
                              var request = http.MultipartRequest('POST', Uri.parse('${widget.url}/api/game/invite'));
                              request.fields.addAll({
                                'inviter_id': widget.user_id,
                                'invitee_id': widget.opponent_id
                              });

                              request.headers.addAll(headers);

                              try {
                                http.StreamedResponse response = await request.send();

                                if (response.statusCode == 200) {
                                  print(await response.stream.bytesToString());
                                  message.inviteSent(context: context);
                                } else {
                                  print(response.reasonPhrase);
                                }
                              } catch (e) {
                                print("Error sending invite: $e");
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                            ),
                            child: isLoading
                                ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                                : Text(
                              'دعوت به بازی',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ) : Container()
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

