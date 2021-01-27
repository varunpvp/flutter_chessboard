import 'package:flutter/material.dart';
import 'package:flutter_chessboard/types.dart';
import 'package:flutter_chessboard/widgets/chess_piece.dart';
import 'package:flutter_chessboard/widgets/square.dart';

class ChessSquare extends StatelessWidget {
  final String name;
  final Color color;
  final double size;
  final Piece piece;
  final void Function(String fromSquare, String toSquare, Piece piece) onDrop;

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
          onDrop(data.square, name, data.piece);
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
