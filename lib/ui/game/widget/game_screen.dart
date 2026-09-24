import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qwixx/config/routing.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/widget/card/card_carousel_widget.dart';
import 'package:qwixx/ui/game/widget/control/dice_widget.dart';
import 'package:qwixx/ui/game/widget/heading_widget_v2.dart';
import 'package:qwixx/ui/game/widget/result_widget.dart';

class GameScreen extends StatefulWidget {
  const new({super.key, required this.viewModel});

  final GameViewModel viewModel;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final CarouselController _carouselController;
  bool _resultDialogOpen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final index = widget.viewModel.gameStateNotifier.value.cardIndexOf(
      widget.viewModel.playerId,
    );
    _carouselController = CarouselController(
      initialItem: index == -1 ? 0 : index,
    );

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
    _carouselController.dispose();
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
    if (_resultDialogOpen) {
      return;
    }
    _resultDialogOpen = true;
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
    ).whenComplete(() => _resultDialogOpen = false);
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
    return CardCarouselWidget(
      viewModel: widget.viewModel,
      controller: _carouselController,
    );
  }

  Widget _buildControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: FittedBox(child: DiceWidget(viewModel: widget.viewModel)),
    ); //ControlsWidget(viewModel: widget.viewModel);
  }

  Widget _buildContent(BuildContext context) {
    final ratio = MediaQuery.of(context).size.aspectRatio;
    if (ratio > 1.6) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 3, child: _buildCards(context)),
          Expanded(child: _buildControls(context)),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildControls(context)),
        Expanded(child: _buildCards(context)),
      ],
    );
  }

  Widget _buildGameFound(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: HeadingWidgetV2(
            viewModel: widget.viewModel,
            onTap: (i) => _carouselController.animateToItem(i),
          ), //HeadingWidget(viewModel: widget.viewModel),
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
