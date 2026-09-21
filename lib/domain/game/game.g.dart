// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameCard _$GameCardFromJson(Map<String, dynamic> json) => GameCard(
  player: Player.fromJson(json['player'] as Map<String, dynamic>),
  rows: (json['rows'] as List<dynamic>)
      .map((e) => GameRow.fromJson(e as Map<String, dynamic>))
      .toList(),
  misses: (json['misses'] as num).toInt(),
);

Map<String, dynamic> _$GameCardToJson(GameCard instance) => <String, dynamic>{
  'player': instance.player.toJson(),
  'rows': instance.rows.map((e) => e.toJson()).toList(),
  'misses': instance.misses,
};

Tile _$TileFromJson(Map<String, dynamic> json) => Tile(
  $enumDecode(_$GameColorEnumMap, json['color']),
  (json['number'] as num).toInt(),
);

Map<String, dynamic> _$TileToJson(Tile instance) => <String, dynamic>{
  'color': _$GameColorEnumMap[instance.color]!,
  'number': instance.number,
};

const _$GameColorEnumMap = {
  GameColor.red: 'red',
  GameColor.yellow: 'yellow',
  GameColor.green: 'green',
  GameColor.blue: 'blue',
};

DiceRolls _$DiceRollsFromJson(Map<String, dynamic> json) => DiceRolls(
  (json['white'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
  (json['colored'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$GameColorEnumMap, k), (e as num).toInt()),
  ),
  (json['whiteTargets'] as List<dynamic>)
      .map((e) => Tile.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['coloredTargets'] as List<dynamic>)
      .map((e) => Tile.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DiceRollsToJson(DiceRolls instance) => <String, dynamic>{
  'white': instance.white,
  'colored': instance.colored.map(
    (k, e) => MapEntry(_$GameColorEnumMap[k]!, e),
  ),
  'whiteTargets': instance.whiteTargets.map((e) => e.toJson()).toList(),
  'coloredTargets': instance.coloredTargets.map((e) => e.toJson()).toList(),
};

GameTurn _$GameTurnFromJson(Map<String, dynamic> json) => GameTurn(
  (json['activeCardIndex'] as num).toInt(),
  json['activePlayerFirstMarkedTile'] == null
      ? null
      : Tile.fromJson(
          json['activePlayerFirstMarkedTile'] as Map<String, dynamic>,
        ),
  (json['playerResults'] as List<dynamic>)
      .map((e) => $enumDecode(_$ActionResultEnumMap, e))
      .toList(),
  json['rolled'] as bool,
);

Map<String, dynamic> _$GameTurnToJson(GameTurn instance) => <String, dynamic>{
  'activeCardIndex': instance.activeCardIndex,
  'activePlayerFirstMarkedTile': instance.activePlayerFirstMarkedTile?.toJson(),
  'playerResults': instance.playerResults
      .map((e) => _$ActionResultEnumMap[e]!)
      .toList(),
  'rolled': instance.rolled,
};

const _$ActionResultEnumMap = {
  ActionResult.awaiting: 'awaiting',
  ActionResult.skipped: 'skipped',
  ActionResult.marked: 'marked',
};

GameState _$GameStateFromJson(Map<String, dynamic> json) => GameState(
  cards: (json['cards'] as List<dynamic>)
      .map((e) => GameCard.fromJson(e as Map<String, dynamic>))
      .toList(),
  diceRolls: DiceRolls.fromJson(json['diceRolls'] as Map<String, dynamic>),
  turn: GameTurn.fromJson(json['turn'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
  'cards': instance.cards.map((e) => e.toJson()).toList(),
  'diceRolls': instance.diceRolls.toJson(),
  'turn': instance.turn.toJson(),
};

GameRow _$GameRowFromJson(Map<String, dynamic> json) => GameRow(
  (json['markedNumbers'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$GameRowToJson(GameRow instance) => <String, dynamic>{
  'markedNumbers': instance.markedNumbers,
};
