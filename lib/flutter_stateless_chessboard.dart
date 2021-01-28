library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/types.dart';
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/chess_square.dart';

final zeroToSeven = List.generate(8, (index) => index);

class Chessboard extends StatelessWidget {
  final String fen;
  final double size;
  final String orientation; // 'w' | 'b'
  final void Function(ShortMove move) onMove;
  final Color lightSquareColor;
  final Color darkSquareColor;

  Chessboard({
    @required this.fen,
    @required this.size,
    this.orientation = 'w',
    this.onMove,
    this.lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    this.darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
  });

  @override
  Widget build(BuildContext context) {
    final squareSize = size / 8;

    final pieceMap = getPieceMap(fen);

    return Container(
      width: size,
      height: size,
      child: Row(
        children: zeroToSeven.map((fileIndex) {
          return Column(
            children: zeroToSeven.map((rankIndex) {
              final square = getSquare(rankIndex, fileIndex, orientation);
              final color = (rankIndex + fileIndex) % 2 == 0
                  ? lightSquareColor
                  : darkSquareColor;
              return ChessSquare(
                name: square,
                color: color,
                size: squareSize,
                piece: pieceMap[square],
                onDrop: (move) {
                  if (onMove != null) {
                    onMove(move);
                  }
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
