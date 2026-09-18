// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lobby _$LobbyFromJson(Map<String, dynamic> json) => Lobby(
  (json['players'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LobbyToJson(Lobby instance) => <String, dynamic>{
  'players': instance.players.map((e) => e.toJson()).toList(),
};
