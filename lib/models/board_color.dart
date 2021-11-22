class BoardColor {
  final int value;

  const BoardColor._value(this.value);

  static const BoardColor WHITE = const BoardColor._value(0);
  static const BoardColor BLACK = const BoardColor._value(1);

  int get hashCode => value.hashCode;

  String toString() => (this == WHITE) ? 'w' : 'b';

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && hashCode == other.hashCode;
  }
}
