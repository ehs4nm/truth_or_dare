import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsell_plus/tapsell_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:truth_or_dare/domain/tapsel.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AdHelper {
  static Future<void> _initializeZoneId() async {
    Map<String, String> zoneIds = TapsellConstant.zoneIds['Tapsell']!;
    String zoneId = zoneIds["STANDARD"] ?? "";
    if (zoneId.isEmpty) {
      throw Exception("Zone ID for STANDARD is not available");
    }
    _zoneId = zoneId;
  }

  static Future<bool> checkInternetConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;

    return result;
  }

  static String _zoneId = "";

  static void requestStandardBannerAd() async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) return;

    await _initializeZoneId();
    TapsellPlus.instance.requestStandardBannerAd(
      _zoneId,
      TapsellPlusBannerType.BANNER_320x100,
      onResponse: (map) {
        String responseId = map['response_id'] ?? '';
        if (responseId.isNotEmpty) {
          TapsellPlus.instance.showStandardBannerAd(
            responseId,
            TapsellPlusHorizontalGravity.BOTTOM,
            TapsellPlusVerticalGravity.CENTER,
            margin: const EdgeInsets.only(top: 100),
            onOpened: (map) {},
            onError: (map) {
              return;
            },
          );
        }
      },
      onError: (map) {},
    );
  }

  static Future<String> requestVideoAd() async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) return '';

    String responseId = '';
    // await _initializeZoneId();
    // String zoneId = TapsellConstant.zoneIds['Tapsell']?["INTERSTITIAL"] ?? "";
    String zoneIdRewarded = TapsellConstant.zoneIds['Tapsell']?["REWARDED"] ?? "";

    if (zoneIdRewarded.isEmpty) return responseId;

    try {
      responseId = await TapsellPlus.instance.requestRewardedVideoAd(zoneIdRewarded);
    } catch (e) {
      print("Error requesting RewardedVideo ad: $e");
      return responseId;
    }
    return responseId;
  }

  static Future<bool> showVideoAd(int index, String responseId) async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected || responseId.isEmpty) return false;

    final Completer<bool> completer = Completer<bool>();

    try {
      await TapsellPlus.instance.showRewardedVideoAd(
        responseId,
        onOpened: (map) {
          print('onOpened');
        },
        onError: (map) {
          print('onError');
          completer.complete(false);
        },
        onRewarded: (map) {
          print('onRewarded');
          // await AdHelper.addUnlockedStoryIndex(index);
          completer.complete(true);
        },
        onClosed: (map) {
          print('onClosed');
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
      );

      return completer.future;
    } catch (e) {
      return false;
    }
  }

  static Future<void> saveUnlockedStoryIndexes(List<int> indexes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('unlocked_story_indexes', indexes.map((i) => i.toString()).toList());
  }

  static Future<List<int>> getUnlockedStoryIndexes() async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('unlocked_story_indexes');
    List<String>? stringList = prefs.getStringList('unlocked_story_indexes');
    if (stringList != null) {
      return stringList.map((i) => int.parse(i)).toList();
    }
    return [];
  }

  static Future<void> addUnlockedStoryIndex(int index) async {
    List<int> unlockedIndexes = await getUnlockedStoryIndexes();
    if (!unlockedIndexes.contains(index)) {
      unlockedIndexes.add(index);
      await saveUnlockedStoryIndexes(unlockedIndexes);
    }
  }

  static Future<bool> isStoryUnlocked(int storyIndex) async {
    List<int> unlockedIndexes = await getUnlockedStoryIndexes();
    return unlockedIndexes.contains(storyIndex);
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/9214589741";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544~3347511713";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
