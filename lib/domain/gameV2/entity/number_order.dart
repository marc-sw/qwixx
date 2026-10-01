import 'package:qwixx/domain/gameV2/entity/card.dart';

sealed class NumberOrder {
  int indexOf(Number number);
  Number numberAt(int index);

  static const NumberOrder ascending = _Ascending();
  static const NumberOrder descending = _Descending();
}

class _Ascending implements NumberOrder {
  const new();
  @override
  int indexOf(Number number) {
    return number.index;
  }

  @override
  Number numberAt(int index) {
    return Number.values[index];
  }
}

class _Descending implements NumberOrder {
  const new();
  @override
  int indexOf(Number number) {
    return numberCount - number.index - 1;
  }

  @override
  Number numberAt(int index) {
    return Number.values[numberCount - index];
  }
}
