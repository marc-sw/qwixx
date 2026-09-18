import 'dart:convert';

import 'package:qwixx/domain/command/gateway_command.dart';

enum MessageId {
  joinCommand,
  leaveCommand,
  kickCommand,
  lobbyStateEvent,
  gameStateEvent,
  markNumberCommand,
  rollDiceCommand,
  skipTurnCommand,
}

class MessageMapper {
  static final MessageMapper instance = MessageMapper();

  GatewayMessage jsonToMessage(dynamic data) {
    final jsonMap = jsonDecode(data) as Map<String, dynamic>;
    final messageIdString = jsonMap['id'];
    final messageId = MessageId.values
        .where((id) => id.name == messageIdString)
        .firstOrNull;
    if (messageId == null) {
      return UnknownMessage();
    }
    final jsonContent = jsonMap['data'] as Map<String, dynamic>;
    switch (messageId) {
      case MessageId.joinCommand:
        return JoinCommand.fromJson(jsonContent);
      case MessageId.lobbyStateEvent:
        return LobbyStateEvent.fromJson(jsonContent);
      case MessageId.gameStateEvent:
        return GameStateEvent.fromJson(jsonContent);
      case MessageId.markNumberCommand:
        return MarkNumberCommand.fromJson(jsonContent);
      case MessageId.rollDiceCommand:
        return RollDiceCommand.fromJson(jsonContent);
      case MessageId.skipTurnCommand:
        return SkipTurnCommand.fromJson(jsonContent);
      case MessageId.leaveCommand:
        return LeaveCommand.fromJson(jsonContent);
      case MessageId.kickCommand:
        return KickCommand.fromJson(jsonContent);
    }
  }

  dynamic messageToJson(GatewayMessage message) {
    Map<String, dynamic> json = {};
    String id = 'unknown';
    switch (message) {
      case JoinCommand():
        json = message.toJson();
        id = MessageId.joinCommand.name;
      case LeaveCommand():
        json = message.toJson();
        id = MessageId.leaveCommand.name;
      case KickCommand():
        json = message.toJson();
        id = MessageId.kickCommand.name;
      case MarkNumberCommand():
        json = message.toJson();
        id = MessageId.markNumberCommand.name;
      case RollDiceCommand():
        json = message.toJson();
        id = MessageId.rollDiceCommand.name;
      case SkipTurnCommand():
        json = message.toJson();
        id = MessageId.skipTurnCommand.name;
      case GameStateEvent():
        json = message.toJson();
        id = MessageId.gameStateEvent.name;
      case LobbyStateEvent():
        json = message.toJson();
        id = MessageId.lobbyStateEvent.name;
      case UnknownMessage():
    }
    Map<String, dynamic> jsonMap = {'id': id, 'data': json};
    return jsonEncode(jsonMap);
  }
}
