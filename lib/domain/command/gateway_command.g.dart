// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gateway_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinCommand _$JoinCommandFromJson(Map<String, dynamic> json) => JoinCommand(
  json['issuerId'] as String,
  json['name'] as String,
  $enumDecode(_$PlayerKindEnumMap, json['kind']),
);

Map<String, dynamic> _$JoinCommandToJson(JoinCommand instance) =>
    <String, dynamic>{
      'issuerId': instance.issuerId,
      'name': instance.name,
      'kind': _$PlayerKindEnumMap[instance.kind]!,
    };

const _$PlayerKindEnumMap = {
  PlayerKind.host: 'host',
  PlayerKind.client: 'client',
  PlayerKind.bot: 'bot',
};

LeaveCommand _$LeaveCommandFromJson(Map<String, dynamic> json) =>
    LeaveCommand(json['issuerId'] as String);

Map<String, dynamic> _$LeaveCommandToJson(LeaveCommand instance) =>
    <String, dynamic>{'issuerId': instance.issuerId};

KickCommand _$KickCommandFromJson(Map<String, dynamic> json) =>
    KickCommand(json['issuerId'] as String, json['targetId'] as String);

Map<String, dynamic> _$KickCommandToJson(KickCommand instance) =>
    <String, dynamic>{
      'issuerId': instance.issuerId,
      'targetId': instance.targetId,
    };

MarkNumberCommand _$MarkNumberCommandFromJson(Map<String, dynamic> json) =>
    MarkNumberCommand(
      json['issuerId'] as String,
      $enumDecode(_$GameColorEnumMap, json['color']),
      (json['number'] as num).toInt(),
    );

Map<String, dynamic> _$MarkNumberCommandToJson(MarkNumberCommand instance) =>
    <String, dynamic>{
      'issuerId': instance.issuerId,
      'color': _$GameColorEnumMap[instance.color]!,
      'number': instance.number,
    };

const _$GameColorEnumMap = {
  GameColor.red: 'red',
  GameColor.yellow: 'yellow',
  GameColor.green: 'green',
  GameColor.blue: 'blue',
};

RollDiceCommand _$RollDiceCommandFromJson(Map<String, dynamic> json) =>
    RollDiceCommand(json['issuerId'] as String);

Map<String, dynamic> _$RollDiceCommandToJson(RollDiceCommand instance) =>
    <String, dynamic>{'issuerId': instance.issuerId};

SkipTurnCommand _$SkipTurnCommandFromJson(Map<String, dynamic> json) =>
    SkipTurnCommand(json['issuerId'] as String);

Map<String, dynamic> _$SkipTurnCommandToJson(SkipTurnCommand instance) =>
    <String, dynamic>{'issuerId': instance.issuerId};

GameStateEvent _$GameStateEventFromJson(Map<String, dynamic> json) =>
    GameStateEvent(
      GameState.fromJson(json['gameState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameStateEventToJson(GameStateEvent instance) =>
    <String, dynamic>{'gameState': instance.gameState.toJson()};

LobbyStateEvent _$LobbyStateEventFromJson(Map<String, dynamic> json) =>
    LobbyStateEvent(Lobby.fromJson(json['lobby'] as Map<String, dynamic>));

Map<String, dynamic> _$LobbyStateEventToJson(LobbyStateEvent instance) =>
    <String, dynamic>{'lobby': instance.lobby.toJson()};
