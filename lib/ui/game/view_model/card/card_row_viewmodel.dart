import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/ui/game/view_model/card/card_tile_viewmodel.dart';
import 'package:qwixx/ui/game/widget/control/die_widget.dart';

class CardRowViewModel {
  final List<CardTileViewModel> cardTileViewModels;
  final ValueNotifier<int> scoreListenable;
  final GameColor gameColor;

  new({
    required this.cardTileViewModels,
    required this.scoreListenable,
    required this.gameColor,
  });

  Color get color => fromQwixx(gameColor);
}
