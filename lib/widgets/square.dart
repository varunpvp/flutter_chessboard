import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final Color color;
  final double size;
  final Widget child;
  final bool highlight;

  Square({
    @required this.color,
    @required this.size,
    this.child,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: color,
          height: size,
          width: size,
        ),
        if (highlight == true)
          Container(
            color: Color.fromRGBO(128, 128, 128, .3),
            height: size,
            width: size,
          ),
        if (child != null) child,
      ],
    );
  }
}
