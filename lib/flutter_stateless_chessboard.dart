library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/types.dart' as types;
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/chess_square.dart';
import 'package:fpdart/fpdart.dart' show Option;
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
  Option<types.HalfMove> _lastClickMove = Option.none();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: _buildFiles(),
    );
  }

  Widget _buildFiles() {
    final squareSize = widget.size / 8;
    final pieceMap = getPieceMap(widget.fen);

    return Row(
      children: zeroToSeven.map((fileIndex) {
        return _buildRank(fileIndex, squareSize, pieceMap);
      }).toList(),
    );
  }

  Column _buildRank(
    int fileIndex,
    double squareSize,
    types.PieceMap pieceMap,
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

  Widget _buildChessSquare(
    String square,
    Color color,
    double squareSize,
    types.PieceMap pieceMap,
  ) {
    final highlight =
        _lastClickMove.map((t) => t.square == square).getOrElse(() => false);
    return ChessSquare(
      name: square,
      color: color,
      size: squareSize,
      highlight: highlight,
      piece: Option.fromNullable(pieceMap[square]).flatMap((t) => t),
      onDrop: handleOnDrop,
      onClick: handleOnClick,
    );
  }

  void handleOnDrop(types.ShortMove move) {
    widget.onMove(move);
    clearLastClickMove();
  }

  void handleOnClick(types.HalfMove halfMove) {
    _lastClickMove.match(
      (t) {
        final sameSquare = t.square == halfMove.square;
        final sameColorPiece = t.piece
            .map2<types.Piece, bool>(
                halfMove.piece, (t, r) => t.color == r.color)
            .map((t) => t)
            .getOrElse(() => false);

        if (sameSquare) {
          clearLastClickMove();
        } else if (sameColorPiece) {
          setLastClickMove(halfMove);
        } else {
          widget.onMove(types.ShortMove(
            from: t.square,
            to: halfMove.square,
            promotion: types.PieceType.QUEEN,
          ));
        }
        clearLastClickMove();
      },
      () {
        setLastClickMove(halfMove);
      },
    );
  }

  void clearLastClickMove() {
    setState(() {
      _lastClickMove = Option.none();
    });
  }

  void setLastClickMove(types.HalfMove move) {
    setState(() {
      _lastClickMove = Option.of(move);
    });
  }
}
