import 'package:flutter/material.dart';
import 'package:qwixx/domain/game/game.dart';

const _rollPattern = [
  [false, false, false, false, true, false, false, false, false],
  [false, false, true, false, false, false, true, false, false],
  [false, false, true, false, true, false, true, false, false],
  [true, false, true, false, false, false, true, false, true],
  [true, false, true, false, true, false, true, false, true],
  [true, false, true, true, false, true, true, false, true],
];

Color fromQwixx(GameColor? color) {
  return switch (color) {
    GameColor.red => Colors.red[900]!,
    GameColor.yellow => Colors.yellow.shade700,
    GameColor.green => Colors.green[800]!,
    GameColor.blue => Colors.blue[900]!,
    null => Colors.white,
  };
}

class DieWidget extends StatelessWidget {
  const new({super.key, required this.color, required this.roll});

  final Color color;
  final int roll;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.all(5),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        children: [
          for (final dot in _rollPattern[roll - 1])
            dot
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  )
                : SizedBox.shrink(),
        ],
      ),
    );
  }
}
