import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';
import 'package:qwixx/config/game.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:qwixx/main.dart';

part 'card.dart';
part 'color.dart';
part 'rolls.dart';
part 'turn.dart';
part 'state.dart';
part 'row.dart';
part 'game.g.dart';

enum ActionResult { awaiting, skipped, marked }

final cardTiles = [
  for (final color in GameColor.values) ...[
    for (final number in color.range) Tile(color, number),
  ],
];
