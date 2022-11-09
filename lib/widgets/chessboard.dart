library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/models/board_color.dart';
import 'package:flutter_stateless_chessboard/models/half_move.dart';
import 'package:flutter_stateless_chessboard/models/piece.dart';
import 'package:flutter_stateless_chessboard/models/short_move.dart';
import 'package:flutter_stateless_chessboard/models/square.dart';
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_square.dart';
import 'package:fpdart/fpdart.dart' show Option;
import 'package:provider/provider.dart';

class Chessboard extends StatefulWidget {
  final Board board;

  Chessboard({
    required String fen,
    required double size,
    BoardColor orientation = BoardColor.WHITE,
    Color lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    Color darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
    Moved onMove = noop1,
    Promoted onPromote = defaultPromoting,
    BuildPiece? buildPiece,
    BuildSquare? buildSquare,
    BuildCustomPiece? buildCustomPiece,
    Color lastMoveHighlightColor = const Color.fromRGBO(128, 128, 128, .3),
    Color selectionHighlightColor = const Color.fromRGBO(128, 128, 128, .3),
    List<String> lastMove = const [],
  }) : board = Board(
          fen: fen,
          size: size,
          orientation: orientation,
          onMove: onMove,
          lightSquareColor: lightSquareColor,
          darkSquareColor: darkSquareColor,
          onPromote: onPromote,
          buildPiece: buildPiece,
          buildSquare: buildSquare,
          buildCustomPiece: buildCustomPiece,
          lastMove: lastMove,
          lastMoveHighlightColor: lastMoveHighlightColor,
          selectionHighlightColor: selectionHighlightColor,
        );

  @override
  State<StatefulWidget> createState() => _ChessboardState();
}

class _ChessboardState extends State<Chessboard> {
  Option<HalfMove> clickMove = Option.none();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: widget.board,
      child: Container(
        width: widget.board.size,
        height: widget.board.size,
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          textDirection: TextDirection.ltr,
          children: widget.board.squares.map((it) {
            return UISquare(
              square: it,
              onClick: _handleClick,
              onDrop: _handleDrop,
              highlight: _getHighlight(it),
            );
          }).toList(growable: false),
        ),
      ),
    );
  }

  Color? _getHighlight(Square square) {
    return clickMove
        .filter((t) => t.square == square.name)
        .map((_) => widget.board.selectionHighlightColor)
        .alt(() => Option.fromPredicate(
              widget.board.lastMoveHighlightColor,
              (_) => widget.board.lastMove.contains(square.name),
            ))
        .toNullable();
  }

  void _handleDrop(ShortMove move) {
    widget.board.makeMove(move).then((_) {
      _clearClickMove();
    });
  }

  void _handleClick(HalfMove halfMove) {
    clickMove.match(
      () => _setClickMove(halfMove),
      (t) {
        final sameSquare = t.square == halfMove.square;
        final sameColorPiece = t.piece
            .map2<Piece, bool>(halfMove.piece, (t, r) => t.color == r.color)
            .getOrElse(() => false);

        if (sameSquare) {
          _clearClickMove();
        } else if (sameColorPiece) {
          _setClickMove(halfMove);
        } else {
          widget.board.makeMove(ShortMove(
            from: t.square,
            to: halfMove.square,
          ));
          _clearClickMove();
        }
      },
    );
  }

  void _setClickMove(HalfMove halfMove) {
    setState(() {
      clickMove = Option.of(halfMove).flatMap((t) => t.piece.map((_) => t));
    });
  }

  void _clearClickMove() {
    setState(() {
      clickMove = Option.none();
    });
  }
}
