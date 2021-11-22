import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/half_move.dart';
import 'package:flutter_stateless_chessboard/models/short_move.dart';
import 'package:flutter_stateless_chessboard/models/square.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_piece.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_tile.dart';

class UISquare extends StatelessWidget {
  final Square square;
  final void Function(ShortMove move) onDrop;
  final void Function(HalfMove move) onClick;
  final bool highlight;

  UISquare({
    required this.square,
    required this.onClick,
    required this.onDrop,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: square.x,
      top: square.y,
      width: square.size,
      height: square.size,
      child: DragTarget<HalfMove>(
        onWillAccept: (data) {
          return data?.square != square.name;
        },
        onAccept: (data) {
          onDrop(ShortMove(
            from: data.square,
            to: square.name,
          ));
        },
        builder: (context, candidateData, rejectedData) {
          return InkWell(
            onTap: () => onClick(HalfMove(square.name, square.piece)),
            child: _buildSquare(),
          );
        },
      ),
    );
  }

  Widget _buildSquare() {
    return Stack(
      children: [
        UITile(
          color: square.color,
          size: square.size,
        ),
        if (highlight)
          Container(
            color: Color.fromRGBO(128, 128, 128, .3),
            height: square.size,
            width: square.size,
          ),
        SizedBox(
          child: square.piece.match(
            (t) => UIPiece(
              squareName: square.name,
              squareColor: square.color,
              piece: t,
              size: square.size,
            ),
            () => null,
          ),
        ),
      ],
    );
  }
}
