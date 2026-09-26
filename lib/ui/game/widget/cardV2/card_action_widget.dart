import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qwixx/ui/game/view_model/card/card_viewmodel.dart';

class CardActionWidget extends StatelessWidget {
  const new({super.key, required this.viewModel});
  final CardViewModel viewModel;

  Widget _scaled(Icon icon) {
    return Transform.scale(scale: 2, child: icon);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel.statusListenable,
      builder: (context, value, child) {
        return switch (value) {
          StatusDecoration.done => _scaled(
            Icon(Icons.done, color: Colors.green),
          ),
          StatusDecoration.skipable => GestureDetector(
            onTap: viewModel.onSkipTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: _scaled(Icon(Icons.done, color: Colors.green))
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fade(
                    duration: const Duration(milliseconds: 750),
                    begin: 0.1,
                    curve: Curves.easeInOutQuad,
                  ),
            ),
          ),
          StatusDecoration.penable => SizedBox.shrink(),
          StatusDecoration.rollable => GestureDetector(
            onTap: viewModel.onRollTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: _scaled(Icon(Icons.casino, color: Colors.green))
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fade(
                    duration: const Duration(milliseconds: 750),
                    begin: 0.1,
                    curve: Curves.easeInOutQuad,
                  ),
            ),
          ),
        };
      },
    );
  }
}
