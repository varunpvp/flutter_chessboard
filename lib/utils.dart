import 'package:chess/chess.dart' as ch;
import 'package:flutter_stateless_chessboard/types.dart';

String getSquare(int rankIndex, int fileIndex, String orientation) {
  final rank = orientation == 'b' ? rankIndex + 1 : 8 - rankIndex;
  final file = orientation == 'b' ? 7 - fileIndex : fileIndex;
  return '${String.fromCharCode(file + 97)}$rank';
}

Map<String, Piece> getPieceMap(String fen) {
  final chess = ch.Chess.fromFEN(fen);
  final squares = ch.Chess.SQUARES.keys.toList();
  final map = Map<String, Piece>();
  squares.forEach((square) {
    final piece = chess.get(square);
    if (piece != null) {
      map[square] = Piece(piece.type.toString(), piece.color);
    }
  });
  return map;
}
