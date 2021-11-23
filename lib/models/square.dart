import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/coordinate.dart';
import 'package:fpdart/fpdart.dart';

import 'board.dart';
import 'piece.dart';

class Square extends Coordinate {
  final Board board;
  final String name;
  final Option<Piece> piece;

  Square({
    required this.board,
    required this.name,
    required this.piece,
  }) : super(
          orientation: board.orientation,
          square: name,
          size: board.squareSize,
        );

  Color get color {
    return (xAxis + yAxis) % 2 == 0
        ? board.lightSquareColor
        : board.darkSquareColor;
  }
}
