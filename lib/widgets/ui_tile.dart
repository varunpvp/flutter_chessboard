import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:fpdart/fpdart.dart';
import 'package:provider/provider.dart';

class UITile extends StatelessWidget {
  final BoardColor color;
  final double size;

  UITile({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<Board>(context);

    return board.buildSquare
        .flatMap((t) => Option.fromNullable(t(size, color)))
        .getOrElse(() => Container(
              color: color == BoardColor.WHITE
                  ? board.lightSquareColor
                  : board.darkSquareColor,
              height: size,
              width: size,
            ));
  }
}
