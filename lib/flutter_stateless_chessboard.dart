library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/types.dart';
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/chess_square.dart';

final zeroToSeven = List.generate(8, (index) => index);

class Chessboard extends StatefulWidget {
  final String fen;
  final double boardSize;
  final String orientation; // 'w' | 'b'
  final void Function(ShortMove move)? onMove;
  final Color lightSquareColor;
  final Color darkSquareColor;

  Chessboard({
    required this.fen,
    required this.boardSize,
    this.orientation = 'w',
    this.onMove,
    this.lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    this.darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
  });

  double get squareSize => this.boardSize / 8;

  @override
  State<StatefulWidget> createState() {
    return _ChessboardState();
  }
}

class _ChessboardState extends State<Chessboard> {
  HalfMove? _clickMove;

  _pickColor(int rankIndex, int fileIndex) => (rankIndex + fileIndex) % 2 == 0
      ? widget.lightSquareColor
      : widget.darkSquareColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.boardSize,
      height: widget.boardSize,
      child: Row(
        children: zeroToSeven
            .map((fileIndex) => Column(
                  children: zeroToSeven
                      .map(
                          (rankIndex) => buildChessSquare(rankIndex, fileIndex))
                      .toList(),
                ))
            .toList(),
      ),
    );
  }

  ChessSquare buildChessSquare(int rankIndex, int fileIndex) => ChessSquare(
        name: getSquareName(rankIndex, fileIndex),
        color: _pickColor(rankIndex, fileIndex),
        size: widget.squareSize,
        highlight: isHighlighted(rankIndex, fileIndex),
        piece: getPieceMap(widget.fen)[getSquareName(rankIndex, fileIndex)],
        onDrop: (move) {
          if (widget.onMove != null) {
            widget.onMove!(move);
            setClickMove(null);
          }
        },
        onClick: (halfMove) {
          if (_clickMove != null) {
            if (_clickMove!.square == halfMove.square) {
              setClickMove(null);
            } else if (_clickMove!.piece.color == halfMove.piece.color) {
              setClickMove(halfMove);
            } else {
              widget.onMove!(ShortMove(
                from: _clickMove!.square,
                to: halfMove.square,
                promotion: 'q',
              ));
            }
            setClickMove(null);
          } else {
            setClickMove(halfMove);
          }
        },
      );

  bool isHighlighted(int rankIndex, int fileIndex) =>
      _clickMove?.square == getSquareName(rankIndex, fileIndex);

  void setClickMove(HalfMove? move) {
    setState(() {
      _clickMove = move;
    });
  }

  String getSquareName(int rankIndex, int fileIndex) {
    final rank = widget.orientation == 'b' ? rankIndex + 1 : 8 - rankIndex;
    final file = widget.orientation == 'b' ? 7 - fileIndex : fileIndex;
    return '${String.fromCharCode(file + 97)}$rank';
  }
}
