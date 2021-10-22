import 'package:chess/chess.dart' as ch;

String? makeMove(String fen, dynamic move) {
  final chess = ch.Chess.fromFEN(fen);

  if (chess.move(move)) {
    return chess.fen;
  }

  return null;
}

String? getRandomMove(String fen) {
  final chess = ch.Chess.fromFEN(fen);

  final moves = chess.moves();

  if (moves.isEmpty) {
    return null;
  }

  moves.shuffle();

  return moves.first;
}
