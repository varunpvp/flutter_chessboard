import 'board_color.dart';
import 'piece_type.dart';

class Piece {
  final BoardColor color;
  final PieceType type;

  const Piece(this.color, this.type);

  @override
  String toString() => '$color$type';
}
