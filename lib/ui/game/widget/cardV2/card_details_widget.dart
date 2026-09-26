import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/card/card_viewmodel.dart';
import 'package:qwixx/ui/game/widget/cardV2/card_action_widget.dart';
import 'package:qwixx/ui/game/widget/cardV2/card_fail_widget.dart';
import 'package:qwixx/ui/game/widget/cardV2/status_widget.dart';
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
      child: SizedBox(
        height: 50,
        child: ValueListenableBuilder(
          valueListenable: listenable,
          builder: (context, value, child) {
            return Text(
              value.toString(),
              style: TextTheme.of(context).headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(630, 80)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.only(left: 20),
            child: SizedBox(
              width: 45,
              height: 45,
              child: viewModel.isActor
                  ? CardActionWidget(viewModel: viewModel)
                  : CardStatusWidget(
                      decorationListenable: viewModel.statusListenable,
                      scale: 2,
                    ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Spieler',
                style: TextTheme.of(context).bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  spacing: 3,
                  children: [
                    Icon(
                      fromPlayerKind(viewModel.player.kind),
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
                    Text(
                      viewModel.player.name,
                      style: TextTheme.of(context).bodyLarge!.copyWith(
                        color: viewModel.isActor
                            ? Colors.green
                            : Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              Text(
                'Score',
                style: TextTheme.of(context).bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              _buildScore(context, viewModel.resultScoreListenable, null),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                'Fehlwürfe',
                style: TextTheme.of(context).bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
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
