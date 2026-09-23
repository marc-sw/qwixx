import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/ui/game/widget/control/die_widget.dart';

enum TileDecoration { none, marked, skipped, markable }

class CardTileViewModel {
  final ValueNotifier<TileDecoration> decorationListenable;
  final void Function(Tile) onTap;
  final Tile tile;

  new({
    required this.decorationListenable,
    required this.onTap,
    required this.tile,
  });

  Color get color => fromQwixx(tile.color);
}
