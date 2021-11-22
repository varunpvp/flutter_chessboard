import 'package:flutter/material.dart';

class UITile extends StatelessWidget {
  final Color color;
  final double size;

  UITile({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: size,
      width: size,
    );
  }
}
