library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/types.dart';
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/chess_square.dart';
import 'package:fpdart/fpdart.dart' show Option;
import 'package:provider/provider.dart';

import 'models/board_color.dart';
import 'models/half_move.dart';
import 'models/piece.dart';
import 'models/short_move.dart';
export 'package:flutter_stateless_chessboard/types.dart';

final zeroToSeven = List.generate(8, (index) => index);

class Chessboard extends StatefulWidget {
  late final Board model;

  Chessboard({
    required String fen,
    required double size,
    BoardColor orientation = BoardColor.WHITE,
    Color lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    Color darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
    Moved onMove = noop1,
    Promoted onPromote = defaultPromoting,
  }) {
    model = Board(
      fen: fen,
      size: size,
      orientation: orientation,
      onMove: onMove,
      lightSquareColor: lightSquareColor,
      darkSquareColor: darkSquareColor,
      onPromote: onPromote,
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
    widget.model.makeMove(move);
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
          widget.model.makeMove(ShortMove(
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
