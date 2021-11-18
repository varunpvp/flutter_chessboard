library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/chess_model.dart';
import 'package:flutter_stateless_chessboard/types.dart';
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/chess_square.dart';
import 'package:fpdart/fpdart.dart' show Option;
import 'package:provider/provider.dart';
export 'package:flutter_stateless_chessboard/types.dart';

final zeroToSeven = List.generate(8, (index) => index);

class Chessboard extends StatefulWidget {
  late final ChessModel model;

  Chessboard({
    required String fen,
    required double size,
    ChessColor orientation = ChessColor.WHITE,
    void Function(ShortMove move) onMove = noop1,
    Color lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    Color darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
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
  Option<HalfMove> _lastClickMove = Option.none();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: widget.model,
      child: Container(
        width: widget.model.size,
        height: widget.model.size,
        child: _buildFiles(),
      ),
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

  void handleOnDrop(ShortMove move) {
    widget.model.onMove(move);
    clearLastClickMove();
  }

  void handleOnClick(HalfMove halfMove) {
    _lastClickMove.match(
      (t) {
        final sameSquare = t.square == halfMove.square;
        final sameColorPiece = t.piece
            .map2<Piece, bool>(halfMove.piece, (t, r) => t.color == r.color)
            .getOrElse(() => false);

        if (sameSquare) {
          clearLastClickMove();
        } else if (sameColorPiece) {
          setLastClickMove(halfMove);
        } else {
          widget.model.onMove(ShortMove(
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

  void setLastClickMove(HalfMove move) {
    setState(() {
      _lastClickMove = Option.of(move);
    });
  }
}
