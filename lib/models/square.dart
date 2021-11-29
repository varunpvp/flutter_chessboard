import 'package:fpdart/fpdart.dart';

import 'coordinate.dart';
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
}
