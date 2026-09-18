import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qwixx/config/routing.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/widget/card/card_carousel_widget.dart';
import 'package:qwixx/ui/game/widget/control/controls_widget.dart';
import 'package:qwixx/ui/game/widget/result_widget.dart';
import 'package:qwixx/ui/game/widget/heading_widget.dart';

class GameScreen extends StatefulWidget {
  const new({super.key, required this.viewModel});

  final GameViewModel viewModel;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    widget.viewModel.gateway.gameStateNotifierNotifier.addListener(
      _onGameStateNotifierChanged,
    );
    widget.viewModel.gameStateNotifier.addListener(_onGameOverChanged);
    widget.viewModel.session.gatewayControllerNotifier.addListener(
      _onGatewayNotifierChanged,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    widget.viewModel.gateway.gameStateNotifierNotifier.removeListener(
      _onGameStateNotifierChanged,
    );
    widget.viewModel.gameStateNotifier.removeListener(_onGameOverChanged);
    widget.viewModel.session.gatewayControllerNotifier.removeListener(
      _onGatewayNotifierChanged,
    );
    super.dispose();
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context2) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 500,
              height: 700,
              child: ResultWidget(
                viewModel: widget.viewModel,
                playerScores: widget.viewModel.generatePlayerScores(
                  widget.viewModel.gameStateNotifier.value.cards,
                ),
                isGameOver: widget.viewModel.gameStateNotifier.value.isGameOver,
              ),
            ),
          ),
        );
      },
    );
  }

  void _onGameOverChanged() {
    if (widget.viewModel.gameStateNotifier.value.isGameOver) {
      _showResult();
    }
  }

  void _onGameStateNotifierChanged() {
    final notifier = widget.viewModel.gateway.gameStateNotifier;
    if (notifier == null) {
      context.go(QwixxRoutes.lobby);
    }
  }

  void _onGatewayNotifierChanged() {
    final gateway = widget.viewModel.session.gatewayController;
    if (gateway == null) {
      context.go(QwixxRoutes.home);
    }
  }

  Widget _buildCards(BuildContext context) {
    return CardCarouselWidget(viewModel: widget.viewModel);
  }

  Widget _buildControls(BuildContext context) {
    return ControlsWidget(viewModel: widget.viewModel);
  }

  Widget _buildContent(BuildContext context) {
    final ratio = MediaQuery.of(context).size.aspectRatio;
    if (ratio > 1.6) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          Expanded(flex: 3, child: _buildCards(context)),
          Expanded(child: _buildControls(context)),
        ],
      );
    }
    return Column(
      spacing: 20,
      children: [
        Expanded(flex: 4, child: _buildControls(context)),
        Expanded(flex: 7, child: _buildCards(context)),
      ],
    );
  }

  Widget _buildGameFound(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: HeadingWidget(viewModel: widget.viewModel),
          centerTitle: true,
          actionsPadding: EdgeInsets.only(right: 10),
          actions: [
            IconButton(onPressed: _showResult, icon: Icon(Icons.leaderboard)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildContent(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel.gameStateNotifier,
      child: _buildGameFound(context),
    );
  }
}
