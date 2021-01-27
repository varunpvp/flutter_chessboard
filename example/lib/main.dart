import 'package:flutter/material.dart';
import 'package:flutter_chessboard/flutter_chessboard.dart';

import 'utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Random Chess"),
      ),
      body: Center(
        child: Chessboard(
          fen: fen,
          size: size.width,
          onMove: (from, to, piece) {
            final nextFen = makeMove(fen, {
              'from': from,
              'to': to,
              'promotion': 'q',
            });

            if (nextFen != null) {
              setState(() {
                fen = nextFen;
              });

              final nextMove = getRandomMove(fen);

              if (nextMove != null) {
                Future.delayed(Duration(milliseconds: 300)).then((value) {
                  setState(() {
                    fen = makeMove(fen, nextMove);
                  });
                });
              }
            }
          },
        ),
      ),
    );
  }
}
