class Piece {
  final String type;
  final String color;

  Piece(this.type, this.color);

  @override
  String toString() {
    return "$color$type";
  }

  @override
  bool operator ==(Object other) {
    return super == other;
  }

  @override
  int get hashCode => toString().hashCode;
}

class ShortMove {
  final String from;
  final String to;
  final String promotion;

  ShortMove({this.from, this.to, this.promotion});
}

class HalfMove {
  final String square;
  final Piece piece;

  HalfMove(this.square, this.piece);
}
