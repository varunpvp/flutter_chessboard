import 'package:chess/chess.dart';
import 'package:dartz/dartz.dart';

class Piece {
  final String type;
  final Color color;

  Piece(this.type, this.color);

  @override
  String toString() {
    final colorLetter =
        this.color.toString().split('.')[1].substring(0, 1).toLowerCase();
    return "$colorLetter$type";
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

  ShortMove({
    required this.from,
    required this.to,
    required this.promotion,
  });
}

class HalfMove {
  final String square;
  final Option<Piece> piece;

  HalfMove(this.square, this.piece);

  toString() => 'Square: $square \n $piece';
}
