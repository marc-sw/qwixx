part of 'card_widget.dart';

const RectConfig _numberTileConfig = RectConfig(48, 23, 35, 1, 17);
const RectConfig _missTileConfig = RectConfig(25, 307, 523, 1, 0);
const ContainerConfig _missContainerConfig = ContainerConfig(
  307,
  522,
  25,
  2,
  4,
);

class ContainerConfig {
  final double topOffset;
  final double leftOffset;
  final double childSize;
  final double spacing;
  final double childCount;
  const new(
    this.topOffset,
    this.leftOffset,
    this.childSize,
    this.spacing,
    this.childCount,
  );

  double get mainAxisSize => (childSize + spacing) * childCount - spacing;
  double get crossAxisSize => childSize;
}

class Rect {
  final double top;
  final double left;
  final double width;
  final double height;
  const Rect(this.top, this.left, this.width, this.height);
}

class Spot {
  final int column;
  final int row;

  const Spot(this.column, this.row);
}

class RectConfig {
  final double size;
  final double topOffset;
  final double leftOffset;
  final double perColumnOffset;
  final double perRowOffset;

  const RectConfig(
    this.size,
    this.topOffset,
    this.leftOffset,
    this.perColumnOffset,
    this.perRowOffset,
  );
}

class RectMath {
  static Rect _calculate(Spot spot, RectConfig config) {
    return Rect(
      config.topOffset + (config.perRowOffset + config.size) * spot.column,
      config.leftOffset + (config.perColumnOffset + config.size) * spot.row,
      config.size,
      config.size,
    );
  }

  static Positioned _positioned(Spot spot, RectConfig config, Widget child) {
    final rect = _calculate(spot, config);

    return Positioned(
      top: rect.top,
      left: rect.left,
      width: rect.width,
      height: rect.height,
      child: child,
    );
  }

  static Rect calculateNumberTile(Spot spot) {
    return _calculate(spot, _numberTileConfig);
  }

  static Positioned positionedNumberTile({
    required Spot spot,
    required Widget child,
  }) {
    return _positioned(spot, _numberTileConfig, child);
  }

  static Positioned positionedMissTile({
    required Spot spot,
    required Widget child,
  }) {
    return _positioned(spot, _missTileConfig, child);
  }
}
