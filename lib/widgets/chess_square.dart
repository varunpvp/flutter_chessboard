import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/types.dart' as types;
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/chess_piece.dart';
import 'package:flutter_stateless_chessboard/widgets/square.dart';
import 'package:fpdart/fpdart.dart';

class ChessSquare extends StatelessWidget {
  final String name;
  final Color color;
  final double size;
  final Option<types.Piece> piece;
  final void Function(types.ShortMove move) onDrop;
  final void Function(types.HalfMove move) onClick;
  final bool highlight;

  ChessSquare({
    required this.name,
    required this.color,
    required this.size,
    this.piece = const None(),
    this.highlight = false,
    this.onDrop = noop1,
    this.onClick = noop1,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<types.HalfMove>(
      onWillAccept: (data) {
        return data?.square != name;
      },
      onAccept: (data) {
        onDrop(types.ShortMove(
          from: data.square,
          to: name,
        ));
      },
      builder: (context, candidateData, rejectedData) {
        return InkWell(
          onTap: () => onClick(types.HalfMove(name, piece)),
          child: Square(
            size: size,
            color: color,
            highlight: highlight,
            child: piece.match(
                (t) => ChessPiece(
                      squareName: name,
                      squareColor: color,
                      piece: t,
                      size: size,
                    ),
                () => null),
          ),
        );
      },
    );
  }
}
