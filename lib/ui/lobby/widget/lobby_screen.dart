import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qwixx/config/routing.dart';
import 'package:qwixx/domain/lobby/lobby.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:qwixx/ui/lobby/view_model/lobby_view_model.dart';

IconData fromPlayerKind(PlayerKind kind) {
  return switch (kind) {
    PlayerKind.host => Icons.admin_panel_settings,
    PlayerKind.client => Icons.laptop,
    PlayerKind.bot => Icons.smart_toy,
  };
}

class LobbyScreen extends StatefulWidget {
  const new({super.key, required this.viewModel});

  final LobbyViewModel viewModel;

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.gateway.gameStateNotifierNotifier.addListener(
      onGameStateNotifierChanged,
    );
    widget.viewModel.session.gatewayControllerNotifier.addListener(
      onGatewayChanged,
    );
  }

  @override
  void dispose() {
    widget.viewModel.gateway.gameStateNotifierNotifier.removeListener(
      onGameStateNotifierChanged,
    );
    widget.viewModel.session.gatewayControllerNotifier.removeListener(
      onGatewayChanged,
    );
    super.dispose();
  }

  void onGameStateNotifierChanged() {
    final notifier = widget.viewModel.gateway.gameStateNotifier;
    if (notifier != null) {
      context.go(QwixxRoutes.game);
    }
  }

  void onGatewayChanged() {
    final gateway = widget.viewModel.session.gatewayController;
    if (gateway == null) {
      context.go(QwixxRoutes.home);
    }
  }

  Widget _buildTile(BuildContext context, Lobby lobby, int playerIndex) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        textColor: widget.viewModel.isUser(lobby.all[playerIndex])
            ? Colors.green
            : null,
        leading: Icon(fromPlayerKind(lobby.all[playerIndex].kind)),
        title: Text(lobby.all[playerIndex].name),
        trailing: !widget.viewModel.isHost() || playerIndex == 0
            ? null
            : IconButton(
                onPressed: () {
                  widget.viewModel.kickPlayer(playerIndex);
                },
                icon: Icon(Icons.close),
              ),
      ),
    );
  }

  Widget _buildLobbyFound(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(500, 700)),
      child: SizedBox.expand(
        child: Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder(
              valueListenable: widget.viewModel.gateway.lobbyListenable,
              builder: (context, lobby, child) {
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.group),
                      title: Text(
                        'Spiel von ${lobby.host.name} (${lobby.all.length})',
                      ),
                      trailing: widget.viewModel.isHost()
                          ? Tooltip(
                              message: 'Bot hinzufügen',
                              child: TextButton.icon(
                                onPressed: () {
                                  widget.viewModel.addBot();
                                },
                                label: Icon(Icons.smart_toy),
                                icon: Icon(Icons.add),
                              ),
                            )
                          : null,
                    ),
                    const Divider(thickness: 2),
                    Expanded(child: _buildAnimated(context, lobby)),
                    const Divider(thickness: 2),
                    Row(
                      spacing: 15,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .error,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          onPressed: () {
                            widget.viewModel.deleteGateway();
                          },
                          child: Text('Lobby verlassen'),
                        ),

                        if (lobby.all.length > 1 && widget.viewModel.isHost())
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary,
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
                            ),
                            onPressed: () {
                              widget.viewModel.createGame();
                            },
                            child: Text('Spiel starten'),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimated(BuildContext context, Lobby lobby) {
    return ListView.separated(
      itemCount: lobby.all.length,
      itemBuilder: (context, index) => _buildTile(context, lobby, index),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: _buildLobbyFound(context)));
  }
}
