import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qwixx/ui/game/view_model/card/card_viewmodel.dart';

class CardStatusWidget extends StatelessWidget {
  const new({super.key, required this.decorationListenable});

  final ValueListenable<StatusDecoration> decorationListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: decorationListenable,
      builder: (context, value, child) {
        return switch (value) {
          StatusDecoration.done => Icon(Icons.done),
          StatusDecoration.marking =>
            Icon(Icons.hourglass_empty)
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .fade(
                  duration: const Duration(milliseconds: 750),
                  begin: 0.1,
                  curve: Curves.easeInOutQuad,
                ),
          StatusDecoration.rolling =>
            Icon(Icons.casino)
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .fade(
                  duration: const Duration(milliseconds: 750),
                  begin: 0.1,
                  curve: Curves.easeInOutQuad,
                ),
        };
      },
    );
  }
}
