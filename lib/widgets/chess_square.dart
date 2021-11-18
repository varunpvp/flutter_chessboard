import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/chess_model.dart';
import 'package:flutter_stateless_chessboard/types.dart' as types;
import 'package:flutter_stateless_chessboard/widgets/chess_piece.dart';
import 'package:flutter_stateless_chessboard/widgets/square.dart';
import 'package:provider/provider.dart';

class ChessSquare extends StatelessWidget {
  final String name;
  final Color color;
  final bool highlight;
  final void Function(types.ShortMove move) onDrop;
  final void Function(types.HalfMove move) onClick;

  ChessSquare({
    required this.name,
    required this.color,
    required this.onClick,
    required this.onDrop,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ChessModel>(context);
    final piece = model.getPiece(name);
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
            size: model.squareSize,
            color: color,
            highlight: highlight,
            child: piece.match(
                (t) => ChessPiece(
                      squareName: name,
                      squareColor: color,
                      piece: t,
                      size: model.squareSize,
                    ),
                () => null),
          ),
        );
      },
    );
  }
}
