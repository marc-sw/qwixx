import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qwixx/config/routing.dart';
import 'package:qwixx/ui/home/view_model/home_view_model.dart';
import 'package:qwixx/ui/home/view_model/settings_view_model.dart';
import 'package:qwixx/ui/home/widget/settings_widget.dart';

class HomeScreen extends StatelessWidget {
  const new({
    super.key,
    required this.viewModel,
    required this.settingsViewModel,
  });

  final HomeViewModel viewModel;
  final SettingsViewModel settingsViewModel;

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
            child: SettingsWidget(viewModel: settingsViewModel),
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
                  viewModel.onSoloLobbyTap();
                  context.go(QwixxRoutes.lobby);
                },
                child: Text('Singleplayer'),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.onMultiLobbyTap();
                  context.go(QwixxRoutes.lobby);
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
      valueListenable: viewModel.userNotifier,
      builder: (context, user, child) {
        if (user == null) {
          return _buildSetup(context);
        }
        return child!;
      },
      child: _buildActions(context),
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
              valueListenable: viewModel.userNotifier,
              builder: (context, user, child) {
                if (user == null) {
                  return SizedBox.shrink();
                }
                return Text(user.name);
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
