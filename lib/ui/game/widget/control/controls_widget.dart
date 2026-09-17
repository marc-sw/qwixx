import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/widget/control/action_button.dart';
import 'package:qwixx/ui/game/widget/control/dice_widget.dart';

class ControlsWidget extends StatelessWidget {
  const new({super.key, required this.viewModel});

  final GameViewModel viewModel;

  Widget _buildActionAndDice(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 20,
      children: [
        ActionButton(viewModel: viewModel),
        DiceWidget(viewModel: viewModel),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(child: _buildActionAndDice(context));
  }
}
