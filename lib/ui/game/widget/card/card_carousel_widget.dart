import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/widget/cardV2/card_widget_v2.dart';

class CardCarouselWidget extends StatelessWidget {
  const new({super.key, required this.viewModel, required this.controller});

  final GameViewModel viewModel;
  final CarouselController controller;

  @override
  Widget build(BuildContext context) {
    return CarouselView.weighted(
      backgroundColor: Colors.transparent,
      controller: controller,
      itemSnapping: true,
      infinite: true,
      enableSplash: false,
      scrollDirection: Axis.horizontal,
      flexWeights: [1],
      children: List.generate(viewModel.cardViewModels.length, (i) {
        return CardWidgetV2(viewModel: viewModel.cardViewModels[i]);
      }),
    );
  }
}
