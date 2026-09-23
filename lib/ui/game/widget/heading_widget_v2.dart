import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/widget/cardV2/status_widget.dart';

class HeadingWidgetV2 extends StatelessWidget {
  const new({super.key, required this.viewModel});

  final GameViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel.gameOverNotifier,
      builder: (context, value, child) {
        if (!value) {
          return child!;
        }
        return Text('Spiel vorbei', style: TextTheme.of(context).headlineSmall);
      },
      child: Row(
        spacing: 15,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final card in viewModel.cardViewModels)
            Transform.scale(
              scale: 2,
              child: CardStatusWidget(
                decorationListenable: card.statusListenable,
              ),
            ),
        ],
      ),
    );
  }
}
