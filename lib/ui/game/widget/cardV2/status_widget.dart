import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/card/card_viewmodel.dart';

class CardStatusWidget extends StatelessWidget {
  const new({
    super.key,
    required this.decorationListenable,
    this.scale = 1,
    bool isActor = false,
  }) : color = isActor ? Colors.green : null;

  final Color? color;
  final double scale;
  final ValueListenable<StatusDecoration> decorationListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: decorationListenable,
      builder: (context, value, child) {
        return switch (value) {
          StatusDecoration.done => Transform.scale(
            scale: scale,
            child: Icon(Icons.done, color: color),
          ),
          StatusDecoration.skipable ||
          StatusDecoration.penable => Transform.scale(
            scale: scale,
            child: Icon(Icons.question_mark, color: color),
          ),
          StatusDecoration.rollable => Transform.scale(
            scale: scale,
            child: Icon(Icons.casino, color: color),
          ),
        };
      },
    );
  }
}
