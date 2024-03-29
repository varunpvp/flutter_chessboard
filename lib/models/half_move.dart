import 'package:fpdart/fpdart.dart';

import 'piece.dart';

class HalfMove {
  final String square;
  final Option<Piece> piece;

  HalfMove(this.square, this.piece);

  String toString() {
    return "$square::$piece";
  }
}
