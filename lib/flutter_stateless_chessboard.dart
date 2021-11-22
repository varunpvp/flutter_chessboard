library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_board.dart';
import 'models/board_color.dart';

final zeroToSeven = List.generate(8, (index) => index);

class Chessboard extends StatefulWidget {
  late final Board board;

  Chessboard({
    required String fen,
    required double size,
    BoardColor orientation = BoardColor.WHITE,
    Color lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    Color darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
    Moved onMove = noop1,
    Promoted onPromote = defaultPromoting,
  }) {
    board = Board(
      fen: fen,
      size: size,
      orientation: orientation,
      onMove: onMove,
      lightSquareColor: lightSquareColor,
      darkSquareColor: darkSquareColor,
      onPromote: onPromote,
    );
    print('new board');
  }

  @override
  State<StatefulWidget> createState() {
    return _ChessboardState();
  }
}

class _ChessboardState extends State<Chessboard> {
  late Board board;

  @override
  void initState() {
    board = widget.board;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return UIBoard(
      board: board,
      onChange: (newBoard) {
        print('onChange');
        setState(() {
          board = newBoard;
        });
      },
    );
  }
}
