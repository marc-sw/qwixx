part of '../gateway_command.dart';

@JsonSerializable(explicitToJson: true)
class RollDiceCommand extends GameCommand {
  new(super.issuerId);
  factory RollDiceCommand.fromJson(Map<String, dynamic> json) =>
      _$RollDiceCommandFromJson(json);
  Map<String, dynamic> toJson() => _$RollDiceCommandToJson(this);

  @override
  GameState execute(GameState gameState) {
    return gameState.copyWith(
      newDiceRolls: gameState.diceRolls.roll(),
      newTurn: gameState.turn.setRolled(true),
    );
  }

  @override
  bool isLegal(GameState gameState) {
    return gameState.phase == GamePhase.rollDice &&
        gameState.activeCard.player.uuid == issuerId;
  }
}
