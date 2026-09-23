import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/card/card_row_viewmodel.dart';
import 'package:qwixx/ui/game/view_model/card/card_tile_viewmodel.dart';
import 'package:qwixx/ui/game/widget/cardV2/card_tile_widget.dart';

class CardRowWidget extends StatelessWidget {
  const CardRowWidget({super.key, required this.viewModel});

  final CardRowViewModel viewModel;

  Widget _buildLock(BuildContext context, CardTileViewModel cardTileViewModel) {
    return ValueListenableBuilder(
      valueListenable: cardTileViewModel.decorationListenable,
      builder: (context, value, child) {
        return switch (value) {
          TileDecoration.marked || TileDecoration.skipped => CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Transform.scale(
              scale: 1.5,
              child: Icon(Icons.lock, color: cardTileViewModel.color),
            ),
          ),
          TileDecoration.none || TileDecoration.markable => CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Transform.scale(
              scale: 1.5,
              child: Transform.rotate(
                angle: pi / 7,
                child: Icon(Icons.lock_open, color: cardTileViewModel.color),
              ),
            ),
          ),
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      color: viewModel.color,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          for (final entry in viewModel.cardTileViewModels.asMap().entries) ...[
            CardTileWidget(viewModel: entry.value),
            if (entry.key == viewModel.cardTileViewModels.length - 1)
              Padding(
                padding: const EdgeInsetsGeometry.only(left: 4),
                child: _buildLock(context, entry.value),
              ),
          ],
        ],
      ),
    );
  }
}
