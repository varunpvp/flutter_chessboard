import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';

class Coordinate {
  final String square;
  final double size;
  final BoardColor orientation;

  Coordinate({
    required this.square,
    required this.size,
    required this.orientation,
  });

  String get file => square.substring(0, 1);

  String get rank => square.substring(1);

  int get xAxis {
    final i = file.codeUnitAt(0) - 97;
    return orientation == BoardColor.BLACK ? 7 - i : i;
  }

  int get yAxis {
    final i = int.parse(rank) - 1;
    return orientation == BoardColor.BLACK ? i : 7 - i;
  }

  double get x => xAxis * size;

  double get y => yAxis * size;

  BoardColor get color {
    return (xAxis + yAxis) % 2 == 0 ? BoardColor.WHITE : BoardColor.BLACK;
  }
}
