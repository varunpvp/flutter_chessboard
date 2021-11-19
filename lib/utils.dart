import 'package:chess/chess.dart' as ch;
import 'package:flutter_stateless_chessboard/types.dart';
import 'package:fpdart/fpdart.dart';

String getSquare(int rankIndex, int fileIndex, ChessColor orientation) {
  final rank = orientation == ChessColor.BLACK ? rankIndex + 1 : 8 - rankIndex;
  final file = orientation == ChessColor.BLACK ? 7 - fileIndex : fileIndex;
  return '${String.fromCharCode(file + 97)}$rank';
}

List<SquareModel> getSquares(String fen) {
  final chess = ch.Chess.fromFEN(fen);
  return ch.Chess.SQUARES.keys.map((squareName) {
    return SquareModel(
      name: squareName,
      piece: Option.fromNullable(chess.get(squareName)).map(
        (t) => Piece(
          t.color == ch.Color.WHITE ? ChessColor.WHITE : ChessColor.BLACK,
          PieceType.fromString(t.type.toString()),
        ),
      ),
    );
  }).toList(growable: false);
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

Future<PieceType?> defaultPromoting() => Future.value(PieceType.QUEEN);
