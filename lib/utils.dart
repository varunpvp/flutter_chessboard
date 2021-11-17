import 'package:chess/chess.dart' as ch;
import 'package:flutter_stateless_chessboard/types.dart';
import 'package:fpdart/fpdart.dart';

String getSquare(int rankIndex, int fileIndex, Color orientation) {
  final rank = orientation == Color.BLACK ? rankIndex + 1 : 8 - rankIndex;
  final file = orientation == Color.BLACK ? 7 - fileIndex : fileIndex;
  return '${String.fromCharCode(file + 97)}$rank';
}

PieceMap getPieceMap(String fen) {
  final chess = ch.Chess.fromFEN(fen);
  final PieceMap map = Map();
  ch.Chess.SQUARES.keys.toList().forEach((square) {
    map[square] = Option.fromNullable(chess.get(square)).map(
      (t) => Piece(
        t.color == ch.Color.WHITE ? Color.WHITE : Color.BLACK,
        PieceType.fromString(t.type.toString()),
      ),
    );
  });
  return map;
}

bool isPromoting(String fen, ShortMove move) {
  final chess = ch.Chess.fromFEN(fen);

  final piece = chess.get(move.from);

  if (piece?.type != ch.PieceType.PAWN) {
    return false;
  }

  if (piece?.color != chess.turn) {
    return false;
  }

  if (!["1", "8"].any((it) => move.to.endsWith(it))) {
    return false;
  }

  return chess
      .moves({"square": move.from, "verbose": true})
      .map((it) => it["to"])
      .contains(move.to);
}

noop1(arg1) {}
