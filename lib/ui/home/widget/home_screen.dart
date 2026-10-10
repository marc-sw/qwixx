import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qwixx/config/routing.dart';
import 'package:qwixx/ui/home/view_model/game_discovery_view_model.dart';
import 'package:qwixx/ui/home/view_model/home_view_model.dart';
import 'package:qwixx/ui/home/view_model/settings_view_model.dart';
import 'package:qwixx/ui/home/widget/game_discovery_v2.dart';
import 'package:qwixx/ui/home/widget/game_rules.dart';
import 'package:qwixx/ui/home/widget/pop_card.dart';
import 'package:qwixx/ui/home/widget/settings_widget.dart';

class HomeScreen extends StatefulWidget {
  const new({
    super.key,
    required this.viewModel,
    required this.settingsViewModel,
    required this.gameDiscoveryViewModel,
  });

  final HomeViewModel viewModel;
  final SettingsViewModel settingsViewModel;
  final GameDiscoveryViewModel gameDiscoveryViewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.session.gatewayControllerNotifier.addListener(
      _onGatewayChanged,
    );
    widget.viewModel.createMultiplayerGame.results.addListener(
      _onCreateMultiplayerGameChanged,
    );
  }

  @override
  void dispose() {
    widget.viewModel.createMultiplayerGame.results.removeListener(
      _onCreateMultiplayerGameChanged,
    );
    widget.viewModel.session.gatewayControllerNotifier.removeListener(
      _onGatewayChanged,
    );
    super.dispose();
  }

  void _onCreateMultiplayerGameChanged() {
    final error = widget.viewModel.createMultiplayerGame.errors.value;
    if (error == null) {
      return;
    }

    _showSnackbarMessage(error.error.toString());
  }

  void _onGatewayChanged() {
    final gateway = widget.viewModel.session.gatewayController;
    if (gateway != null) {
      context.go(QwixxRoutes.lobby);
    }
  }

  void _showSnackbarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Widget child) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          constraints: BoxConstraints.loose(Size(400, 600)),
          child: PopCard(child: child),
        );
      },
    );
  }

  Widget _buildSetup(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.settings),
      label: Text('Setup name'),
      onPressed: () => _dialogBuilder(
        context,
        SettingsWidget(viewModel: widget.settingsViewModel),
      ),
    );
  }

  Widget _buildActionsV2(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size.fromWidth(200)),
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsetsGeometry.all(12),
          child: Column(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                textAlign: TextAlign.center,
                'Qwixx',
                style: GoogleFonts.alfaSlabOne(fontSize: 24),
              ),
              const Divider(thickness: 2),
              ElevatedButton(
                onPressed: () {
                  _dialogBuilder(context, _buildLobbyCreator(context));
                },
                child: Text('Create'),
              ),
              ElevatedButton(
                onPressed: () {
                  _dialogBuilder(
                    context,
                    GameDiscoveryV2(viewModel: widget.gameDiscoveryViewModel),
                    /*GameDiscoveryWidget(
                      viewModel: widget.gameDiscoveryViewModel,
                      runOnStart: true,
                    ),*/
                  );
                },
                child: Text('Join'),
              ),
              ElevatedButton(
                onPressed: () {
                  _dialogBuilder(context, const GameRulesWidget());
                },
                child: Text('Game Rules'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.viewModel.nameNotifier,
      builder: (context, user, child) {
        if (user == null) {
          return _buildSetup(context);
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildActionsV2(context),
        );
      },
    );
  }

  Widget _buildLobbyCreator(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        ListTile(
          title: Text('Create Game', style: TextTheme.of(context).bodyLarge),
        ),
        const Divider(thickness: 2),
        Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 125,
                child: ElevatedButton(
                  onPressed: widget.viewModel.onSoloLobbyTap,
                  child: Text('Alone'),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: widget.viewModel.createMultiplayerGame.results,
                builder: (context, result, child) {
                  if (result.isRunning) {
                    return CircularProgressIndicator();
                  }
                  return SizedBox(
                    width: 125,
                    child: ElevatedButton(
                      onPressed: widget.viewModel.createMultiplayerGame.run,
                      child: Text('With others'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/qwixx_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsGeometry.only(right: 5),
                child: Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: widget.viewModel.nameNotifier,
                      builder: (context, name, child) {
                        if (name == null) {
                          return SizedBox.shrink();
                        }
                        return Text(
                          name,
                          style: TextTheme.of(context).bodyMedium!
                              .copyWith(color: Colors.white),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () => _dialogBuilder(
                        context,
                        SettingsWidget(viewModel: widget.settingsViewModel),
                      ),
                      icon: Icon(Icons.settings, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(child: Center(child: _buildContent(context))),
            ],
          ),
        ),
      ),
    );
  }
}
