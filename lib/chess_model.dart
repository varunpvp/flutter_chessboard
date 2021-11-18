import 'package:flutter_stateless_chessboard/types.dart' as types;
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/utils.dart' as utils;
import 'package:fpdart/fpdart.dart';

class ChessModel {
  final String fen;
  final double size;
  final types.ChessColor orientation;
  final void Function(types.ShortMove move) onMove;
  final Color lightSquareColor;
  final Color darkSquareColor;

  ChessModel({
    required this.fen,
    required this.size,
    required this.orientation,
    required this.onMove,
    required this.lightSquareColor,
    required this.darkSquareColor,
  });

  double get squareSize => size / 8;

  types.PieceMap get pieceMap => getPieceMap(fen);

  String getSquare(int rankIndex, int fileIndex) {
    return utils.getSquare(rankIndex, fileIndex, orientation);
  }

  Color getColor(int rankIndex, int fileIndex) {
    return (rankIndex + fileIndex) % 2 == 0
        ? lightSquareColor
        : darkSquareColor;
  }

  Option<types.Piece> getPiece(String square) {
    return Option.fromNullable(pieceMap[square]).flatMap(
      (t) => t,
    );
  }
}
