import 'package:fpdart/fpdart.dart';

typedef PieceMap = Map<String, Option<Piece>>;

class Piece {
  final ChessColor color;
  final PieceType type;

  const Piece(this.color, this.type);

  @override
  String toString() => '$color$type';
}

class ChessColor {
  final int value;

  const ChessColor._value(this.value);

  static const ChessColor WHITE = const ChessColor._value(0);
  static const ChessColor BLACK = const ChessColor._value(1);

  int get hashCode => value;

  String toString() => (this == WHITE) ? 'w' : 'b';

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && hashCode == other.hashCode;
  }
}

class PieceType {
  final String name;

  const PieceType._value(this.name);

  static const PieceType PAWN = const PieceType._value('p');
  static const PieceType KNIGHT = const PieceType._value('n');
  static const PieceType BISHOP = const PieceType._value('b');
  static const PieceType ROOK = const PieceType._value('r');
  static const PieceType QUEEN = const PieceType._value('q');
  static const PieceType KING = const PieceType._value('k');

  factory PieceType.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'p':
        return PieceType.PAWN;
      case 'n':
        return PieceType.KNIGHT;
      case 'b':
        return PieceType.BISHOP;
      case 'r':
        return PieceType.ROOK;
      case 'q':
        return PieceType.QUEEN;
      case 'k':
        return PieceType.KING;
      default:
        throw "Unknown piece type";
    }
  }

  int get hashCode => name.hashCode;

  String toString() => name;

  String toLowerCase() => name;

  String toUpperCase() => name.toUpperCase();

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && hashCode == other.hashCode;
  }
}

class ShortMove {
  final String from;
  final String to;
  final Option<PieceType> promotion;

  ShortMove({
    required this.from,
    required this.to,
    this.promotion = const None(),
  });
}

class HalfMove {
  final String square;
  final Option<Piece> piece;

  HalfMove(this.square, this.piece);

  String toString() {
    return "$square::$piece";
  }
}
