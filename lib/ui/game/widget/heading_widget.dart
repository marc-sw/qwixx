import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwixx/domain/game/state.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';

class HeadingWidget extends StatelessWidget {
  const new({super.key, required this.viewModel});

  final GameViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Selector<ValueNotifier<GameState>, GameState>(
      selector: (context, notifier) => notifier.value,
      shouldRebuild: (previous, next) =>
          previous.turn != next.turn || previous.phase != next.phase,
      builder: ((context, gameState, child) {
        final text = viewModel.generateInfoText(gameState);
        return AnimatedSwitcher(
          switchOutCurve: Curves.decelerate,
          switchInCurve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: Text(
            key: Key(text),
            text,
            style: TextTheme.of(context).headlineSmall,
            textAlign: TextAlign.center,
          ),
        );
      }),
    );
  }
}
