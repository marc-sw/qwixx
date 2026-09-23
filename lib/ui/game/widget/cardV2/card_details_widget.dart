import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/card/card_viewmodel.dart';
import 'package:qwixx/ui/game/widget/cardV2/card_fail_widget.dart';
import 'package:qwixx/ui/lobby/widget/lobby_screen.dart';

class CardDetailsWidget extends StatelessWidget {
  const new({super.key, required this.viewModel});

  final CardViewModel viewModel;

  Widget _buildScore(
    BuildContext context,
    ValueListenable<int> listenable,
    Color? color,
  ) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          border: Border.all(color: color ?? Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: listenable,
            builder: (context, value, child) {
              return Text(
                value.toString(),
                style: TextStyle(color: color, fontSize: 24),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(630, 80)),
      child: Row(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Spieler', style: TextTheme.of(context).bodyLarge),
              SizedBox(
                height: 50,
                child: Row(
                  spacing: 3,
                  children: [
                    Icon(fromPlayerKind(viewModel.player.kind)),
                    Text(
                      viewModel.player.name,
                      style: TextTheme.of(context).bodyLarge!.copyWith(
                        color: viewModel.highlighted ? Colors.green : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                Text('Score', style: TextTheme.of(context).bodyLarge),
                Row(
                  spacing: 5,
                  children: [
                    for (final entry
                        in viewModel.cardRowViewModels.asMap().entries) ...[
                      _buildScore(
                        context,
                        entry.value.scoreListenable,
                        entry.value.color,
                      ),
                      if (entry.key < viewModel.cardRowViewModels.length - 1)
                        Text('+', style: TextStyle(fontSize: 24))
                      else
                        Text('-', style: TextStyle(fontSize: 24)),
                    ],
                    _buildScore(context, viewModel.failScoreListenable, null),
                    Text('=', style: TextStyle(fontSize: 24)),
                    _buildScore(context, viewModel.resultScoreListenable, null),
                  ],
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text('Fehlwürfe', style: TextTheme.of(context).bodyLarge),
              Row(
                spacing: 3,
                children: [
                  for (final entry
                      in viewModel.failDecorationListenables.asMap().entries)
                    CardFailWidget(
                      decorationListenable: entry.value,
                      onTap: () => viewModel.onFailTap(entry.key),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
