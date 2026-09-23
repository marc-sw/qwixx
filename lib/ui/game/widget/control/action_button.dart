import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/widget/result_widget.dart';

class ActionButton extends StatelessWidget {
  const new({super.key, required this.viewModel});

  final GameViewModel viewModel;

  Widget _buildRollDice(BuildContext context) {
    return Center(
      key: Key('roll'),
      child: ElevatedButton(
        onPressed: viewModel.onDiceRoll,
        child: Text('Würfeln', style: TextTheme.of(context).bodyLarge),
      ),
    );
  }

  Widget _buildSkip(BuildContext context, GameTurn gameTurn) {
    bool miss =
        gameTurn.isActiveCard(
          viewModel.gameStateNotifier.value.cardIndexOf(viewModel.playerId),
        ) &&
        !gameTurn.didAnyAction(
          viewModel.gameStateNotifier.value.cardIndexOf(viewModel.playerId),
        );
    if (miss) {
      return SizedBox.shrink();
    }
    return Center(
      key: Key('skip'),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.green,
          foregroundColor: miss ? Colors.red.shade100 : Colors.green.shade200,
        ),
        onPressed: viewModel.onSkipTap,
        child: Text('Skip', style: TextTheme.of(context).bodyLarge),
      ),
    );
  }

  Widget _buildContent(BuildContext context, GameTurn turn) {
    if (viewModel.gameOverNotifier.value) {
      return ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context2) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 500,
                    height: 700,
                    child: ResultWidget(
                      viewModel: viewModel,
                      playerScores: viewModel.generatePlayerScores(
                        viewModel.gameStateNotifier.value.cards,
                      ),
                      isGameOver: viewModel.gameStateNotifier.value.isGameOver,
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Text('Ergebniss'),
      );
    }
    if (viewModel.canRoll()) {
      return _buildRollDice(context);
    }
    if (viewModel.canSkip()) {
      return _buildSkip(context, turn);
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ValueNotifier<GameState>, GameTurn>(
      selector: (context, notifier) => notifier.value.turn,
      builder: ((context, value, child) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: _buildContent(context, value),
      )),
    );
  }
}
