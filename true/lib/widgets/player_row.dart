import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:truth_or_dare/domain/name_manager.dart';
import 'package:truth_or_dare/widgets/widgets.dart';

class PlayerRow extends StatefulWidget {
  final int index;
  final VoidCallback onRemovePlayer;

  PlayerRow({required this.index, required this.onRemovePlayer});

  @override
  _PlayerRowState createState() => _PlayerRowState();
}

class _PlayerRowState extends State<PlayerRow> {
  late Future<Player> _playerFuture;
  String svgCode = '';

  @override
  void initState() {
    super.initState();
    _playerFuture = getPlayer();
  }

  Future<Player> getPlayer() async {
    List<Player> players = await NameManager.getSavedPlayers();
    return players[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _playerFuture,
      builder: (context, AsyncSnapshot<Player?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(height: 20, child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return SizedBox(height: 20);
        }
        Player player = snapshot.data!;
        svgCode = multiavatar(player.name + player.randomString);
        return buildPlayerRow(player);
      },
    );
  }

  Widget buildPlayerRow(Player player) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: RandomColorGenerator.getBothColors(player.name + player.randomString),
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, grade: 10, weight: 10, size: 30, color: Colors.white),
                onPressed: () => onDelete(player.name),
              ),
              Expanded(
                child: Text(
                  player.name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black87, fontFamily: 'Lalezar'),
                  textDirection: TextDirection.rtl,
                ),
              ),
              if (svgCode.isNotEmpty) // Check if svgCode is not empty before rendering SVG
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Material(
                    shape: CircleBorder(),
                    elevation: 3,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: SvgPicture.string(
                        svgCode,
                        height: 50,
                        width: 50,
                        placeholderBuilder: (BuildContext context) => CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Material(
          shape: CircleBorder(),
          elevation: 3,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: RandomColorGenerator.getBothColors(player.name + player.randomString),
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: Text(
                  '${widget.index + 1}',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  onDelete(String name) {
    NameManager.removePlayer(name);
    widget.onRemovePlayer();
  }
}
