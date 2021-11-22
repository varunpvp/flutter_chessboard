import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/half_move.dart';
import 'package:flutter_stateless_chessboard/utils.dart' as utils;
import 'package:fpdart/fpdart.dart';

import 'board_color.dart';
import 'piece.dart';
import 'piece_type.dart';
import 'short_move.dart';
import 'square.dart';

typedef Promoted = Future<PieceType?> Function();
typedef Moved = void Function(ShortMove move);

class Board {
  final String fen;
  final double size;
  final BoardColor orientation;
  final Color lightSquareColor;
  final Color darkSquareColor;
  final Option<HalfMove> clickMove;
  late final Moved _onMove;
  late final Promoted _onPromote;

  Board({
    required this.fen,
    required this.size,
    required this.orientation,
    required this.lightSquareColor,
    required this.darkSquareColor,
    required Moved onMove,
    required Promoted onPromote,
    this.clickMove = const None(),
  }) {
    _onMove = onMove;
    _onPromote = onPromote;
  }

  double get squareSize => size / 8;

  List<Square> get squares => utils.getSquares(fen);

  String getSquare(int rankIndex, int fileIndex) {
    return utils.getSquare(rankIndex, fileIndex, orientation);
  }

  Color getColor(int rankIndex, int fileIndex) {
    return (rankIndex + fileIndex) % 2 == 0
        ? lightSquareColor
        : darkSquareColor;
  }

  Option<Piece> getPiece(String square) {
    return squares.firstWhere((t) => t.name == square).piece;
  }

  Future<void> makeMove(ShortMove move) async {
    if (utils.isPromoting(fen, move)) {
      final pieceType = await promotion;
      pieceType.match(
        (t) {
          _onMove(ShortMove(
            from: move.from,
            to: move.to,
            promotion: Option.of(t),
          ));
        },
        () {
          // promotion cancelled
        },
      );
    } else {
      _onMove(move);
    }
  }

  Future<Option<PieceType>> get promotion async {
    return Option.fromNullable(await _onPromote()).map(
      (t) => t == PieceType.KING || t == PieceType.PAWN ? PieceType.QUEEN : t,
    );
  }

  Board copyWith({final Option<HalfMove>? clickMove}) {
    return Board(
      fen: fen,
      size: size,
      orientation: orientation,
      lightSquareColor: lightSquareColor,
      darkSquareColor: darkSquareColor,
      onMove: _onMove,
      onPromote: _onPromote,
      clickMove: clickMove ?? this.clickMove,
    );
  }

  Board setClickMove(final HalfMove clickMove) {
    return copyWith(clickMove: Option.of(clickMove));
  }

  Board clearClickMove() {
    return copyWith(clickMove: Option.none());
  }
}
