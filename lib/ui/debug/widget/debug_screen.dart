import 'package:flutter/material.dart';
import 'package:qwixx/ui/game/view_model/card/card_viewmodel.dart';
import 'package:qwixx/ui/game/widget/cardV2/card_widget_v2.dart';

class DebugScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FittedBox(child: CardWidgetV2(viewModel: CardViewModel.test())),
      ),
    );
  }
}
