import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/card/card_viewmodel.dart';
import 'package:qwixx/ui/game/widget/cardV2/card_details_widget.dart';
import 'package:qwixx/ui/game/widget/cardV2/card_row_widget.dart';

class CardWidgetV2 extends StatelessWidget {
  const CardWidgetV2({super.key, required this.viewModel});

  final CardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Card(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              for (final row in viewModel.cardRowViewModels)
                CardRowWidget(viewModel: row),
              //const Divider(thickness: 4),
              CardDetailsWidget(viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }
}
