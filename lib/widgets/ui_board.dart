import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';

import 'ui_square.dart';

class UIBoard extends StatelessWidget {
  final Board board;
  final void Function(Board board) onChange;

  UIBoard({Key? key, required this.board, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: board.size,
      height: board.size,
      child: Stack(
        children: board.squares
            .map(
              (it) => UISquare(
                square: it,
                onDrop: (move) => board.makeMove(move).then(onChange),
                onClick: (halfMove) =>
                    board.squareClicked(halfMove).then(onChange),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
