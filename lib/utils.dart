import 'package:chess/chess.dart' as ch;
import 'package:flutter_stateless_chessboard/types.dart';

String getSquare(int rankIndex, int fileIndex, Color orientation) {
  final rank = orientation == Color.BLACK ? rankIndex + 1 : 8 - rankIndex;
  final file = orientation == Color.BLACK ? 7 - fileIndex : fileIndex;
  return '${String.fromCharCode(file + 97)}$rank';
}

Map<String, Piece> getPieceMap(String fen) {
  final chess = ch.Chess.fromFEN(fen);
  final squares = ch.Chess.SQUARES.keys.toList();
  final map = Map<String, Piece>();
  squares.forEach((square) {
    final piece = chess.get(square);

    if (piece != null) {
      map[square] = Piece(
        PieceType.fromString(piece.type.toString()),
        piece.color == ch.Color.WHITE ? Color.WHITE : Color.BLACK,
      );
    }
  });
  return map;
}
