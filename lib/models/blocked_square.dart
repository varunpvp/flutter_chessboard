import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/square.dart';

class BlockedSquare {
  final String square;
  final Widget Function(Square square) builder;

  BlockedSquare({
    required this.square,
    required this.builder,
  });
}
