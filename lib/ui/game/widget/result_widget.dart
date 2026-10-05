import 'package:flutter/material.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/view_model/player_score.dart';
import 'package:qwixx/ui/game/widget/control/die_widget.dart';
import 'package:qwixx/ui/lobby/widget/lobby_screen.dart';

class ResultWidget extends StatelessWidget {
  const new({
    super.key,
    required this.viewModel,
    required this.playerScores,
    required this.isGameOver,
  });

  final GameViewModel viewModel;
  final List<PlayerScore> playerScores;
  final bool isGameOver;

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: playerScores.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 4);
      },
      itemBuilder: (context, index) => ListTile(
        tileColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        leading: Icon(index == 0 ? Icons.emoji_events : Icons.assist_walker),
        title: Row(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(fromPlayerKind(playerScores[index].player.kind)),
            Text(
              playerScores[index].player.name,
              style: TextTheme.of(context).bodyLarge!.copyWith(
                color: playerScores[index].player.uuid == viewModel.playerId
                    ? Colors.green
                    : null,
              ),
            ),
          ],
        ),
        subtitle: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              TextSpan(
                text: playerScores[index].red.toString(),
                style: TextStyle(color: fromQwixx(GameColor.red)),
              ),
              const TextSpan(text: ' + '),
              TextSpan(
                text: playerScores[index].yellow.toString(),
                style: TextStyle(color: fromQwixx(GameColor.yellow)),
              ),
              const TextSpan(text: ' + '),
              TextSpan(
                text: playerScores[index].green.toString(),
                style: TextStyle(color: fromQwixx(GameColor.green)),
              ),
              const TextSpan(text: ' + '),
              TextSpan(
                text: playerScores[index].blue.toString(),
                style: TextStyle(color: fromQwixx(GameColor.blue)),
              ),
              TextSpan(text: ' - ${playerScores[index].fails}'),
            ],
          ),
        ), //Text('5 + 4 + 3 + 17 - 15'),
        trailing: Text(
          '${playerScores[index].score}',
          style: TextTheme.of(context).headlineSmall,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.leaderboard),
              title: Text(
                'Leaderboard',
                style: TextTheme.of(context).headlineSmall,
              ),
              trailing: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close),
              ),
            ),
            const Divider(thickness: 2),
            Expanded(child: _buildList(context)),
            const Divider(thickness: 2),
            Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onPressed: () {
                    viewModel.deleteGateway();
                  },
                  child: Text('Leave game'),
                ),

                if (isGameOver)
                  ElevatedButton(
                    onPressed: () {
                      viewModel.deleteGame();
                    },
                    child: Text('Play again'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
