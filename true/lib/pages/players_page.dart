import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:truth_or_dare/domain/ad_helper.dart';
import 'package:truth_or_dare/main.dart';
import 'package:truth_or_dare/pages/pages.dart';
import 'package:truth_or_dare/shared/theme/typography.dart';
import 'package:truth_or_dare/domain/domains.dart';
import 'package:truth_or_dare/utils/no_animation_navigator_push.dart';

import '../widgets/widgets.dart';

class PlayerListPage extends StatefulWidget {
  @override
  _PlayerListPageState createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  late List<Player> players = [];
  late Future<List<Player>> _playersFuture;
  String responseId = '';
  bool loading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();
    _playersFuture = _fetchPlayers();
  }

  Future<List<Player>> _fetchPlayers() async {
    return NameManager.getSavedPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 35),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('کیا بازی میکنن؟', style: AppTypography.extraBold32),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .82,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(children: [
              PlayerInputRow(onAddPlayer: playersChanged),
              Expanded(
                child: FutureBuilder<List<Player>>(
                    future: _playersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Player> players = snapshot.data ?? [];
                        return ListView.builder(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: players.length,
                            itemBuilder: (context, index) {
                              return PlayerRow(index: index, onRemovePlayer: playersChanged);
                            });
                      }
                    }),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TrapezoidButton(
                    onPressed: () => validatePlayersAndNavigate(),
                    enabled: true,
                    child: Text('ادامه', style: AppTypography.extraBlackBold24),
                  ),
                ),
              ),
            ]),
          ),
          loading
              ? Center(
            child: LoadingAnimationWidget.dotsTriangle(
              color: Colors.orange[600]!,
              size: 50.w,
            ),
          )
              : Container()
        ],
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(15.0),
      //   child: TrapezoidButton(
      //     onPressed: () => validatePlayersAndNavigate(),
      //     enabled: true,
      //     child: Text('ادامه', style: AppTypography.extraBlackBold24),
      //   ),
      // ),
    );
  }

  void validatePlayersAndNavigate() async {
    int playersNumber = await NameManager.countPlayers();
    if (playersNumber < 2) return showSnack('باید حداقل دو نفر باشین');
    setState(() {
      loading = true;
    });
    // final gameModel = Provider.of<GameModel>(context, listen: false);
    // gameModel.setPlayers(players);

    NameManager.setAllPlayersPointsToZero();
    final gameModel = Provider.of<GameModel>(context, listen: false);

    // int gamePlayed = gameModel.gamePlayed;
    gameModel.countGamePlayed();
    // if (gamePlayed.isOdd) {
    // String responseId = '';
    // Map<String, String> zoneIds = TapsellConstant.zoneIds['Tapsell']!;
    // String zoneId = zoneIds["INTERSTITIAL"] ?? "";
    // if (zoneId.isEmpty) {
    //   return;
    // }

    responseId = await AdHelper.requestVideoAd();
    bool userWatchedAd = await AdHelper.showVideoAd(1, responseId);
    setState(() {
      loading = false;
    });
    if (userWatchedAd) {
      pushWithoutAnimation(context, ChallengeTypeSelectionPage());
    } else {
      showPleaseWatchad();
    }

    // TapsellPlus.instance.requestInterstitialAd(zoneId).then((value) {
    //   responseId = value;

    //   if (responseId.isNotEmpty) {
    //     TapsellPlus.instance.requestRewardedVideoAd(responseId,
    //         onOpened: (map) => print('Interstitial 1'),
    //         onError: (map) => showPleaseWatchad(),
    //         onRewarded: (map) => pushWithoutAnimation(context, ChallengeTypeSelectionPage()),
    //         onClosed: (map) => showPleaseWatchad());
    //   }
    // });
    //   .catchError((error) {});
    // } else {
    //   pushWithoutAnimation(context, ChallengeTypeSelectionPage());
    // }

    return;
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          msg,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void playersChanged() {
    setState(() {
      _playersFuture = _fetchPlayers();
    });
  }

  showPleaseWatchad() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          'این تبلیغ فقط یکبار قبل از شروع بازی نمایش داده می‌شود. با دیدن کامل آن به ما کمک بزرگی می‌کنید.',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}