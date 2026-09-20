import 'package:flutter/material.dart';
import 'package:qwixx/ui/home/view_model/settings_view_model.dart';

class SettingsWidget extends StatefulWidget {
  const new({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.viewModel.username ?? '',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Tooltip(
            message: 'Speichert automatisch',
            child: Icon(Icons.settings),
          ),
          title: Text('Settings'),
          trailing: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close),
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(8),
            children: [
              Container(child: Text('Account')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      onTapOutside: (e) {
                        widget.viewModel.onUsernameSubmit(
                          _usernameController.text,
                        );
                      },
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: widget.viewModel.onUsernameSubmit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
