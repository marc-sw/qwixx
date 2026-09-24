import 'package:flutter/foundation.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:qwixx/ui/game/view_model/card/card_row_viewmodel.dart';
import 'package:qwixx/ui/game/view_model/card/card_tile_viewmodel.dart';

enum FailDecoration { none, markable, marked }

enum StatusDecoration { done, skipable, penable, rollable }

class CardViewModel {
  final List<CardRowViewModel> cardRowViewModels;
  final List<ValueNotifier<FailDecoration>> failDecorationListenables;
  final ValueNotifier<int> failScoreListenable;
  final ValueNotifier<int> resultScoreListenable;
  final ValueNotifier<StatusDecoration> statusListenable;
  final void Function(int) onFailTap;
  final void Function() onRollTap;
  final void Function() onSkipTap;
  final bool isActor;
  final Player player;

  new({
    required this.cardRowViewModels,
    required this.failDecorationListenables,
    required this.onFailTap,
    required this.failScoreListenable,
    required this.resultScoreListenable,
    required this.player,
    required this.statusListenable,
    required this.onRollTap,
    required this.onSkipTap,
    required this.isActor,
  });

  factory CardViewModel.init(
    GameCard card,
    void Function(Tile) onTileTap,
    void Function(int) onFailTip,
    void Function() onRollTap,
    void Function() onSkipTap,
    bool isActor,
  ) {
    final rows = GameColor.values
        .map(
          (color) => CardRowViewModel(
            cardTileViewModels: color.range
                .map(
                  (number) => CardTileViewModel(
                    decorationListenable: ValueNotifier(TileDecoration.none),
                    onTap: onTileTap,
                    tile: Tile(color, number),
                  ),
                )
                .toList(),
            scoreListenable: ValueNotifier(0),
            gameColor: color,
          ),
        )
        .toList();
    final player = card.player;
    return CardViewModel(
      cardRowViewModels: rows,
      failDecorationListenables: [
        ValueNotifier(FailDecoration.none),
        ValueNotifier(FailDecoration.none),
        ValueNotifier(FailDecoration.none),
        ValueNotifier(FailDecoration.none),
      ],
      resultScoreListenable: ValueNotifier(0),
      failScoreListenable: ValueNotifier(0),
      onFailTap: onFailTip,
      onRollTap: onRollTap,
      onSkipTap: onSkipTap,
      isActor: isActor,
      player: player,
      statusListenable: ValueNotifier(StatusDecoration.done),
    );
  }
}
