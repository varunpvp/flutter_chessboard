import 'package:flutter/material.dart';
import 'package:flutter_chessboard/types.dart';
import 'package:flutter_chessboard/widgets/chess_piece.dart';
import 'package:flutter_chessboard/widgets/square.dart';

class ChessSquare extends StatelessWidget {
  final String name;
  final Color color;
  final double size;
  final Piece piece;
  final void Function(ShortMove move) onDrop;

  ChessSquare({
    this.name,
    @required this.color,
    @required this.size,
    this.piece,
    this.onDrop,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<HalfMove>(
      onWillAccept: (data) {
        return data.square != name;
      },
      onAccept: (data) {
        if (onDrop != null) {
          onDrop(ShortMove(
            from: data.square,
            to: name,
            promotion: data.piece.type,
          ));
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Square(
          size: size,
          color: color,
          child: piece != null
              ? ChessPiece(
                  squareName: name,
                  squareColor: color,
                  piece: piece,
                  size: size,
                )
              : null,
        );
      },
    );
  }
}
