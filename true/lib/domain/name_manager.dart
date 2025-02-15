import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Player {
  String name;
  String gender;
  String randomString;
  int points;

  Player({required this.name, required this.gender, this.points = 0, this.randomString = ''});

  Map<String, dynamic> toJson() {
    return {'name': name, 'gender': gender, 'points': points, 'randomString': randomString};
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
        name: json['name'],
        gender: json['gender'],
        points: json['points'] ?? 0,
        randomString: json.containsKey('randomString') ? json['randomString'] : '');
  }
}

class NameManager {
  static const String _key = 'saved_players';
  static const String _initialPlayersAddedKey = 'initial_players_added';

  static Future<List<Player>> getSavedPlayers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPlayers = prefs.getString(_key);
    if (storedPlayers != null) {
      List<Player> players = (json.decode(storedPlayers) as List).map((playerJson) => Player.fromJson(playerJson)).toList();
      return players;
    } else {
      return [];
    }
  }

  static Future<void> savePlayer(Player player) async {
    List<Player> players = await getSavedPlayers();

    if (player.name.isEmpty) {
      throw Exception('Player name cannot be empty.');
    }

    if (players.any((savedPlayer) => savedPlayer.name == player.name)) {
      throw Exception('Player name must be unique.');
    }

    players.add(player);

    await savePlayersToSharedPreferences(players);
  }

  static Future<void> removePlayer(String name) async {
    List<Player> players = await getSavedPlayers();
    players.removeWhere((existingPlayer) {
      return existingPlayer.name == name;
    });
    await savePlayersToSharedPreferences(players);
  }

  static Future<void> saveAllPlayers(List<Player> players) async {
    for (Player player in players) {
      await savePlayer(player);
    }
  }

  static Future<Player?> getRandomPlayer() async {
    List<Player> players = await getSavedPlayers();

    if (players.isEmpty) return null;

    players.shuffle();
    return players.removeAt(0);
  }

  static Future<void> setAllPlayersPointsToZero() async {
    List<Player> players = await getSavedPlayers();

    for (Player player in players) {
      player.points = 0;
    }

    await savePlayersToSharedPreferences(players);
  }

  static Future<void> savePlayersToSharedPreferences(List<Player> players) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String playerEncode = json.encode(players.map((player) => player.toJson()).toList());
    prefs.setString(_key, playerEncode);
  }

  static Future<int> countPlayers() async {
    List<Player> players = await getSavedPlayers();
    return players.length;
  }

  static Future<void> addInitialPlayersIfNeeded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool initialPlayersAdded = prefs.getBool(_initialPlayersAddedKey) ?? false;
    if (!initialPlayersAdded) {
      List<Player> initialPlayers = [
        Player(name: 'Peyman', gender: 'Male'),
        Player(name: 'Sara', gender: 'Female'),
      ];

      await saveAllPlayers(initialPlayers);

      await prefs.setBool(_initialPlayersAddedKey, true);
    }
  }
}
