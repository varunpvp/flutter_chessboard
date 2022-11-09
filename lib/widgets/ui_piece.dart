import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/models/half_move.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_tile.dart';
import 'package:fpdart/fpdart.dart';
import 'package:provider/provider.dart';

class UIPiece extends StatelessWidget {
  final String squareName;
  final BoardColor squareColor;
  final Piece piece;
  final double size;

  UIPiece({
    required this.squareName,
    required this.squareColor,
    required this.piece,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<Board>(context);
    final pieceWidget = board.buildPiece
        .flatMap((f) => Option.fromNullable(f(piece, size)))
        .getOrElse(() => _buildPiece(piece, size));

    return Draggable<HalfMove>(
      data: HalfMove(squareName, Option.of(piece)),
      child: pieceWidget,
      feedback: pieceWidget,
      childWhenDragging: UITile(
        color: squareColor,
        size: size,
      ),
    );
  }

  Widget _buildPiece(Piece piece, double size) {
    if (piece == Piece.WHITE_ROOK) {
      return WhiteRook(size: size);
    } else if (piece == Piece.WHITE_KNIGHT) {
      return WhiteKnight(size: size);
    } else if (piece == Piece.WHITE_BISHOP) {
      return WhiteBishop(size: size);
    } else if (piece == Piece.WHITE_KING) {
      return WhiteKing(size: size);
    } else if (piece == Piece.WHITE_QUEEN) {
      return WhiteQueen(size: size);
    } else if (piece == Piece.WHITE_PAWN) {
      return WhitePawn(size: size);
    } else if (piece == Piece.BLACK_ROOK) {
      return BlackRook(size: size);
    } else if (piece == Piece.BLACK_KNIGHT) {
      return BlackKnight(size: size);
    } else if (piece == Piece.BLACK_BISHOP) {
      return BlackBishop(size: size);
    } else if (piece == Piece.BLACK_KING) {
      return BlackKing(size: size);
    } else if (piece == Piece.BLACK_QUEEN) {
      return BlackQueen(size: size);
    } else if (piece == Piece.BLACK_PAWN) {
      return BlackPawn(size: size);
    } else {
      return SizedBox();
    }
  }
}
