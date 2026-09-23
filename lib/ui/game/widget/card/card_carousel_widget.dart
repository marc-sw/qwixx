import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/widget/cardV2/card_widget_v2.dart';

class CardCarouselWidget extends StatefulWidget {
  const new({super.key, required this.viewModel});

  final GameViewModel viewModel;

  @override
  State<CardCarouselWidget> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarouselWidget> {
  late final CarouselController _controller;

  @override
  void initState() {
    super.initState();
    final index = widget.viewModel.gameStateNotifier.value.cardIndexOf(
      widget.viewModel.playerId,
    );
    _controller = CarouselController(initialItem: index == -1 ? 0 : index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselView.weighted(
      controller: _controller,
      itemSnapping: true,
      infinite: true,
      enableSplash: false,
      scrollDirection: Axis.horizontal,
      flexWeights: [1],
      children: List.generate(widget.viewModel.cardViewModels.length, (i) {
        return CardWidgetV2(viewModel: widget.viewModel.cardViewModels[i]);
      }),
    );
  }
}
