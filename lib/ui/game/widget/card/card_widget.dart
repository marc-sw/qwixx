import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qwixx/config/game.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';

part 'card_widget_math.dart';

const int columns = 4;
const int rows = 11;

class CardWidget extends StatelessWidget {
  new({super.key, required this.index, required this.viewModel})
    : player = viewModel.gameStateNotifier.value.cards[index].player;

  final int index;
  final Player player;
  final GameViewModel viewModel;

  Widget _buildMisses(BuildContext context) {
    return Positioned(
      top: _missContainerConfig.topOffset,
      left: _missContainerConfig.leftOffset,
      child: Selector<ValueNotifier<GameState>, int>(
        selector: (context, notifier) => notifier.value.cards[index].misses,
        builder: (context, value, child) => SizedBox.fromSize(
          size: Size(
            _missContainerConfig.mainAxisSize,
            _missContainerConfig.crossAxisSize,
          ),
          child: Row(
            spacing: _missContainerConfig.spacing,
            children: [
              for (var miss = 0; miss < value; miss++)
                Transform.scale(
                  scale: 1.9,
                  child: Icon(Icons.close)
                      .animate()
                      .scale(duration: 150.ms)
                      .fade(duration: 150.ms),
                ),

              if (value < 4)
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        throw UnimplementedError('not implemented, outdated'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLock(BuildContext context, bool openRow, bool marked) {
    Widget? child;
    if (marked) {
      child = Transform.scale(
        scale: 3,
        child: Icon(Icons.close),
      ).animate().scale(duration: 150.ms).fade(duration: 150.ms);
    } else if (!openRow) {
      child = Transform.scale(
        scale: 3.5,
        child: Icon(Icons.remove),
      ).animate().scale(duration: 150.ms).fade(duration: 150.ms);
    }
    return SizedBox.fromSize(size: Size(48, 48), child: child);
  }

  Widget _buildNumberV2(
    BuildContext context,
    bool openRow,
    bool marked,
    int column,
    int row,
  ) {
    Widget? child = player.uuid == viewModel.playerId
        ? GestureDetector(
            onTap: () => viewModel.onTileTap(player.uuid, column, row),
          )
        : null;
    if (marked) {
      child = Transform.scale(
        scale: 3,
        child: Icon(Icons.close),
      ).animate().scale(duration: 150.ms).fade(duration: 150.ms);
    } else if (!openRow) {
      child = Transform.scale(
        scale: 3.5,
        child: Icon(Icons.remove),
      ).animate().scale(duration: 150.ms).fade(duration: 150.ms);
    }
    return SizedBox.fromSize(size: Size(48, 48), child: child);
  }

  Widget _buildNumbers(BuildContext context) {
    return Positioned(
      top: 23,
      left: 35,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 17,
        children: List.generate(4, (column) {
          return Selector<ValueNotifier<GameState>, bool>(
            selector: (context, notifier) =>
                notifier.value.diceRolls.hasColor(GameColor.byIndex(column)),
            builder: (context, open, child) {
              return Row(
                spacing: 1,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(12, (row) {
                  return Selector<ValueNotifier<GameState>, bool>(
                    selector: (context, notifier) =>
                        notifier.value.cards[index].rows[column].isMarked(
                          NumberOrder.byColor(GameColor.byIndex(column))
                              .numberAt(
                                row > GameConfig.lastRowIndex
                                    ? GameConfig.lastRowIndex
                                    : row,
                              ),
                        ),
                    builder: (context, marked, child) {
                      return row > GameConfig.lastRowIndex
                          ? _buildLock(context, open, marked)
                          : _buildNumberV2(context, open, marked, column, row);
                    },
                  );
                }),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          player.name,
          style: TextTheme.of(context).bodyLarge!.copyWith(
            color: player.uuid == viewModel.playerId ? Colors.green : null,
          ),
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Stack(
              children: [
                Image.asset('assets/image/qwixx_board.png'),
                _buildNumbers(context),
                _buildMisses(context),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
