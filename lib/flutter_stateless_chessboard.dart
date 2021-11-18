library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/chess_model.dart';
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
  late final ChessModel model;

  Chessboard({
    required this.fen,
    required this.size,
    this.orientation = types.Color.WHITE,
    this.onMove = noop1,
    this.lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    this.darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
  }) {
    model = ChessModel(
      fen: fen,
      size: size,
      orientation: orientation,
      onMove: onMove,
      lightSquareColor: lightSquareColor,
      darkSquareColor: darkSquareColor,
    );
  }

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
    return Row(
      children: zeroToSeven.map((fileIndex) {
        return _buildRank(fileIndex);
      }).toList(growable: false),
    );
  }

  Column _buildRank(int fileIndex) {
    return Column(
      children: zeroToSeven.map((rankIndex) {
        final square = widget.model.getSquare(rankIndex, fileIndex);
        final color = widget.model.getColor(rankIndex, fileIndex);
        return _buildChessSquare(square, color);
      }).toList(growable: false),
    );
  }

  Widget _buildChessSquare(String square, Color color) {
    return ChessSquare(
      name: square,
      color: color,
      highlight:
          _lastClickMove.map((t) => t.square == square).getOrElse(() => false),
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
            .getOrElse(() => false);

        if (sameSquare) {
          clearLastClickMove();
        } else if (sameColorPiece) {
          setLastClickMove(halfMove);
        } else {
          widget.onMove(types.ShortMove(
            from: t.square,
            to: halfMove.square,
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
