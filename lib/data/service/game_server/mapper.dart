import 'package:qwixx/domain/command/gateway_command.dart';

class MessageMapper {
  static final MessageMapper instance = MessageMapper();

  GatewayMessage jsonToMessage(dynamic data) {
    return RollDiceCommand('');
  }

  dynamic messageToJson(GatewayMessage message) {
    return '';
  }
}
