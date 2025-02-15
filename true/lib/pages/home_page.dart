import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supabase_chat_core/flutter_supabase_chat_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:truth_or_dare/domain/domains.dart';
import 'package:truth_or_dare/pages/util.dart';
import 'package:truth_or_dare/shared/theme/typography.dart';
import '../domain/message.dart';
import '../widgets/widgets.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;
  final url='https://oo9.ir';

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        setState(() {
          _user = data.session?.user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;
    types.User? otherUser;

    if (room.type == types.RoomType.direct) {
      try {
        otherUser = room.users.firstWhere(
          (u) => u.id != _user!.id,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if the other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';
    final Widget child = CircleAvatar(
      backgroundColor: hasImage ? Colors.transparent : color,
      backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
      radius: 20,
      child: !hasImage
          ? Text(
              name.isEmpty ? '' : name[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            )
          : null,
    );
    if (otherUser == null) {
      return Container(
        margin: EdgeInsets.only(right: 16.w),
        child: child,
      );
    }

    // Se `otherUser` non è null, la stanza è diretta e possiamo mostrare l'indicatore di stato online.
    return Container(
      margin: EdgeInsets.only(right: 16.w),
      child: UserOnlineStatusWidget(
        uid: otherUser.id,
        builder: (status) => Stack(
          alignment: Alignment.bottomRight,
          children: [
            child,
            if (status == UserOnlineStatus.online) // Assumendo che `status` indichi lo stato online
              Container(
                width: 10.w,
                height: 10.w,
                margin: const EdgeInsets.only(right: 3, bottom: 3),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   // actions: [
      //   //   IconButton(
      //   //     icon: const Icon(
      //   //       Icons.add,
      //   //     ),
      //   //     onPressed: _user == null
      //   //         ? null
      //   //         : () {
      //   //             Navigator.of(context).push(
      //   //               MaterialPageRoute(
      //   //                 fullscreenDialog: true,
      //   //                 builder: (context) => const UsersPage(),
      //   //               ),
      //   //             );
      //   //           },
      //   //   ),
      //   // ],
      //   // leading: IconButton(
      //   //   icon: const Icon(Icons.logout),
      //   //   onPressed: _user == null ? null : logout,
      //   // ),
      //   systemOverlayStyle: SystemUiOverlayStyle.light,
      //   toolbarHeight: 85.h,
      //   backgroundColor: Colors.black,
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   title: Text('جرات و حقیقت', style: AppTypography.extraBold48),
      // ),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  child: Text('بازیت رو انتخاب کن', style: AppTypography.extraBold24),
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      child: ModeCard(
                        color: Color.fromRGBO(30, 180, 250, 100),
                        imageUrl: 'iternity1.png',
                        title: 'دوستی آنلاین',
                        description: 'می‌خوای با دوستای جدید بازی کنی؟',
                        mode: TruthOrDareCategory.lvl5,
                        number: '200',
                        isChat: true,
                        url: url,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ModeCard(
                      color: Colors.white38,
                      imageUrl: 'normal.png',
                      title: 'دوست معمولی',
                      description: 'مناسب جمع خانوادگی و دوستی‌های جدید. خنده دار با چالش‌های ساده',
                      mode: TruthOrDareCategory.lvl1,
                      number: '197',
                      isChat: false,
                    ),
                    ModeCard(
                      color: Color.fromRGBO(55, 125, 241, 150),
                      imageUrl: 'close.png',
                      title: 'دوست صمیمی',
                      description: 'مناسب رفاقت‌های چندساله. خجالت رو کنار بذارین و بقیه رو به چالش بکشین!',
                      mode: TruthOrDareCategory.lvl2,
                      number: '219',
                      isChat: false,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ModeCard(
                      color: Color.fromRGBO(210, 223, 66, 150),
                      imageUrl: 'iternity.png',
                      title: 'دوست ابدی',
                      description: 'مناسب رفقایی که دیگه چیزی برای از دست دادن ندارن! نیمه تاریک بقیه رو بهتر بشناسین!',
                      mode: TruthOrDareCategory.lvl3,
                      number: '209',
                      isChat: false,
                    ),
                    ModeCard(
                      color: Color.fromRGBO(206, 26, 115, 150),
                      imageUrl: 'love.png',
                      title: 'دوستی عاشقانه',
                      description: 'کسی که دوستش داری کلی داستان داره که برات نگفته! این سوالات مخصوص زوج‌های عاشقه که می‌خوان بیشتر همو بشناسن!',
                      mode: TruthOrDareCategory.lvl6,
                      number: '200',
                      isChat: false,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ModeCard(
                      color: Color.fromRGBO(237, 67, 35, 167),
                      imageUrl: 'hot.png',
                      title: 'دوستی داغ',
                      description: 'می‌خوای داغتر بشه، فک‌ می‌کنی بتونین تحمل کنین؟',
                      mode: TruthOrDareCategory.lvl5,
                      number: '200',
                      isChat: false,
                    ),
                    ModeCard(
                      color: Colors.orangeAccent,
                      imageUrl: 'breath1.png',
                      title: 'دوستی نفس‌گیر',
                      description: 'به منطقه ممنوعه سوالات و چالش‌ها خوش اومدین! وقتشه از خط قرمز رد بشین!',
                      mode: TruthOrDareCategory.lvl4,
                      number: '?',
                      isChat: false,
                    ),
                  ],
                ),

                // _user == null
                //     ? Container(
                //         alignment: Alignment.center,
                //         margin: const EdgeInsets.only(
                //           bottom: 200,
                //         ),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             const Text('Not authenticated'),
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).push(
                //                   MaterialPageRoute(
                //                     fullscreenDialog: true,
                //                     builder: (context) => const AuthScreen(),
                //                   ),
                //                 );
                //               },
                //               child: const Text('Login'),
                //             ),
                //           ],
                //         ),
                //       )
                //     : StreamBuilder<List<types.Room>>(
                //         stream: SupabaseChatCore.instance.rooms(),
                //         initialData: const [],
                //         builder: (context, snapshot) {
                //           if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //             return Container(
                //               alignment: Alignment.center,
                //               margin: const EdgeInsets.only(
                //                 bottom: 200,
                //               ),
                //               child: const Text('No rooms'),
                //             );
                //           }
                //           return ListView.builder(
                //             itemCount: snapshot.data!.length,
                //             itemBuilder: (context, index) {
                //               final room = snapshot.data![index];
                //               return ListTile(
                //                 key: ValueKey(room.id),
                //                 leading: _buildAvatar(room),
                //                 title: Text(room.name ?? ''),
                //                 subtitle: Text(
                //                     '${timeago.format(DateTime.now().subtract(Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - (room.updatedAt ?? 0))), locale: 'en_short')} ${room.lastMessages != null && room.lastMessages!.isNotEmpty && room.lastMessages!.first is types.TextMessage ? (room.lastMessages!.first as types.TextMessage).text : ''}'),
                //                 onTap: () {
                //                   Navigator.of(context).push(
                //                     MaterialPageRoute(
                //                       builder: (context) => ChatPage(
                //                         room: room,
                //                       ),
                //                     ),
                //                   );
                //                 },
                //               );
                //             },
                //           );
                //         },
                //       ),
              ],
            ),
          ),
        )
      ]),
    );
  }

}
