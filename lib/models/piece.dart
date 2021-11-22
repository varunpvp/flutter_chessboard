import 'dart:ui' show hashValues;

import 'board_color.dart';
import 'piece_type.dart';

class Piece {
  final BoardColor color;
  final PieceType type;

  const Piece(this.color, this.type);

  static const Piece WHITE_PAWN = const Piece(BoardColor.WHITE, PieceType.PAWN);
  static const Piece WHITE_KNIGHT =
      const Piece(BoardColor.WHITE, PieceType.KNIGHT);
  static const Piece WHITE_BISHOP =
      const Piece(BoardColor.WHITE, PieceType.BISHOP);
  static const Piece WHITE_ROOK = const Piece(BoardColor.WHITE, PieceType.ROOK);
  static const Piece WHITE_QUEEN =
      const Piece(BoardColor.WHITE, PieceType.QUEEN);
  static const Piece WHITE_KING = const Piece(BoardColor.WHITE, PieceType.KING);

  static const Piece BLACK_PAWN = const Piece(BoardColor.BLACK, PieceType.PAWN);
  static const Piece BLACK_KNIGHT =
      const Piece(BoardColor.BLACK, PieceType.KNIGHT);
  static const Piece BLACK_BISHOP =
      const Piece(BoardColor.BLACK, PieceType.BISHOP);
  static const Piece BLACK_ROOK = const Piece(BoardColor.BLACK, PieceType.ROOK);
  static const Piece BLACK_QUEEN =
      const Piece(BoardColor.BLACK, PieceType.QUEEN);
  static const Piece BLACK_KING = const Piece(BoardColor.BLACK, PieceType.KING);

  @override
  String toString() => '$color$type';

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && hashCode == other.hashCode;
  }

  @override
  int get hashCode => hashValues(color, type);
}
