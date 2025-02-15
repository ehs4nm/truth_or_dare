import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supabase_chat_core/flutter_supabase_chat_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tapsell_plus/tapsell_plus.dart';
import 'package:truth_or_dare/domain/domains.dart';
import 'package:truth_or_dare/pages/pages.dart';
import 'package:truth_or_dare/domain/tapsel.dart';
import 'supabase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NameManager.addInitialPlayersIfNeeded();

  await Supabase.initialize(
    url: supabaseOptions.url,
    anonKey: supabaseOptions.anonKey,
  );

  runApp(ChangeNotifierProvider(create: (context) => GameModel(), child: MyApp()));
  TapsellPlus.instance.initialize(TapsellConstant.app_id);
}

var ctime;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'جرات حقیقت',
      home: UserOnlineStateObserver(child: MainApp()),
      theme: ThemeData.dark(),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      DateTime now = DateTime.now();
      if (ctime == null || now.difference(ctime) > Duration(seconds: 2)) {
        ctime = now;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            content: Text('برای خروج دوباره کلیک کنید', style: TextStyle(color: Colors.white), textDirection: TextDirection.rtl),
            backgroundColor: Colors.black));
        return Future.value(false);
      }

      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return HomePage();
        },
      ),
    );
  }
}
