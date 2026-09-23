import 'package:flutter/foundation.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:qwixx/main.dart';
import 'package:qwixx/ui/game/view_model/card/card_row_viewmodel.dart';
import 'package:qwixx/ui/game/view_model/card/card_tile_viewmodel.dart';

enum FailDecoration { none, markable, marked }

enum StatusDecoration { done, marking, rolling }

class CardViewModel {
  final List<CardRowViewModel> cardRowViewModels;
  final List<ValueNotifier<FailDecoration>> failDecorationListenables;
  final ValueNotifier<int> failScoreListenable;
  final ValueNotifier<int> resultScoreListenable;
  final ValueNotifier<StatusDecoration> statusListenable;
  final void Function(int) onFailTap;
  final Player player;
  final bool highlighted;

  new({
    required this.cardRowViewModels,
    required this.failDecorationListenables,
    required this.onFailTap,
    required this.failScoreListenable,
    required this.resultScoreListenable,
    required this.player,
    required this.statusListenable,
    this.highlighted = false,
  });

  factory CardViewModel.init(
    GameCard card,
    void Function(Tile) onTileTap,
    void Function(int) onFailTip,
    bool highlighted,
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
      player: player,
      statusListenable: ValueNotifier(StatusDecoration.done),
      highlighted: highlighted,
    );
  }

  factory CardViewModel.test() {
    final rows = GameColor.values
        .map(
          (color) => CardRowViewModel(
            cardTileViewModels: color.range
                .map(
                  (number) => CardTileViewModel(
                    decorationListenable: ValueNotifier(
                      TileDecoration.markable,
                    ),
                    onTap: (tile) {
                      print('tapped $tile');
                    },
                    tile: Tile(color, number),
                  ),
                )
                .toList(),
            scoreListenable: ValueNotifier(2),
            gameColor: color,
          ),
        )
        .toList();
    final player = Player(uuid.v4(), 'Marc', PlayerKind.client);
    return CardViewModel(
      cardRowViewModels: rows,
      failDecorationListenables: [
        ValueNotifier(FailDecoration.marked),
        ValueNotifier(FailDecoration.marked),
        ValueNotifier(FailDecoration.markable),
        ValueNotifier(FailDecoration.none),
      ],
      resultScoreListenable: ValueNotifier(13),
      failScoreListenable: ValueNotifier(10),
      statusListenable: ValueNotifier(StatusDecoration.done),
      onFailTap: (i) => print('tapped fail $i'),
      player: player,
    );
  }
}
