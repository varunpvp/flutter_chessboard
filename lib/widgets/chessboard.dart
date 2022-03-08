library flutter_chessboard;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/models/board_arrow.dart';
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
    List<BoardArrow> arrows = const [],
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
          arrows: arrows,
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
            children: [
              ...widget.board.squares.map((it) {
                return UISquare(
                  square: it,
                  onClick: _handleClick,
                  onDrop: _handleDrop,
                  highlight: _getHighlight(it),
                );
              }).toList(growable: false),
              if (widget.board.arrows.isNotEmpty)
                IgnorePointer(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: CustomPaint(
                      child: Container(),
                      painter: _ArrowPainter(
                          widget.board.arrows, widget.board.orientation),
                    ),
                  ),
                ),
            ]),
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
      () => _setClickMove(halfMove),
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

/*
Adapted from https://github.com/deven98/flutter_chess_board/blob/97fe52c9a0c706b455b2162df55b050eb92ff70e/lib/src/chess_board.dart
*/
const files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

class _ArrowPainter extends CustomPainter {
  List<BoardArrow> arrows;
  BoardColor orientation;

  _ArrowPainter(this.arrows, this.orientation);

  @override
  void paint(Canvas canvas, Size size) {
    var blockSize = size.width / 8;
    var halfBlockSize = size.width / 16;

    final baseArrowLengthProportion = 0.6;

    for (var arrow in arrows) {
      var startFile = files.indexOf(arrow.from[0]);
      var startRank = int.parse(arrow.from[1]) - 1;
      var endFile = files.indexOf(arrow.to[0]);
      var endRank = int.parse(arrow.to[1]) - 1;

      int effectiveRowStart = 0;
      int effectiveColumnStart = 0;
      int effectiveRowEnd = 0;
      int effectiveColumnEnd = 0;

      if (orientation == BoardColor.BLACK) {
        effectiveColumnStart = 7 - startFile;
        effectiveColumnEnd = 7 - endFile;
        effectiveRowStart = startRank;
        effectiveRowEnd = endRank;
      } else {
        effectiveColumnStart = startFile;
        effectiveColumnEnd = endFile;
        effectiveRowStart = 7 - startRank;
        effectiveRowEnd = 7 - endRank;
      }

      var startOffset = Offset(
          ((effectiveColumnStart + 1) * blockSize) - halfBlockSize,
          ((effectiveRowStart + 1) * blockSize) - halfBlockSize);
      var endOffset = Offset(
          ((effectiveColumnEnd + 1) * blockSize) - halfBlockSize,
          ((effectiveRowEnd + 1) * blockSize) - halfBlockSize);

      var yDist = baseArrowLengthProportion * (endOffset.dy - startOffset.dy);
      var xDist = baseArrowLengthProportion * (endOffset.dx - startOffset.dx);

      var paint = Paint()
        ..strokeWidth = halfBlockSize * baseArrowLengthProportion
        ..color = arrow.color;

      canvas.drawLine(startOffset,
          Offset(startOffset.dx + xDist, startOffset.dy + yDist), paint);

      var slope =
          (endOffset.dy - startOffset.dy) / (endOffset.dx - startOffset.dx);

      var newLineSlope = -1 / slope;

      var points = _getNewPoints(
          Offset(startOffset.dx + xDist, startOffset.dy + yDist),
          newLineSlope,
          halfBlockSize);
      var newPoint1 = points[0];
      var newPoint2 = points[1];

      var path = Path();

      path.moveTo(endOffset.dx, endOffset.dy);
      path.lineTo(newPoint1.dx, newPoint1.dy);
      path.lineTo(newPoint2.dx, newPoint2.dy);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  List<Offset> _getNewPoints(Offset start, double slope, double length) {
    if (slope == double.infinity || slope == double.negativeInfinity) {
      return [
        Offset(start.dx, start.dy + length),
        Offset(start.dx, start.dy - length)
      ];
    }

    return [
      Offset(start.dx + (length / sqrt(1 + (slope * slope))),
          start.dy + ((length * slope) / sqrt(1 + (slope * slope)))),
      Offset(start.dx - (length / sqrt(1 + (slope * slope))),
          start.dy - ((length * slope) / sqrt(1 + (slope * slope)))),
    ];
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) {
    return arrows != oldDelegate.arrows;
  }
}
