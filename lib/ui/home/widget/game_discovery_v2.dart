import 'package:flutter/material.dart';
import 'package:qwixx/data/repository/game_discovery/game_discovery_repository.dart';
import 'package:qwixx/ui/home/view_model/game_discovery_view_model.dart';
import 'package:qwixx/ui/home/widget/game_discovery_widget.dart';

class GameDiscoveryV2 extends StatefulWidget {
  const new({super.key, required this.viewModel});

  final GameDiscoveryViewModel viewModel;

  @override
  State<GameDiscoveryV2> createState() => _GameDiscoveryV2State();
}

class _GameDiscoveryV2State extends State<GameDiscoveryV2> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.getGamesCommand.run(Duration(milliseconds: 2000));
  }

  @override
  void dispose() {
    if (widget.viewModel.getGamesCommand.isRunning.value) {
      widget.viewModel.stopSearching();
    }
    super.dispose();
  }

  Widget _buildInfo(ServerInfo info) {
    final duration = DateTime.now().difference(info.createdAt);
    final formatted = formatDuration(duration);
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: Text(
              'Game by ${info.host.name}',
              style: TextTheme.of(context).bodyLarge,
            ),
          ),
          Text('$formatted ago', style: TextTheme.of(context).bodyLarge),
          IconButton(
            onPressed: () => widget.viewModel.joinGameCommand.run(info),
            icon: Icon(Icons.login),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.wifi_find),
              Expanded(
                child: Text(
                  'Local games',
                  style: TextTheme.of(context).bodyLarge,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: widget.viewModel.getGamesCommand.isRunning,
                builder: (context, isRunning, child) {
                  if (isRunning) {
                    return const CircularProgressIndicator();
                  }
                  return child!;
                },
                child: IconButton(
                  onPressed: () => widget.viewModel.getGamesCommand.run(
                    const Duration(milliseconds: 2000),
                  ),
                  icon: Icon(Icons.replay),
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 2),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: widget.viewModel.getGamesCommand.results,
            builder: (context, value, child) {
              if (value.isRunning) {
                return SizedBox.shrink();
              }
              if (value.hasData && value.data!.isNotEmpty) {
                return ListView.separated(
                  itemBuilder: (context, index) =>
                      _buildInfo(value.data![index]),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: value.data!.length,
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No game found'),
                  Text(
                    'Make sure another device is hosting the game on your local network',
                    style: TextTheme.of(context).bodySmall!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
