import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qwixx/config/routing.dart';
import 'package:qwixx/ui/home/view_model/game_discovery_view_model.dart';
import 'package:qwixx/ui/home/view_model/home_view_model.dart';
import 'package:qwixx/ui/home/view_model/settings_view_model.dart';
import 'package:qwixx/ui/home/widget/game_discovery_widget.dart';
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
  }

  @override
  void dispose() {
    widget.viewModel.session.gatewayControllerNotifier.removeListener(
      _onGatewayChanged,
    );
    super.dispose();
  }

  void _onGatewayChanged() {
    final gateway = widget.viewModel.session.gatewayController;
    if (gateway != null) {
      context.go(QwixxRoutes.lobby);
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16),
          ),
          constraints: BoxConstraints.loose(Size(450, 700)),
          child: SizedBox.expand(
            child: SettingsWidget(viewModel: widget.settingsViewModel),
          ),
        );
      },
    );
  }

  Widget _buildSetup(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        Text('Um spielen zu können brauchst du einene Namen'),
        ElevatedButton.icon(
          icon: Icon(Icons.settings),
          label: Text('Einstellungen'),
          onPressed: () => _dialogBuilder(context),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(Size.fromWidth(150)),
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Spiel erstellen', style: TextTheme.of(context).bodyLarge),
              const Divider(thickness: 2),
              ElevatedButton(
                onPressed: () {
                  widget.viewModel.onSoloLobbyTap();
                },
                child: Text('Singleplayer'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.viewModel.onMultiLobbyTap();
                },
                child: Text('Multiplayer'),
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
        return child!;
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActions(context),
          GameDiscoveryWidget(viewModel: widget.gameDiscoveryViewModel),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qwixx', style: TextTheme.of(context).headlineSmall),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: ValueListenableBuilder(
              valueListenable: widget.viewModel.nameNotifier,
              builder: (context, name, child) {
                if (name == null) {
                  return SizedBox.shrink();
                }
                return Text(name);
              },
            ),
          ),
          IconButton(
            onPressed: () => _dialogBuilder(context),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(child: _buildContent(context)),
    );
  }
}
