import 'package:flutter_stateless_chessboard/types.dart';
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/utils.dart' as utils;
import 'package:fpdart/fpdart.dart';

class ChessModel {
  final String fen;
  final double size;
  final ChessColor orientation;
  final void Function(ShortMove move) onMove;
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

  List<SquareModel> get squares => getSquares(fen);

  String getSquare(int rankIndex, int fileIndex) {
    return utils.getSquare(rankIndex, fileIndex, orientation);
  }

  Color getColor(int rankIndex, int fileIndex) {
    return (rankIndex + fileIndex) % 2 == 0
        ? lightSquareColor
        : darkSquareColor;
  }

  Option<Piece> getPiece(String square) {
    return squares.firstWhere((t) => t.name == square).piece;
  }
}
