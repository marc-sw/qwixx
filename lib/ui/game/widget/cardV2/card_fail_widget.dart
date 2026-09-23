import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qwixx/ui/game/view_model/card/card_viewmodel.dart';

class CardFailWidget extends StatelessWidget {
  const new({
    super.key,
    required this.decorationListenable,
    required this.onTap,
  });

  final ValueListenable<FailDecoration> decorationListenable;
  final void Function() onTap;

  Widget _buildDecoration(BuildContext context, FailDecoration decoration) {
    return switch (decoration) {
      FailDecoration.none => SizedBox.shrink(),
      FailDecoration.markable => GestureDetector(
        onTap: onTap,
        child: Container(color: Colors.red.withAlpha(150))
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
              delay: const Duration(milliseconds: 3000),
            )
            .fade(
              duration: const Duration(milliseconds: 750),
              curve: Curves.easeInOutQuad,
            ),
      ),
      FailDecoration.marked => Transform.scale(
        scale: 2,
        child: Icon(Icons.close),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(6),
      child: Container(
        width: 40,
        height: 50,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: ValueListenableBuilder(
          valueListenable: decorationListenable,
          builder: (context, value, child) => _buildDecoration(context, value),
        ),
      ),
    );
  }
}
