import 'package:flutter/material.dart';
import 'package:truth_or_dare/domain/name_manager.dart';
import 'package:truth_or_dare/shared/theme/typography.dart';
import 'package:truth_or_dare/widgets/widgets.dart';

class DialogContent extends StatelessWidget {
  final List<Player?> players;

  DialogContent({required this.players});

  @override
  Widget build(BuildContext context) {
    List<Player?> sortedPlayers = sortPlayersByPoints(players);
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .72),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff1E2952), RandomColorGenerator.lighten(Color(0xff1E2952), .2)],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('امتیازها', style: AppTypography.extraBold32),
                  ),
                  Container(
                    height: 200,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ListView.builder(
                        itemCount: sortedPlayers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  (index == 0 && sortedPlayers[index]!.points > sortedPlayers[index + 1]!.points)
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Image.asset('lib/assets/flat/cup.png', width: 20),
                                        )
                                      : Container(width: 25),
                                  Text(sortedPlayers[index]!.name, style: AppTypography.semiBold22),
                                ],
                              ),
                              Text('${sortedPlayers[index]!.points}', style: AppTypography.semiBold20),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo[900], elevation: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('بستن', style: AppTypography.semiBold17),
                    ),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Player?> sortPlayersByPoints(List<Player?> players) {
    // Remove null values and sort players by points
    List<Player?> sortedPlayers = players.where((player) => player != null).toList();
    sortedPlayers.sort((a, b) => b!.points.compareTo(a!.points));
    return sortedPlayers;
  }
}
