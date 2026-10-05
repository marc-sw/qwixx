import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/widget/cardV2/status_widget.dart';

class HeadingWidgetV2 extends StatelessWidget {
  const new({super.key, required this.viewModel, required this.onTap});

  final GameViewModel viewModel;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel.gameOverNotifier,
      builder: (context, value, child) {
        if (!value) {
          return child!;
        }
        return Text(
          'Game over',
          style: TextTheme.of(context).headlineSmall!
              .copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        );
      },
      child: Center(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withAlpha(75),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.hardEdge,
            child: Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final entry in viewModel.cardViewModels.asMap().entries)
                  GestureDetector(
                    onTap: () => onTap(entry.key),
                    child: Transform.scale(
                      scale: 2,
                      child: CardStatusWidget(
                        decorationListenable: entry.value.statusListenable,
                        isActor: viewModel.playerId == entry.value.player.uuid,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
