import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qwixx/main.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/widget/control/die_widget.dart';

const _animationDuration = 1700;
const _tickDuration = 200;

class DiceWidget extends StatefulWidget {
  const new({super.key, required this.viewModel});

  final GameViewModel viewModel;

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget> {
  final double spacing = 7;
  bool cachedRolled = false;
  late final _RollAnimation animation;

  @override
  void initState() {
    super.initState();
    animation = _RollAnimation.init(() => setState(() {}));
    widget.viewModel.gameStateNotifier.addListener(_onRolledChanged);
  }

  @override
  void didUpdateWidget(covariant DiceWidget oldWidget) {
    cachedRolled = false;
    oldWidget.viewModel.gameStateNotifier.removeListener(_onRolledChanged);
    widget.viewModel.gameStateNotifier.addListener(_onRolledChanged);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animation.dispose();
    widget.viewModel.gameStateNotifier.removeListener(_onRolledChanged);
    super.dispose();
  }

  void _onRolledChanged() {
    final rolled = widget.viewModel.gameStateNotifier.value.turn.rolled;
    if (cachedRolled == false && rolled) {
      animation.start();
    }
    cachedRolled = rolled;
  }

  Widget _buildDie(Color color, int roll, int index) {
    int visualRoll = animation._displayRoll(index, roll);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: _tickDuration - 10),
      switchInCurve: Curves.decelerate,
      switchOutCurve: Curves.decelerate,
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: DieWidget(
        key: ValueKey(color.toString() + visualRoll.toString()),
        color: color,
        roll: visualRoll,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: [
        Row(
          spacing: spacing,
          children: [
            for (final entry
                in widget
                    .viewModel
                    .gameStateNotifier
                    .value
                    .diceRolls
                    .colored
                    .entries)
              _buildDie(fromQwixx(entry.key), entry.value, entry.key.index),
            for (
              var i = 0;
              i <
                  4 -
                      widget
                          .viewModel
                          .gameStateNotifier
                          .value
                          .diceRolls
                          .colored
                          .length;
              i++
            )
              SizedBox.fromSize(size: Size(35, 35)),
          ],
        ),
        Row(
          spacing: spacing,
          children: List<Widget>.generate(
            widget.viewModel.gameStateNotifier.value.diceRolls.white.length,
            (i) => _buildDie(
              fromQwixx(null),
              widget.viewModel.gameStateNotifier.value.diceRolls.white[i],
              i + 4,
            ),
          ),
        ),
      ],
    );
  }
}

class _RollAnimation {
  int _stopIndex;
  final List<int> _animationOffsets;
  final void Function() _tickCallback;
  Timer? _timer;

  _RollAnimation(
    this._stopIndex,
    this._animationOffsets,
    this._timer,
    this._tickCallback,
  );

  _RollAnimation.init(this._tickCallback)
    : _stopIndex = -1,
      _animationOffsets = List<int>.filled(6, 1),
      _timer = null;

  void start() {
    _timer?.cancel();
    _stopIndex = -1;
    for (var i = 0; i < _animationOffsets.length; i++) {
      _animationOffsets[i] = random.nextInt(_rollPattern.length);
    }
    final end = DateTime.now().add(
      const Duration(milliseconds: _animationDuration),
    );
    _timer = Timer.periodic(const Duration(milliseconds: _tickDuration), (
      timer,
    ) {
      if (DateTime.now().isAfter(end)) {
        if (_stopIndex >= _animationOffsets.length) {
          timer.cancel();
          _timer = null;
          return;
        }
        _stopIndex++;
      }

      _tickCallback.call();
    });
  }

  int _displayRoll(int index, int roll) {
    if (_stopIndex >= index || _timer == null) {
      return roll;
    }
    int rollIndex =
        (_animationOffsets[index] + _timer!.tick) % _rollPattern.length;
    return _rollPattern[rollIndex];
  }

  void dispose() {
    _timer?.cancel();
  }
}

const _rollPattern = [
  3,
  6,
  2,
  5,
  1,
  4,
  6,
  3,
  5,
  2,
  4,
  1,
  6,
  5,
  3,
  2,
  4,
  6,
  1,
  5,
  2,
  3,
  6,
  4,
  1,
  5,
  2,
  6,
];
