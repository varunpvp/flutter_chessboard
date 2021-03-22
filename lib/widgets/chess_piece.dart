import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/types.dart' as types;
import 'package:flutter_stateless_chessboard/widgets/square.dart';

class ChessPiece extends StatelessWidget {
  final String squareName;
  final Color squareColor;
  final types.Piece piece;
  final double size;

  ChessPiece({
    @required this.squareName,
    @required this.squareColor,
    @required this.piece,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final pieceWidget = _buildPiece();

    return Draggable<types.HalfMove>(
      data: types.HalfMove(squareName, piece),
      child: pieceWidget,
      feedback: pieceWidget,
      childWhenDragging: Square(
        color: squareColor,
        size: size,
      ),
    );
  }

  Widget _buildPiece() {
    switch (piece.toString()) {
      case 'wr':
        return WhiteRook(size: size);
      case 'wn':
        return WhiteKnight(size: size);
      case 'wb':
        return WhiteBishop(size: size);
      case 'wk':
        return WhiteKing(size: size);
      case 'wq':
        return WhiteQueen(size: size);
      case 'wp':
        return WhitePawn(size: size);
      case 'br':
        return BlackRook(size: size);
      case 'bn':
        return BlackKnight(size: size);
      case 'bb':
        return BlackBishop(size: size);
      case 'bk':
        return BlackKing(size: size);
      case 'bq':
        return BlackQueen(size: size);
      case 'bp':
        return BlackPawn(size: size);
      default:
        return null;
    }
  }
}
