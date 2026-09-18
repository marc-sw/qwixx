import 'package:flutter/material.dart';
import 'package:qwixx/data/repository/game_discovery/game_discovery_repository.dart';
import 'package:qwixx/ui/home/view_model/game_discovery_view_model.dart';

final _discoveryList = GlobalKey<AnimatedListState>();

class GameDiscoveryWidget extends StatefulWidget {
  final GameDiscoveryViewModel viewModel;

  const new({super.key, required this.viewModel});

  @override
  State<GameDiscoveryWidget> createState() => _GameDiscoveryWidgetState();
}

class _GameDiscoveryWidgetState extends State<GameDiscoveryWidget> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.afterAdd = _afterAdd;
    widget.viewModel.beforeRemove = _beforeRemove;
  }

  @override
  void dispose() {
    widget.viewModel.stop();
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
    return ListTile(
      leading: Text('Spiel von ${info.host.name}'),
      title: Text('seit ${DateTime.now().difference(info.createdAt)}'),
      trailing: IconButton(
        onPressed: () => widget.viewModel.join(info),
        icon: Icon(Icons.login),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(Size(400, 600)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.wifi_find),
                title: Text('Offene Spiele'),
                trailing: ValueListenableBuilder(
                  valueListenable: widget.viewModel.discoveringListenable,
                  builder: (context, discovering, child) {
                    if (discovering) {
                      return Row(
                        spacing: 10,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: widget.viewModel.stop,
                            icon: Icon(Icons.stop),
                          ),
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                    return IconButton(
                      onPressed: () => widget.viewModel.start(),
                      icon: Icon(Icons.play_arrow),
                    );
                  },
                ),
              ),
              const Divider(thickness: 2),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: widget.viewModel.serverInfosListenable,
                  builder: (context, infos, child) {
                    return AnimatedList.separated(
                      key: _discoveryList,
                      initialItemCount: infos.length,
                      itemBuilder: (context, index, animation) =>
                          SlideTransition(
                            position: animation.drive(
                              Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ),
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
          ),
        ),
      ),
    );
  }
}
