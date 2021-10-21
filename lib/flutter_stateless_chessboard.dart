library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/types.dart' as types;
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/chess_square.dart';

export 'package:flutter_stateless_chessboard/types.dart';

final zeroToSeven = List.generate(8, (index) => index);

class Chessboard extends StatefulWidget {
  final String fen;
  final double size;
  final types.Color orientation;
  final void Function(types.ShortMove move) onMove;
  final Color lightSquareColor;
  final Color darkSquareColor;

  Chessboard({
    required this.fen,
    required this.size,
    this.orientation = types.Color.WHITE,
    this.onMove = noop1,
    this.lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    this.darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
  });

  @override
  State<StatefulWidget> createState() {
    return _ChessboardState();
  }
}

class _ChessboardState extends State<Chessboard> {
  types.HalfMove? _lastClickMove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Row(
        children: _buildFiles(),
      ),
    );
  }

  List<Widget> _buildFiles() {
    final squareSize = widget.size / 8;
    final pieceMap = getPieceMap(widget.fen);
    return zeroToSeven.map((fileIndex) {
      return _buildRank(fileIndex, squareSize, pieceMap);
    }).toList();
  }

  Column _buildRank(
    int fileIndex,
    double squareSize,
    Map<String, types.Piece> pieceMap,
  ) {
    return Column(
      children: zeroToSeven.map((rankIndex) {
        final square = getSquare(rankIndex, fileIndex, widget.orientation);
        final color = (rankIndex + fileIndex) % 2 == 0
            ? widget.lightSquareColor
            : widget.darkSquareColor;
        return _buildChessSquare(
          square,
          color,
          squareSize,
          pieceMap,
        );
      }).toList(),
    );
  }

  ChessSquare _buildChessSquare(
    String square,
    Color color,
    double squareSize,
    Map<String, types.Piece> pieceMap,
  ) {
    return ChessSquare(
      name: square,
      color: color,
      size: squareSize,
      highlight: _lastClickMove?.square == square,
      piece: pieceMap[square] ?? types.NoPiece(),
      onDrop: (move) {
        widget.onMove(move);
        setLastClickMove(null);
      },
      onClick: (halfMove) {
        if (_lastClickMove != null) {
          if (_lastClickMove?.square == halfMove.square) {
            setLastClickMove(null);
          } else if (_lastClickMove?.piece.color == halfMove.piece.color) {
            setLastClickMove(halfMove);
          } else {
            widget.onMove(types.ShortMove(
              from: _lastClickMove?.square ?? '',
              to: halfMove.square,
              promotion: types.PieceType.QUEEN,
            ));
          }
          setLastClickMove(null);
        } else {
          setLastClickMove(halfMove);
        }
      },
    );
  }

  void setLastClickMove(types.HalfMove? move) {
    setState(() {
      _lastClickMove = move;
    });
  }
}
