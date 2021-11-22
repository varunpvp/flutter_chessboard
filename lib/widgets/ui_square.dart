import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/models/half_move.dart';
import 'package:flutter_stateless_chessboard/models/piece.dart';
import 'package:flutter_stateless_chessboard/models/short_move.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_piece.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_tile.dart';
import 'package:fpdart/fpdart.dart';
import 'package:provider/provider.dart';

class UISquare extends StatelessWidget {
  final String name;
  final Color color;
  final bool highlight;
  final void Function(ShortMove move) onDrop;
  final void Function(HalfMove move) onClick;

  UISquare({
    required this.name,
    required this.color,
    required this.onClick,
    required this.onDrop,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<Board>(context);
    final piece = board.getPiece(name);
    return DragTarget<HalfMove>(
      onWillAccept: (data) {
        return data?.square != name;
      },
      onAccept: (data) {
        onDrop(ShortMove(
          from: data.square,
          to: name,
        ));
      },
      builder: (context, candidateData, rejectedData) {
        return InkWell(
          onTap: () => onClick(HalfMove(name, piece)),
          child: _buildSquare(board, piece),
        );
      },
    );
  }

  Widget _buildSquare(Board board, Option<Piece> piece) {
    return Stack(
      children: [
        UITile(
          color: color,
          size: board.squareSize,
        ),
        if (highlight)
          Container(
            color: Color.fromRGBO(128, 128, 128, .3),
            height: board.squareSize,
            width: board.squareSize,
          ),
        SizedBox(
          child: piece.match(
            (t) => UIPiece(
              squareName: name,
              squareColor: color,
              piece: t,
              size: board.squareSize,
            ),
            () => null,
          ),
        ),
      ],
    );
  }
}
