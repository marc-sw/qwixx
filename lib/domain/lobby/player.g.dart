// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
  json['uuid'] as String,
  json['name'] as String,
  $enumDecode(_$PlayerKindEnumMap, json['kind']),
);

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'kind': _$PlayerKindEnumMap[instance.kind]!,
};

const _$PlayerKindEnumMap = {
  PlayerKind.host: 'host',
  PlayerKind.client: 'client',
  PlayerKind.bot: 'bot',
};
