import 'package:fpdart/fpdart.dart';

import 'piece.dart';

class Square {
  final String name;
  final Option<Piece> piece;

  Square({
    required this.name,
    required this.piece,
  });
}
