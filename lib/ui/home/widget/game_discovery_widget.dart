import 'package:flutter/material.dart';
import 'package:qwixx/data/repository/game_discovery/game_discovery_repository.dart';
import 'package:qwixx/ui/home/view_model/game_discovery_view_model.dart';

final _discoveryList = GlobalKey<AnimatedListState>();

String formatDuration(Duration duration) {
  final s = duration.inSeconds;
  if (s < 60) {
    if (s == 1) {
      return '$s Sekunde';
    }
    return '$s Sekunden';
  }
  final m = duration.inMinutes;
  if (m < 60) {
    if (m == 1) {
      return '$m Minute';
    }
    return '$m Minuten';
  }
  final h = duration.inHours;
  if (h < 24) {
    if (h == 1) {
      return '$h Stunde';
    }
    return '$h Stunden';
  }
  final d = duration.inDays;
  if (d == 1) {
    return '$d Tag';
  }
  return '$d Tagen';
}

class GameDiscoveryWidget extends StatefulWidget {
  final GameDiscoveryViewModel viewModel;
  final bool runOnStart;

  const new({super.key, required this.viewModel, this.runOnStart = false});

  @override
  State<GameDiscoveryWidget> createState() => _GameDiscoveryWidgetState();
}

class _GameDiscoveryWidgetState extends State<GameDiscoveryWidget> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.afterAdd = _afterAdd;
    widget.viewModel.beforeRemove = _beforeRemove;

    if (widget.runOnStart) {
      widget.viewModel.searchGamesCommand.run();
    }
  }

  @override
  void dispose() {
    if (widget.viewModel.searchGamesCommand.isRunning.value) {
      widget.viewModel.searchGamesCommand.cancel();
    }
    super.dispose();
  }

  void _afterAdd(int index) {
    _discoveryList.currentState?.insertItem(index);
  }

  void _beforeRemove(int index, ServerInfo info) {
    _discoveryList.currentState?.removeItem(index, (context, animation) {
      return SlideTransition(
        position: animation.drive(
          Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
        ),
        child: FadeTransition(opacity: animation, child: _buildInfo(info)),
      );
    });
  }

  Widget _buildInfo(ServerInfo info) {
    final duration = DateTime.now().difference(info.createdAt);
    final formatted = formatDuration(duration);
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: Row(
        spacing: 10,
        children: [
          Expanded(child: Text('Spiel von ${info.host.name}')),
          Text('vor $formatted'),
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
      spacing: 10,
      children: [
        ListTile(
          leading: Icon(Icons.wifi_find),
          title: Text('Suche Spiele'),
          trailing: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.close),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: widget.viewModel.searchGamesCommand.results,
          builder: (context, value, child) {
            if (value.isRunning) {
              return LinearProgressIndicator();
            }
            return const Divider(thickness: 2);
          },
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: widget.viewModel.serverInfosListenable,
            builder: (context, infos, child) {
              return AnimatedList.separated(
                key: _discoveryList,
                initialItemCount: infos.length,
                itemBuilder: (context, index, animation) => SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: _buildInfo(infos[index]),
                  ),
                ),
                separatorBuilder: (context, index, animation) =>
                    SizedBox(height: 10),
                removedSeparatorBuilder: (context, index, animation) =>
                    SizedBox(height: 10),
              );
            },
          ),
        ),
      ],
    );
  }
}
