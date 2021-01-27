import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final Color color;
  final double size;
  final Widget child;

  Square({
    @required this.color,
    @required this.size,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: size,
      width: size,
      child: child,
    );
  }
}
